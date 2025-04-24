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
                  float2 p0, float2 p1, float2 p2, float2 p3,
                  float2 p4, float2 p5, float2 p6, float2 p7,
                  float2 p8, float2 p9, float2 p10, float2 p11) {
    
    // the pixel's position
    float2 currentOutputPixelPosition = position;
    
    float radius = min(size.x, size.y) * 0.2;
    
    float2 points[12] = { p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11 };
    
    float2 displacements[12] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
    
    for (int i = 0; i < 12; ++i) {
        // bulge center pt
        float2 point = points[i];
        
        // bc all pts are normalised, extra points are all >1, this just filters away all the extras
        if (point.x > 1) { break; }
        
        // unnormalise pt
        float2 center = point * size;
        
        // calculate pixel offset from bulge center
        float2 offset = position - center;
        
        float strength = radius * 0.4;
        
        // calculate distance between current pixel and the point
        float dist = length(offset);
        
        if (dist < radius && dist > 0.001) {
            float2 point = points[i];
            if (point.x > 1) break;
            
            float2 center = point * size;
            float2 offset = position - center;
            float dist = length(offset);
            
            if (dist < radius && dist > 0.001) {
                float t = dist / radius;
                
                // tbh just go to desmos and make it until line look cool.
                float falloff = sin(t * 3.14159265);
                falloff = pow(falloff, 2.0);
                
                if (falloff > 0.001) {
                    float2 direction = normalize(offset);
                    float2 displacement = direction * falloff * strength;
                    
                    displacements[i] = displacement;
                }
            }
        }
    }
    
    // get average displacement, after removing empty ones
    float2 finalDisplacement = 0.0;
    int count = 0;
    
    for (int j = 0; j < 12; ++j) {
        if (displacements[j].x != 0) {
            finalDisplacement += displacements[j];
            count++;
        }
    }
    
    // apply the average displacement to the pixel position
    currentOutputPixelPosition -= finalDisplacement;
    
    // display the pixel at the displaced position instead
    return layer.sample(currentOutputPixelPosition);
}
