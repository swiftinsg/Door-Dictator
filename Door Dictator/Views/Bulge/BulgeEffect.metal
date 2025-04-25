//
//  BulgeEffect.metal
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/23/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>

using namespace metal;

// this function runs on every pixel in the view
[[ stitchable ]]
half4 bulgeEffect(float2 position, SwiftUI::Layer layer,
                  float2 size,
                  float3 p0, float3 p1, float3 p2, float3 p3,
                  float3 p4, float3 p5, float3 p6, float3 p7,
                  float3 p8, float3 p9, float3 p10, float3 p11) {
    
    half2 uv = half2(position / size);
    half2 finalOffset = half2(0.0);
    
    constexpr half zoomFactor = 2.0;
    half aspectRatio = size.x / size.y;
    
    float3 points[12] = {
        p0, p1, p2, p3,
        p4, p5, p6, p7,
        p8, p9, p10, p11
    };
    
    for (int i = 0; i < 12; i++) {
        half2 center = half2(points[i].xy);
        half radius = half(points[i].z);
        
        half2 delta = uv - center;
        half distance = (delta.x * delta.x) + (delta.y * delta.y) / aspectRatio;
        
        if (distance < radius) {
            half totalZoom = 1.0h / zoomFactor;
            half zoomAdjustment = smoothstep(0.0h, radius, distance);
            totalZoom += zoomAdjustment / 2.0h;
            
            finalOffset += delta * (totalZoom - 1.0h);
        }
    }
    
    half2 newPosition = uv + finalOffset;
    
    return layer.sample(float2(newPosition) * size);
}
