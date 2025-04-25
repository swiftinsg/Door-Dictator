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
    func detectFaces(in sampleBuffer: ImageBufferContainer) {
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
                    normalizedFacePositions = points
                }
                visionTask = nil
            }
        }
    }
}
