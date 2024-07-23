//
//  Image+Extensions.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import SwiftUI

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .resizable()
            .scaledToFill()
            .scaledToFit()
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
