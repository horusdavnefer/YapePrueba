//
//  YapeErrorView.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import SwiftUI

struct YapeErrorView: View {
    var yapeErrorTyoe: YapeErrorType?
    let yapeErrorProtocol: YapeErrorProtocol?
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                yapeErrorTyoe?.errorImage
                    .resizable() 
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(71)
            }
            Text(yapeErrorTyoe?.errorTitle)
                .font(.custom(ConstantsUi.Font.medium, size: 20))
                .foregroundColor(ConstantsUi.Colors.colorGrayDark)
                .multilineTextAlignment(.center)
            Text(yapeErrorTyoe?.errorDescription)
                .font(.custom(ConstantsUi.Font.regular, size: 16))
                .foregroundColor(ConstantsUi.Colors.colorGrayLight)
                .multilineTextAlignment(.center)

            Button(action: {
                switch yapeErrorTyoe?.typeReturn {
                case .tryAgain:
                    yapeErrorProtocol?.tryAgain()
                case .close:
                    yapeErrorProtocol?.closeAction()
                case .none:
                    break
                }
            }) {
                Text(yapeErrorTyoe?.buttonTitle)
                    .font(.custom(ConstantsUi.Font.medium, size: 14))
                    .foregroundColor(ConstantsUi.Colors.colorWhite)
                    .multilineTextAlignment(.center)
                    .padding(12)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .background(ConstantsUi.Colors.colorCianLight)
            .cornerRadius(4.0)
            .padding([.leading, .trailing], 0)
            Spacer()
        }
        .padding(42)
    }
}
