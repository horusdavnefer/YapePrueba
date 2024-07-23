//
//  Content.swift
//  YapePrueba
//
//  Created by iMac on 22/07/24.
//

import Foundation
import SwiftUI
import TomTomSDKMapDisplay
import CoreLocation
struct Content: UIViewRepresentable {
    var mapView = TomTomSDKMapDisplay.MapView()
    var navigationController: NavigationController
    var endCoord: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> TomTomSDKMapDisplay.MapView {
        mapView.delegate = context.coordinator
        
        return mapView
    }

    func updateUIView(_: TomTomSDKMapDisplay.MapView, context: Context) {}

    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(mapView, navigationController: navigationController, endCoord: endCoord)
    }
}
