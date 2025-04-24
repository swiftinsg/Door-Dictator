//
//  Camera+FaceDetection.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/25/25.
//

import Foundation
import Vision

extension Camera {
    func detectFaces(in sampleBuffer: ImageBufferContainer) {
        Task(priority: .userInitiated) {
            let request = DetectFaceRectanglesRequest()
            
            let points: [Float3] = try! await request.perform(on: sampleBuffer.buffer)
                .map { observation in
                    Float3(
                        x: observation.boundingBox.cgRect.midX,
                        y: (1 - observation.boundingBox.cgRect.midY),
                        radius: observation.boundingBox.cgRect.width / 2
                    )
                }
            
            await MainActor.run {
                self.normalizedFacePositions = points
            }
        }
    }
}
