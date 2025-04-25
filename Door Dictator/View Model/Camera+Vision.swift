//
//  Camera+FaceDetection.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/25/25.
//

import Foundation
import Vision
import CoreImage

extension Camera {
    func detectFacesa(in sampleBuffer: ImageBufferContainer) {
        guard visionTask == nil || visionTask?.isCancelled == true else { return }
        
        visionTask = Task(priority: .userInitiated) {
            let request = DetectFaceRectanglesRequest()
            
            let ciImage = CIImage(cvPixelBuffer: sampleBuffer.buffer)
            
            let points: [Float3]? = try? await request.perform(on: ciImage)
                .map { observation in
                    Float3(
                        x: observation.boundingBox.cgRect.midX,
                        y: (1 - observation.boundingBox.cgRect.midY),
                        radius: observation.boundingBox.cgRect.width / 2
                    )
                }
            
            await MainActor.run {
                if let points {
                    normalizedFacePositions = points + Array(repeating: Float3(x: 2, y: 2, radius: 0), count: 12 - points.count)
                }
                visionTask = nil
            }
        }
    }
    
    func detectFaces(in sampleBuffer: ImageBufferContainer) {
        guard visionTask == nil || visionTask?.isCancelled == true else { return }
        
        visionTask = Task(priority: .userInitiated) {
            let imageBuffer = sampleBuffer.buffer
            
            // Create a new CVPixelBuffer to hold a copy
            var copiedBuffer: CVPixelBuffer?
            let status = CVPixelBufferCreate(
                nil,
                CVPixelBufferGetWidth(imageBuffer),
                CVPixelBufferGetHeight(imageBuffer),
                CVPixelBufferGetPixelFormatType(imageBuffer),
                nil,
                &copiedBuffer
            )
            
            guard status == kCVReturnSuccess, let safeBuffer = copiedBuffer else {
                print("Failed to copy pixel buffer")
                return
            }
            
            // Lock base address to do a direct copy
            CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
            CVPixelBufferLockBaseAddress(safeBuffer, [])
            
            let srcBase = CVPixelBufferGetBaseAddress(imageBuffer)
            let dstBase = CVPixelBufferGetBaseAddress(safeBuffer)
            let height = CVPixelBufferGetHeight(imageBuffer)
            let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
            
            memcpy(dstBase, srcBase, height * bytesPerRow)
            
            CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
            CVPixelBufferUnlockBaseAddress(safeBuffer, [])
            
            // Now safe to call async Vision request
            let request = DetectFaceRectanglesRequest()
            do {
                let points = try await request.perform(on: safeBuffer).map { observation in
                    Float3(
                        x: observation.boundingBox.cgRect.midX,
                        y: (1 - observation.boundingBox.cgRect.midY),
                        radius: observation.boundingBox.cgRect.width / 2
                    )
                }
                
                normalizedFacePositions = points + Array(repeating: Float3(x: 2, y: 2, radius: 0), count: 12 - points.count)
                peopleStuckOutside = points.count
                visionTask = nil
            } catch {
                print("Face detection failed: \(error)")
            }
        }
    }

}
