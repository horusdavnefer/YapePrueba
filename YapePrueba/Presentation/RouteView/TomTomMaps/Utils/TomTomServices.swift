//
//  TomTomServices.swift
//  YapePrueba
//
//  Created by iMac on 19/07/24.
//

import TomTomSDKMapDisplay

enum TomTomServices {
    static func register() {
        TomTomSDKMapDisplay.MapsDisplayService.apiKey = Keys.tomtomApiKey
    }
}
