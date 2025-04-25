//
//  CameraBulgeView.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/25/25.
//

import SwiftUI

struct CameraBulgeView: View {
    
    @Environment(Camera.self) var camera: Camera
    
    @MainActor
    var body: some View {
        let points = camera.normalizedFacePositions
        if let image = camera.image {
            image
                .resizable()
                .scaledToFill()
                .visualEffect({ content, proxy in
                    content
                        .layerEffect(ShaderLibrary.bulgeEffect(
                            .float2(proxy.size),
                            .float3(points[0]),
                            .float3(points[1]),
                            .float3(points[2]),
                            .float3(points[3]),
                            .float3(points[4]),
                            .float3(points[5]),
                            .float3(points[6]),
                            .float3(points[7]),
                            .float3(points[8]),
                            .float3(points[9]),
                            .float3(points[10]),
                            .float3(points[11])
                        ), maxSampleOffset: .zero)
                })
        }
    }
}

#Preview {
    CameraBulgeView()
}
