//
//  FaceCircleView.swift
//  Door Dictator
//
//  Created by Tristan Chay on 24/4/25.
//

import SwiftUI
import Vision

struct FaceCircleView: View {
    let face: VNFaceObservation
    let viewSize: CGSize

    var body: some View {
        let rect = face.boundingBox
        let size = CGSize(width: rect.width * viewSize.width, height: rect.height * viewSize.height)
        let origin = CGPoint(x: rect.minX * viewSize.width, y: (1 - rect.maxY) * viewSize.height)

        Circle()
            .strokeBorder(Color.green, lineWidth: 2)
            .frame(width: size.width, height: size.height)
            .position(x: origin.x + size.width/2, y: origin.y + size.height/2)
    }
}
