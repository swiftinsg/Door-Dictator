//
//  Float3.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/25/25.
//

import Foundation

struct Float3: Sendable {
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
    
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(x: CGFloat, y: CGFloat, radius z: CGFloat) {
        self.x = x
        self.y = y
        self.z = z
    }
}
