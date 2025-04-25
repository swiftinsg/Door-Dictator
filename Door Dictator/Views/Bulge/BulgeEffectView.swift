//
//  BulgeEffectView.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/23/25.
//

import SwiftUI

struct BulgeEffectView: View {
    
    var points: [CGPoint] = []
    
    let maxPoints = 12
    
    init(points: [CGPoint] = []) {
        let paddedPoints = points + Array(repeating: CGPoint(x: 2, y: 2), count: maxPoints - points.count)
        
        self.points = paddedPoints
    }
    
    var body: some View {
        Image(.grid)
            .resizable()
            .scaledToFill()
            .visualEffect({ content, proxy in
                content
                    .layerEffect(ShaderLibrary.bulgeEffect(
                        .float2(proxy.size),
                        .float3(Float3(point: points[0], radius: 0.1)),
                        .float3(Float3(point: points[1], radius: 0.1)),
                        .float3(Float3(point: points[2], radius: 0.1)),
                        .float3(Float3(point: points[3], radius: 0.1)),
                        .float3(Float3(point: points[4], radius: 0.1)),
                        .float3(Float3(point: points[5], radius: 0.1)),
                        .float3(Float3(point: points[6], radius: 0.1)),
                        .float3(Float3(point: points[7], radius: 0.1)),
                        .float3(Float3(point: points[8], radius: 0.1)),
                        .float3(Float3(point: points[9], radius: 0.1)),
                        .float3(Float3(point: points[10], radius: 0.1)),
                        .float3(Float3(point: points[11], radius: 0.1))
                    ), maxSampleOffset: CGSize(width: 20, height: 20))
            })
    }
}

#Preview {
    BulgeEffectView()
}
