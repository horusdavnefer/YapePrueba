//
//  BackButton.swift
//  YapePrueba
//
//  Created by iMac on 19/07/24.
//

import Foundation
import SwiftUI
struct BackButton: View {
    var width: CGFloat = 30
    var height: CGFloat = 30
    var useShadow: Bool = false
    var presentationMode: Binding<PresentationMode>

    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(ConstantsUi.Images.back) 
                .foregroundColor(ConstantsUi.Colors.colorBlack)
                .frame(width: width, height: height)
                .background(
                    Circle()
                        .foregroundColor(ConstantsUi.Colors.colorWhite)
                        .shadow(color: useShadow ? ConstantsUi.Colors.colorGrayLight : .clear, radius: 8, x: 0, y: 0)
                )
        }
    }
}


