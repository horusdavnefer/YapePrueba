//
//  ButtonSelectedView.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import SwiftUI

struct ButtonSelectedView: View {
    var loading: Bool
    var cellType: CellType
    var cellTypeSelected: CellType
    var imageDefault: Image
    var imageSelected: Image
    var onAction: (_ item: CellType) -> Void

    var body: some View {
        return Button {
            self.onAction(cellType)
        } label: {
            cellTypeSelected == cellType ?
                imageSelected
                .renderingMode(.original) :
                imageDefault
                .renderingMode(.original)
        }
        .skeleton(with:  loading,
              animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
    }
}
