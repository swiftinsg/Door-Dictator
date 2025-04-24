//
//  Camera+Output.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/25/25.
//

import Foundation
import AVFoundation
import CoreImage

extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
    nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let imageBuffer = sampleBuffer.imageBuffer else { return }
        
        let container = ImageBufferContainer(imageBuffer)
        
        Task {
            let tempImage = CIImage(cvImageBuffer: container.buffer).image
            
            await MainActor.run {
                detectFaces(in: container)
                self.image = tempImage
            }
        }
    }
}
