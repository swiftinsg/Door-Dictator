//
//  CameraViewModel.swift
//  Door Dictator
//
//  Created by Tristan Chay on 24/4/25.
//

import SwiftUI
import AVFoundation
import Vision

@Observable
class Camera: NSObject {
    var isLoading = false
    var availableCameras: [AVCaptureDevice] = []
    var detectedFaces: [VNFaceObservation] = []
    var facePositions: [CGPoint] = []
    var selectedCameraIndex: Int = 0 {
        didSet {
            if oldValue != selectedCameraIndex && selectedCameraIndex < availableCameras.count {
                switchToCamera(at: selectedCameraIndex)
            }
        }
    }

    private var currentFrameSize: CGSize = .zero

    let captureSession = AVCaptureSession()
    private var currentInput: AVCaptureDeviceInput?
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue", qos: .userInteractive)

    override init() {
        super.init()
        captureSession.sessionPreset = .high
    }

    func checkPermissionsAndSetupCameras() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCameraSources()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setupCameraSources()
                    }
                } else {
                    print("FAILED")
                }
            }
        case .denied, .restricted:
            print("too bad")
        @unknown default:
            print("what")
        }
    }

    func setupCameraSources() {
        DispatchQueue.main.async {
            self.isLoading = true
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera, .external],
                mediaType: .video,
                position: .unspecified
            )

            let cameras = discoverySession.devices

            DispatchQueue.main.async {
                self.availableCameras = cameras

                if !cameras.isEmpty {
                    self.selectedCameraIndex = 0
                    self.switchToCamera(at: 0)
                } else {
                    self.isLoading = false
                }
            }
        }
    }

    private func switchToCamera(at index: Int) {
        guard index < availableCameras.count else { return }

        DispatchQueue.main.async {
            self.isLoading = true
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

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

    private func detectFaces(in sampleBuffer: CMSampleBuffer) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }

            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }

            let width = CVPixelBufferGetWidth(imageBuffer)
            let height = CVPixelBufferGetHeight(imageBuffer)
            currentFrameSize = CGSize(width: width, height: height)

            guard let image = createUIImage(from: imageBuffer),
                  let imageData = image.pngData() else {
                return
            }

            let requestHandler = VNImageRequestHandler(data: imageData, orientation: .up, options: [:])

            let detectFaceRequest = VNDetectFaceRectanglesRequest { [weak self] (request, error) in
                guard let self = self else { return }

                if let error = error {
                    print("face detection error: \(error.localizedDescription)")
                    return
                }

                if let results = request.results as? [VNFaceObservation] {
                    DispatchQueue.main.async {
                        self.detectedFaces = results
                        self.updateFacePositions(from: results)
                    }
                }
            }

            detectFaceRequest.revision = VNDetectFaceRectanglesRequestRevision3

            do {
                try requestHandler.perform([detectFaceRequest])
            } catch {
                print("face detection error: \(error.localizedDescription)")
            }
        }
    }

    private func updateFacePositions(from faces: [VNFaceObservation]) {
        var positions: [CGPoint] = []

        for face in faces {
            let centerX = face.boundingBox.midX
            let centerY = face.boundingBox.midY

            let point = CGPoint(
                x: centerX * 1920,
                y: (1 - centerY) * 1080
            )

            positions.append(point)

            if positions.count >= 12 {
                break
            }
        }

        self.facePositions = positions
    }

    private func createUIImage(from pixelBuffer: CVPixelBuffer) -> NSImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return NSImage(cgImage: cgImage, size: NSSize(width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer)))
    }
}

extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.detectFaces(in: sampleBuffer)
        }
    }
}
