//
//  MapCoordinator.swift
//  YapePrueba
//
//  Created by iMac on 21/07/24.
//
import Combine
import CoreLocation
import Foundation
import SwiftUI

import TomTomSDKDefaultTextToSpeech
import TomTomSDKLocationProvider
import TomTomSDKMapDisplay
import TomTomSDKNavigation
import TomTomSDKNavigationEngines
import TomTomSDKNavigationOnline
import TomTomSDKNavigationTileStore
import TomTomSDKNavigationUI
import TomTomSDKRoute
import TomTomSDKRoutePlanner
import TomTomSDKRoutePlannerOnline
import TomTomSDKRouteReplannerDefault
import TomTomSDKRoutingCommon


final class MapCoordinator: NSObject, LocationUpdateObserver {
    
    private let navigationController: NavigationController
    private let mapView: TomTomSDKMapDisplay.MapView
    private var map: TomTomSDKMapDisplay.TomTomMap?
    private var routeOnMap: TomTomSDKMapDisplay.Route?
    private var cameraUpdated = false
    private var cancellableBag = Set<AnyCancellable>()
    private var endCoord: CLLocationCoordinate2D?
    var recipe: RecipeObject?
    
    
    func didUpdateLocation(location: TomTomSDKLocationProvider.GeoLocation) {
        animateCamera(
            zoom: 9.0,
            position: location.location.coordinate,
            animationDurationInSeconds: 1.5,
            onceOnly: true
        )
    }
    
   
    
    // MARK: Lifecycle

    init(_ mapView: TomTomSDKMapDisplay.MapView, navigationController: NavigationController, endCoord: CLLocationCoordinate2D?) {
        self.navigationController = navigationController
        self.mapView = mapView
        self.endCoord = endCoord
        super.init()
        self.navigationController.endCoord = endCoord
        
        
        observe(navigationController: navigationController)
    }

    // MARK: Internal

    func setContentInsets(edgeInsets: EdgeInsets) {
        mapView.contentInsets = NSDirectionalEdgeInsets(
            top: edgeInsets.top,
            leading: edgeInsets.leading,
            bottom: edgeInsets.bottom,
            trailing: edgeInsets.trailing
        )
    }

    // MARK: Private

    
}



extension MapCoordinator: TomTomSDKMapDisplay.MapViewDelegate {
    func mapView(_: MapView, onMapReady map: TomTomMap) {
        // Store the map to be used later
        self.map = map

        // Observe TomTom map actions
        map.delegate = self
        // Observe location engine updates
        map.locationProvider.addObserver(self)
        // Hide the traffic on the map
        map.hideTraffic()
        // Display a chevron at the current location
        map.locationIndicatorType = .navigationChevron(scale: 1)
        // Activate the GPS location engine in TomTomSDK.
        map.activateLocationProvider()
        // Configure the camera to centre on the current location
        map.applyCamera(defaultCameraUpdate)
    }

    func mapView(_: MapView, onLoadFailed error: Error) {
        print("Error occured loading the map \(error.localizedDescription)")
    }

    func mapView(_: MapView, onStyleLoad _: Result<StyleContainer, Error>) {
        print("Style loaded")
    }
}

extension MapCoordinator {
    private var defaultCameraUpdate: CameraUpdate {
        let defaultLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        return CameraUpdate(
            position: defaultLocation.coordinate,
            zoom: 1.0,
            tilt: 0.0,
            rotation: 0.0,
            positionMarkerVerticalOffset: 0.0
        )
    }

    func animateCamera(zoom: Double, position: CLLocationCoordinate2D, animationDurationInSeconds: TimeInterval, onceOnly: Bool) {
        if onceOnly, cameraUpdated {
            return
        }
        cameraUpdated = true
        var cameraUpdate = defaultCameraUpdate
        cameraUpdate.zoom = zoom
        cameraUpdate.position = position
        map?.applyCamera(cameraUpdate, animationDuration: animationDurationInSeconds)
    }

    func setCamera(trackingMode: TomTomSDKMapDisplay.CameraTrackingMode) {
        map?.cameraTrackingMode = trackingMode

        // Update chevron position on the screen so it is not hidden behind the navigation panel
        if trackingMode == .followRoute || trackingMode == .follow {
            let cameraUpdate = CameraUpdate(positionMarkerVerticalOffset: 0.4)
            moveCamera(cameraUpdate: cameraUpdate)
        }
    }

    func moveCamera(cameraUpdate: CameraUpdate) {
        map?.moveCamera(cameraUpdate)
    }
}


extension MapCoordinator: TomTomSDKMapDisplay.MapDelegate {
    func map(_: TomTomMap, onInteraction interaction: MapInteraction) {
        switch interaction {
        case let .longPressed(coordinate):
            navigationController.navigateToCoordinate(coordinate)
        default:
            // Handle other gestures
            break
        }
    }

    func map(_: TomTomMap, onCameraEvent event: CameraEvent) {
        switch event {
        case let .trackingModeChanged(mode):
            // Handle camera tracking mode change
            break
        default:
            break
        }
    }
}

/// Add an extension to NavigationController with a navigateToCoordinate function that plans a route, starts location simulation and starts the navigation process.
///
/// The call to the async planRoute function is wrapped in a Task so that it can be called from the navigateToCoordinate function, even though that function is not async.
/// Do not use Navigation directly to start navigation along the route when using NavigationView.
/// Instead, use its NavigationView.ViewModel for that. It will also handle both the visual and voice instructions.
extension NavigationController {
    func navigateToCoordinate(_ destination: CLLocationCoordinate2D) {
        Task { @MainActor in
            do {
                // Plan the route and add it to the map
                let start = try startCoordinate()
                let routePlan = try await planRoute(from: start, to: destination)

                stopNavigating()

                let route = routePlan.route
                self.displayedRouteSubject.send(route)

                let navigationOptions = NavigationOptions(activeRoutePlan: routePlan)
                self.navigationViewModel!.start(navigationOptions)

                // Start navigation after a short delay so that we can clearly see the transition to the driving view
                try await Task.sleep(nanoseconds: UInt64(1.0 * 1_000_000_000))

                // Use simulated location updates
                //self.simulatedLocationProvider.updateCoordinates(route.geometry, interpolate: true)
                //self.simulatedLocationProvider.enable()
                //self.mapMatchedLocationProvider.send(navigation.mapMatchedLocationProvider)

                self.showNavigationView = true
            } catch {
                print("Error when planning a route: \(error)")
            }
        }
    }

    func stopNavigating() {
        displayedRouteSubject.send(nil)
        navigationViewModel!.stop()
        //simulatedLocationProvider.disable()
        showNavigationView = false
    }
}

// MARK: - Route planning

/// Create a NavigationController extension for the route planning functions
extension NavigationController {
    enum RoutePlanError: Error {
        case unknownStartingLocation
        case unableToPlanRoute(_ description: String = "")
    }

    private func startCoordinate() throws -> CLLocationCoordinate2D {
        //if let simulatedPosition = simulatedLocationProvider.lastKnownLocation?.location.coordinate {
        //    return simulatedPosition
        //}
       // if let currentPosition = locationProvider.lastKnownLocation?.location.coordinate {
        if let currentPosition = locationProvider.lastKnownLocation?.location.coordinate {
            return currentPosition
        } else {
            var defaultLocation = CLLocationCoordinate2D()//4.513600649117507, -74.11264536657632
            defaultLocation.latitude = Double("4.513600649117507")!
            defaultLocation.longitude = Double("-74.11264536657632")!
            return defaultLocation
        }
        
        
        //throw RoutePlanError.unknownStartingLocation
    }

    private func createRoutePlanningOptions(
        from origin: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D
    )
        throws -> TomTomSDKRoutePlanner.RoutePlanningOptions
    {
        let itinerary = Itinerary(
            origin: ItineraryPoint(coordinate: origin),
            destination: ItineraryPoint(coordinate: destination)
        )
        let costModel = CostModel(routeType: .fast)

        // Use language code from Supported languages list:
        // https://developer.tomtom.com/routing-api/documentation/routing/calculate-route#supported-languages
        // For voice announcements:
        let languageCode = Locale.preferredLanguages.first ?? Locale.current.languageCode ?? "en-GB"
        let locale = Locale(identifier: languageCode)
        let guidanceOptions = try GuidanceOptions(
            instructionType: .tagged,
            language: locale,
            roadShieldReferences: .all,
            announcementPoints: .all,
            phoneticsType: .IPA,
            progressPoints: .all
        )

        let options = try RoutePlanningOptions(
            itinerary: itinerary,
            costModel: costModel,
            guidanceOptions: guidanceOptions
        )
        return options
    }

    private func planRoute(
        from origin: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D
    ) async throws
        -> TomTomSDKNavigationEngines.RoutePlan
    {
        let routePlanningOptions = try createRoutePlanningOptions(from: origin, to: destination)
        let route = try await planRoute(withRoutePlanner: routePlanner, routePlanningOptions: routePlanningOptions)
        return TomTomSDKNavigationEngines.RoutePlan(route: route, routePlanningOptions: routePlanningOptions)
    }

    private func planRoute(
        withRoutePlanner routePlanner: OnlineRoutePlanner,
        routePlanningOptions: RoutePlanningOptions
    ) async throws
        -> TomTomSDKRoute.Route
    {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<TomTomSDKRoute.Route, Error>) in
            routePlanner.planRoute(options: routePlanningOptions, onRouteReady: nil) { result in
                switch result {
                case let .failure(error):
                    if let routingError = error as? RoutingError {
                        print("Error code: \(routingError.code)")
                        print("Error message: \(String(describing: routingError.errorDescription))")
                        continuation.resume(throwing: routingError)
                        return
                    }
                    continuation.resume(throwing: error)
                case let .success(response):
                    guard let routes = response.routes else {
                        continuation.resume(throwing: RoutePlanError.unableToPlanRoute())
                        return
                    }
                    guard let route = routes.first else {
                        continuation.resume(throwing: RoutePlanError.unableToPlanRoute())
                        return
                    }
                    continuation.resume(returning: route)
                }
            }
        }
    }
}

/// Update the MapCoordinator extension with the observe function to display changes to the current route and its progress on the map.
///
/// After adding a route on the map, you will receive a reference to that route.
/// The addRouteToMap function keeps it in the routeOnMap so that it can show the visual progress along the route, without being added again.
/// The default location provider has an approximate position but no route information.
/// For smooth movement of the chevron along the route, ensure the map uses a mapMatchedLocationProvider from Navigation instead of the SimulatedLocationProvider.
extension MapCoordinator {
    func observe(navigationController: NavigationController) {
        navigationController.displayedRouteSubject.sink { [weak self] route in
            guard let self = self else { return }
            if let route = route {
                self.addRouteToMap(route: route)
                self.setCamera(trackingMode: .followRoute)
            } else {
                self.routeOnMap = nil
                self.map?.removeRoutes()
                self.setCamera(trackingMode: .follow)
            }
        }.store(in: &cancellableBag)

        navigationController.progressOnRouteSubject.sink { [weak self] progress in
            self?.routeOnMap?.progressOnRoute = progress
        }.store(in: &cancellableBag)

        navigationController.mapMatchedLocationProvider.sink { [weak self] locationProvider in
            self?.map?.locationProvider = locationProvider
        }.store(in: &cancellableBag)
    }
}

/// Create a MapCoordinator extension to add the planned route to the map
extension MapCoordinator {
    private func createMapRouteOptions(coordinates: [CLLocationCoordinate2D]) -> TomTomSDKMapDisplay.RouteOptions {
        var routeOptions = RouteOptions(coordinates: coordinates)
        routeOptions.outlineWidth = 1
        routeOptions.routeWidth = 5
        routeOptions.color = .activeRoute
        return routeOptions
    }

    func addRouteToMap(route: TomTomSDKRoute.Route) {
        // Create the route options from the route geometry and add it to the map
        let routeOptions = createMapRouteOptions(coordinates: route.geometry)
        if let routeOnMap = try? map?.addRoute(routeOptions) {
            self.routeOnMap = routeOnMap

            // Zoom the map to make the route visible
            map?.zoomToRoutes(padding: 32)
        }
    }
}

// MARK: - NavigationView Actions

/// Update the NavigationController extension with the onNavigationViewAction function to handle actions like arrival, mute, and etc
extension NavigationController {
    func onNavigationViewAction(_ action: TomTomSDKNavigationUI.NavigationView.Action) {
        switch action {
        case let .arrival(action):
            onArrivalAction(action)
        case let .instruction(action):
            onInstructionAction(action)
        case let .confirmation(action):
            onConfirmationAction(action)
        case let .error(action):
            onErrorAction(action)
        @unknown default:
            /* YOUR CODE GOES HERE */
            break
        }
    }

    private func onArrivalAction(_ action: TomTomSDKNavigationUI.NavigationView.ArrivalAction) {
        switch action {
        case .close:
            stopNavigating()
        @unknown default:
            /* YOUR CODE GOES HERE */
            break
        }
    }

    private func onInstructionAction(_ action: TomTomSDKNavigationUI.NavigationView.InstructionAction) {
        switch action {
        case let .tapSound(muted):
            navigationViewModel!.muteTextToSpeech(mute: !muted)
        case .tapLanes:
            navigationViewModel!.hideLanes()
        case .tapThen:
            navigationViewModel!.hideCombinedInstruction()
        @unknown default:
            /* YOUR CODE GOES HERE */
            break
        }
    }

    private func onConfirmationAction(_ action: TomTomSDKNavigationUI.NavigationView.ConfirmationAction) {
        switch action {
        case .yes:
            stopNavigating()
        case .no:
            /* YOUR CODE GOES HERE */
            break
        @unknown default:
            /* YOUR CODE GOES HERE */
            break
        }
    }

    private func onErrorAction(_: TomTomSDKNavigationUI.NavigationView.ErrorAction) {
        /* YOUR CODE GOES HERE */
    }
}
