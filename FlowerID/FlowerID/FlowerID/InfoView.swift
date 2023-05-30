//
//  InfoView.swift
//  FlowerID
//
//  Created by Audrey on 22/05/23.
//

import SwiftUI

struct flower {
    var name: String
    var description: String
    var imagename : String
}

var flowers: [flower] = [
    
    flower(name: "Aster", description: "Symbolize love, wisdom, faith, and color", imagename: "aster"),
    flower(name: "Baby’s Breath", description: "Symbolizes everlasting love and innocence", imagename: "babysbreath"),
    flower(name: "Bougainvillea", description: "Symbolizes passion, beauty, and great for welcoming visitors", imagename: "bougainvillea"),
    flower(name: "Chrysanthemum", description: "Symbolizes friendship, well-being and arrival of autumn", imagename: "chrysanthemum"),
    flower(name: "Daisy", description: "Symbolizes innocence, new beginnings, and cheerfulness", imagename: "daisy"),
    flower(name: "Dandelion", description: "Symbolizes growth, hope, and healing", imagename: "dandelion"),
    flower(name: "Gardenia", description: "Symbolizes purity, gentleness, and secret love", imagename: "gardenia"),
    flower(name: "Hibiscus", description: "Symbolizes positivity, cheer, and “good luck” gift.", imagename: "hibiscus"),
    flower(name: "Hydrangea", description: "Symbolizes gratitude, grace and beauty", imagename: "hydrangea"),
    flower(name: "Jasmine", description: "Symbolizes purity, sensuality, modesty, and inspiration", imagename: "jasmine"),
    flower(name: "Lavender", description: "Symbolizes purity, devotion, serenity, and calmness", imagename: "lavender"),
    flower(name: "Lily", description: "Symbolizes purity and fertility, fresh life and rebirth", imagename: "lily"),
    flower(name: "Lily of the Valley", description: "Symbolizes motherhood, humility, and virtue", imagename: "lilyofthevalley"),
    flower(name: "Marigold", description: "Symbolizes symbolize positive emotions and energy", imagename: "marigold"),
    flower(name: "Orchid", description: "Symbolizes good luck and a congratulations flower", imagename: "orchid"),
    flower(name: "Peony", description: "Symbolize honor, happiness, wealth, and bashfulness", imagename: "peony"),
    flower(name: "Poppy", description: "Symbolizes remembrance and hope for a peaceful future", imagename: "poppy"),
    flower(name: "Rose", description: "Symbolize love, passion and admiration", imagename: "rose"),
    flower(name: "Sunflower", description: "Symbolizes positivity, loyalty and adoration", imagename: "sunflower"),
    flower(name: "Tulip", description: "Symbolizes perfect or deep love", imagename: "tulip")
    
]


struct InfoView: View {
    
    @Binding var showing: Bool
    @Binding var resultText : String
    
    @State private var curHeight: CGFloat = 220
    @State private var prevDragTranslation = CGSize.zero
    
    
    let minHeight: CGFloat = 220
    let maxHeight: CGFloat = 700
    
    var body: some View {
        ZStack(alignment: .bottom){
            if showing{
                
                Color(.black)
                    .opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showing = false
                    }
                
                
                mainView
                    .transition(.move(edge: .bottom))
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut)
    }
    
    var mainView: some View{
        VStack{
            ZStack{
                Capsule()
                
                    .frame(width: 60, height: 6)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.0001))
            .gesture(dragGesture)
            ZStack{
                if(curHeight < 300){
                    
                    
                    
                    VStack(alignment: .leading){
                        Text(resultText)
                            .titleStyle()
                        
                        
                        if let description = description(for: resultText){
                            Text(description)
                                .bodyStyle()
                        }
                        
                        
                        
                    }
                    .padding(.horizontal)
                }else{
                    VStack(){
                        VStack(alignment: .center){
                            if let imagename = imagename(for: resultText){
                                Image(imagename)
                                    .resizable()
                                    .frame(width: 220, height: 220)
                            }
                        }
                        
                        
                        VStack(alignment: .leading){
                            Text(resultText)
                                .titleStyle()
                            
                            
                            if let description = description(for: resultText){
                                Text(description)
                                    .bodyStyle()
                            }
                        }
                        
                    }
                    .frame(width: .infinity)
                     .padding(.horizontal)
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom, 35)
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background(
            
                ZStack{
                    RoundedRectangle(cornerRadius: 40)
                        .foregroundColor(Color("mint"))
                    Rectangle()
                        .frame(height: curHeight / 2 )
                    
                    
                }
                    .foregroundColor(.clear)
                
            )
            
    }
    
    var dragGesture: some Gesture{
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged{
                val in
                
                let dragAmount = val.translation.height - prevDragTranslation.height
                
                if curHeight > maxHeight || curHeight < minHeight{
                    curHeight -= dragAmount / 6
                }else{
                    curHeight -= dragAmount
                }
                
                prevDragTranslation = val.translation
            }
            .onEnded{ val in
                prevDragTranslation = .zero
            }
    }
}


func description(for name: String) -> String? {
    return flowers.first {
        $0.name.localizedCaseInsensitiveContains(name)
    }?.description
}

func imagename(for name: String) -> String? {
    return flowers.first {
        $0.name.localizedCaseInsensitiveContains(name)
    }?.imagename
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(showing: .constant(true), resultText: .constant("Gardenia"))
    }
}
