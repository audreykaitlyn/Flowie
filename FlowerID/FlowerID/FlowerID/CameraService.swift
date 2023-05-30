//
//  CameraService.swift
//  FlowerID
//
//  Created by Audrey on 21/05/23.
//

import Foundation
import AVFoundation
import UIKit

class CameraService {
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    private func checkPermissions(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let session = AVCaptureSession()
            
            if let device = AVCaptureDevice.default(for: .video) {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    if session.canAddInput(input) {
                        session.addInput(input)
                    }
                    
                    if session.canAddOutput(self?.output ?? AVCapturePhotoOutput()) {
                        session.addOutput(self?.output ?? AVCapturePhotoOutput())
                    }
                    
                    self?.previewLayer.videoGravity = .resizeAspect
                    self?.previewLayer.session = session
                    
                    session.startRunning()
                    self?.session = session
                    
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(error)
                    }
                }
            }
        }
    }
    
    func restartSession() {
        stopSession()
        start(delegate: delegate!, completion: { error in
            if error != nil {
                // Handle the error
            } else {
                // Session restarted successfully
            }
        })
    }
    
    private func stopSession() {
        session?.stopRunning()
        session = nil
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        guard let connection = output.connection(with: .video) else {
            // Handle the case when there is no video connection available
            return
        }
        
        connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue) ?? .portrait
        
        output.capturePhoto(with: settings, delegate: delegate!)
    }
}
