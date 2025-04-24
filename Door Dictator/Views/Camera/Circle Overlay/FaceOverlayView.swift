//
//  FaceOverlayView.swift
//  Door Dictator
//
//  Created by Tristan Chay on 24/4/25.
//

import SwiftUI
import Vision

struct FaceOverlayView: View {
    let faces: [VNFaceObservation]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(faces, id: \.uuid) { face in
                    FaceCircleView(face: face, viewSize: geometry.size)
                }
            }
        }
    }
}
