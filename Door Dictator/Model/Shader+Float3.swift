//
//  Shader+Float3.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/25/25.
//

import Foundation
import SwiftUI

extension Shader.Argument {
    static func float3(_ value: Float3) -> Shader.Argument {
        Self.float3(value.x, value.y, value.z)
    }
}
