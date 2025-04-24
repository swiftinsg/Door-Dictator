//
//  CameraViewModel.swift
//  Door Dictator
//
//  Created by Tristan Chay on 24/4/25.
//

import SwiftUI
import AVFoundation

@Observable
@MainActor
final class Camera: NSObject, Sendable {
    
    var isLoading = false
    
    var availableCameras: [AVCaptureDevice] = []
    
    var image: Image?
    
    var normalizedFacePositions: [Float3] = []
    
    var selectedCameraIndex: Int = 0 {
        didSet {
            if oldValue != selectedCameraIndex && selectedCameraIndex < availableCameras.count {
                switchToCamera(at: selectedCameraIndex)
            }
        }
    }

    @ObservationIgnored
    let captureSession = AVCaptureSession()
    
    @ObservationIgnored
    private var currentInput: AVCaptureDeviceInput?
    
    @ObservationIgnored
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    @ObservationIgnored
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue", qos: .userInteractive)

    override init() {
        super.init()
        captureSession.sessionPreset = .high
    }

    func checkPermissionsAndSetupCameras() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            await setupCameraSources()
        case .notDetermined:
            if await AVCaptureDevice.requestAccess(for: .video) {
                await setupCameraSources()
            } else {
                print("oops no access")
            }
        case .denied, .restricted:
            print("too bad")
        @unknown default:
            print("what")
        }
    }

    func setupCameraSources() async {
        await MainActor.run {
            self.isLoading = true
        }
        
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .external],
            mediaType: .video,
            position: .unspecified
        )
        
        let cameras = discoverySession.devices
        
        self.availableCameras = cameras
        
        await MainActor.run {
            if !availableCameras.isEmpty {
                self.selectedCameraIndex = 0
                self.switchToCamera(at: 0)
            } else {
                self.isLoading = true
            }
        }
    }

    private func switchToCamera(at index: Int) {
        guard index < availableCameras.count else { return }

        isLoading = true
        
        Task {
            let selectedCamera = self.availableCameras[index]
            
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
            
            self.captureSession.beginConfiguration()
            
            if let currentInput = self.currentInput {
                self.captureSession.removeInput(currentInput)
                self.currentInput = nil
            }
            
            for output in self.captureSession.outputs {
                self.captureSession.removeOutput(output)
            }
            
            do {
                let newInput = try AVCaptureDeviceInput(device: selectedCamera)
                
                if self.captureSession.canAddInput(newInput) {
                    self.captureSession.addInput(newInput)
                    self.currentInput = newInput
                    
                    self.videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
                    self.videoDataOutput.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue)
                    self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
                    
                    if self.captureSession.canAddOutput(self.videoDataOutput) {
                        self.captureSession.addOutput(self.videoDataOutput)
                    }
                    
                    if let connection = self.videoDataOutput.connection(with: .video) {
                        connection.isEnabled = true
                        
                        connection.videoRotationAngle = .zero
                    }
                    
                    self.captureSession.commitConfiguration()
                    self.captureSession.startRunning()
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } catch {
                print("error switching: \(error.localizedDescription)")
                self.captureSession.commitConfiguration()
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}
