//
//  TabViewItem.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Foundation
import SwiftUI

struct TabViewItem: View {
    let paddingText: CGFloat = 3.0
    let contentPadding: CGFloat = 12.0
    let cornerRadius: CGFloat = 45.0
    var text: String?
    var loading: Bool
    //let selectedContentColor: Color = ConstantsUi.Colors.colorCianDark
    //let contentColor: Color = ConstantsUi.Colors.colorBlack
    //var onAction: (_ item: CategoryObject?) -> Void

    var body: some View {
        return Button(action: {
            //self.onAction(category)
        }) {
            Text(text)
                .fixedSize(horizontal: true, vertical: false)
                .padding(contentPadding)
                .font(.custom(ConstantsUi.Font.regular, size: 15))
                .foregroundColor(ConstantsUi.Colors.colorGrayDark)
                
                
        }
        .skeleton(with:  loading,
          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
        .background(ConstantsUi.Colors.colorShadowLight)
        .cornerRadius(cornerRadius)
        .frame(minWidth: 82, minHeight: 53)
    }
}

