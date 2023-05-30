//
//  ContentView.swift
//  FlowerID
//
//  Created by Audrey on 19/05/23.
//

import SwiftUI
import CoreML
import Vision


struct ContentView: View {
    
    //Variable

    @Environment(\.presentationMode) private var presentationMode
    
    @State var cameraService = CameraService()
    @State var showRetry = false
    
    @State private var capturedImage: UIImage? = nil
    @State private var captureToggle = false
    @State private var resultText: String = ""
    @State private var showing = false
   
    let overlayText: String = "Place text here"
    
    
    //Initialize ML
    let flowerClassifier: VNCoreMLModel = {
        do {
            let config = MLModelConfiguration()
            let model = try FlowerClass(configuration: config)
            return try VNCoreMLModel(for: model.model)
        } catch {
            fatalError("Failed to load Core ML model: \(error)")
        }
    }()
    
    var body: some View {
        NavigationView{
        ZStack{
            
            if capturedImage != nil {
                
                Image(uiImage: capturedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            } else {
                
                CameraView(cameraService: cameraService) { result in
                    switch result {
                        
                    case .success(let photo):
                        if let data = photo.fileDataRepresentation() {
                            capturedImage = UIImage(data: data)
                            capturedImage = cropToCircle(capturedImage!)
                            performImageAnalysis(image: capturedImage)
                        } else {
                            print("Error: no image data found")
                        }
                        
                    case .failure(let err):
                        print(err.localizedDescription)
                        
                    }
                }
                .clipShape(Circle())
                
            }
            
            Image("teropong")
            
            VStack(alignment: .leading){
                if showRetry == true {
                    
                    Button(action:{
                        capturedImage = nil
                        captureToggle = false
                        withAnimation {
                            showRetry = false
                        }

                    }, label: {
                        Image(systemName: "gobackward")
                            .font(.system(size: 25))
                            .foregroundColor(Color("mint"))
                            .padding(.bottom, 2)
                    })
                }
                
                Text("Capture Your \nFlower")
                    .titleStyle()
                    .padding(.bottom, 2)
                    .padding(.top, showRetry ? 0 : 45)
                
                Text("Discover your own unique flower")
                    .bodyStyle()
                
                HStack{
                    Spacer().frame(width: 300)
                }
                
                Spacer()
                
            }
            .padding(.top, 50)
            
            VStack(alignment: .center){
                
                Spacer()
                
                Button(action: {
                    cameraService.capturePhoto()
                    captureToggle = true
                    withAnimation{
                        showRetry = true
                    }
                    showing = true
                    self.cameraService = CameraService()
                }, label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundColor(Color("mint"))
                        .padding(.bottom, 35)
                })
            }
            
            if showing {
                InfoView(showing: $showing, resultText: $resultText)
                    .transition(.scale)
                    .animation(.easeIn(duration: 20))
            }
            
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
        
        .edgesIgnoringSafeArea(.all)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func cropToCircle(_ image: UIImage) -> UIImage? {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: .zero, size: image.size)
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0.0)
        let path = UIBezierPath()
        let center = CGPoint(x: imageView.bounds.midX, y: imageView.bounds.midY)
        let radius = min(imageView.bounds.width, imageView.bounds.height) / 2.0
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path.addClip()
        
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
    
    func performImageAnalysis(image: UIImage?) {
        guard let image = image,
              let ciImage = CIImage(image: image) else {
            return
        }
        
        do {
            let request = VNCoreMLRequest(model: flowerClassifier) { request, error in
                if let error = error {
                    DispatchQueue.main.async {
                        resultText = "Error analyzing image: \(error.localizedDescription)"
                    }
                    return
                }
                
                guard let results = request.results as? [VNClassificationObservation],
                      let topResult = results.first else {
                    DispatchQueue.main.async {
                        resultText = "No results found"
                    }
                    return
                }
                
                let flowerName = topResult.identifier
//                let confidence = topResult.confidence
                
                let resultString = "\(flowerName)"
                DispatchQueue.main.async {
                    resultText = resultString
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            try handler.perform([request])
        } catch {
            DispatchQueue.main.async {
                resultText = "Error initializing VNCoreMLRequest: \(error.localizedDescription)"
            }
        }
    }
}

struct YourView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
