//
//  ConstantsUI.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import SwiftUI
import UIKit

struct ConstantsUi {
    struct Font {
        static let medium = "Roboto-Medium"
        static let light = "Roboto-Light"
        static let regular = "Roboto-Regular"
        static let mediumThinItalic = "Roboto-MediumItalic"
        static let thinItalic = "Roboto-ThinItalic"
        static let boldItalic = "Roboto-BoldItalic"
        static let lightItalic = "Roboto-LightItalic"
        static let italic = "Roboto-Italic"
        static let blackItalic = "Roboto-BlackItalic"
        static let bold = "Roboto-Bold"
        static let thin = "Roboto-Thin"
        static let black = "Roboto-Black"
    }
    
    struct Colors {
        static let colorCianDark: Color = .init(hex: "009BDD")
        static let colorCianLight: Color = .init(hex: "3FA7FF")
        static let colorGrayDark: Color = .init(hex: "2D3338")
        static let colorGrayLight: Color = .init(hex: "828EA5") 
        static let colorGrayClean: Color = .init(hex: "#E7EBF3")
        static let colorGrayTerms: Color = .init(hex: "AGAFCA")
        static let colorGraySubTitle: Color = .init(hex: "707382")
        static let colorWhite: Color = .init(hex: "FFFFFF")
        static let colorWhiteBackground: Color = .init(hex: "F9FBFE")
        static let colorCyanBackgorund: Color = .init(hex: "EBF6FF")
        static let colorShadowLight: Color = .init(hex: "0E15200A")
        static let colorRed: Color = .init(hex: "FF4B4B")
        static let colorBlack: Color = .init(hex: "000000")

    }
    
    class ClassBundle {}
    static var bundle : Bundle { return Bundle(for: ConstantsUi.ClassBundle.self) }
    
    struct Images {
        static let back = "ic_back"
        static let car = "ic_car"
        static let logo = "gr_logo_white"
        static let map = "ic_map"
        static let phoneApp = "ic_phone_app"
        static let route = "ic_route"
        static let search = "ic_search"
        static let iconArrowDown: Image = Image("IconArrowDown", bundle: bundle)
        static let iconArrowUp: Image = Image("IconArrowUp", bundle: bundle)
        static let iconBenefitDigital: Image = Image("IconBenefitDigital", bundle: bundle)
        static let iconBenefitFaceToFace: Image = Image("IconBenefitFaceToFace", bundle: bundle)
        static let iconCalendar: Image = Image("IconCalendar", bundle: bundle)
        static let iconClose: Image = Image("IconClose", bundle: bundle)
        static let iconCloseWhite: Image = Image("iconCloseWhite", bundle: bundle)
        static let iconCopyPaste: Image = Image("IconCopyPaste", bundle: bundle)
        static let iconCube: Image = Image("Iconcube", bundle: bundle)
        static let iconCubeSelected: Image = Image("IconcubeSelected", bundle: bundle)
        static let iconList: Image = Image("IconList", bundle: bundle)
        static let iconListSelected: Image = Image("IconListSelected", bundle: bundle)
        static let iconMenuLeft: Image = Image("IconMenuLeft", bundle: bundle)
        static let iconCheck: Image = Image("iconCheck", bundle: bundle)
        
        static let iconDiscountEmpty: Image = Image("IconDiscountEmpty", bundle: bundle)
        static let IconError400: Image = Image("IconError400", bundle: bundle)
        static let iconError403: Image = Image("IconError403", bundle: bundle)
        static let iconError404: Image = Image("IconError404", bundle: bundle)
        static let iconErrorNoInternetConnection: Image = Image("IconErrorNoInternetConnection", bundle: bundle)
    }
}

