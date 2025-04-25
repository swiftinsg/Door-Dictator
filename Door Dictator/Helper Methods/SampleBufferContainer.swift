//
//  SampleBufferContainer.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/25/25.
//

import Foundation
import SwiftUI
import CoreMedia

final class ImageBufferContainer: @unchecked Sendable {
    let buffer: CVImageBuffer
    
    init(_ buffer: CVImageBuffer) {
        self.buffer = buffer
    }
}
