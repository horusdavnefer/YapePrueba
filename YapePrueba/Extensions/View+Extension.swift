//
//  View+Extension.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Foundation
import SwiftUI

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
