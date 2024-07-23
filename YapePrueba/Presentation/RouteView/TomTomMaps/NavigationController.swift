//
//  NavigationController.swift
//  YapePrueba
//
//  Created by iMac on 21/07/24.
//
import SwiftUI
import Combine
import CoreLocation
import TomTomSDKMapDisplay
import TomTomSDKLocationProvider
import TomTomSDKNavigation 
import TomTomSDKNavigationEngines
import TomTomSDKNavigationOnline
import TomTomSDKNavigationTileStore
import TomTomSDKNavigationUI
import TomTomSDKRoute
import TomTomSDKRoutePlanner
import TomTomSDKRoutePlannerOnline
import TomTomSDKRoutingCommon
import TomTomSDKCommon

enum RoutePlanError: Error {
    case unableToPlanRoute
}

final class NavigationController: NSObject, ObservableObject, NavigationLocationContextObserver, TomTomSDKNavigation.NavigationProgressObserver, TomTomSDKNavigation.NavigationRouteAddObserver, TomTomSDKNavigation.NavigationRouteRemoveObserver, TomTomSDKNavigation.NavigationActiveRouteChangeObserver, TomTomSDKNavigation.NavigationRouteUpdateObserver, CLLocationManagerDelegate {
    
    @Published var navigationViewModel: TomTomSDKNavigationUI.NavigationView.ViewModel?
    var onNavigationViewAction: TomTomSDKNavigationUI.NavigationView.Action?
    @Published var startCoordSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
    @Published var endCoordReachedSubject = PassthroughSubject<Void, Never>()
    @Published var timerValueSubject = PassthroughSubject<TimeInterval, Never>()
    @Published var isLoading = false
    @Published var alertMessage: String?
    @Published var showAlertMessage = false

    var startCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double("4.513600649117507")!, longitude: Double("-74.11264536657632")!)
    var endCoord: CLLocationCoordinate2D?
    var startCoordTime: Date?
    var endCoordTime: Date?

    private var timer: Timer?
    @Published var elapsedTime: TimeInterval = 0.0
    private let locationManager = CLLocationManager()
    private var speedMeasurements: [Measurement<UnitSpeed>] = []

    private var isNavigationStarted = false
    weak var mapCoordinator: MapCoordinator?

    convenience override init() {
        let routePlanner = TomTomSDKRoutePlannerOnline.OnlineRoutePlanner(apiKey: Keys.tomtomApiKey)
        let locationProvider = DefaultCLLocationProvider()
        let simulatedLocationProvider = SimulatedLocationProvider(delay: Measurement(value: 1, unit: UnitDuration.seconds))
        let navigationConfiguration = OnlineTomTomNavigationFactory.Configuration(
            navigationTileStore: try! NavigationTileStore(config: NavigationTileStoreConfiguration(apiKey: Keys.tomtomApiKey)),
            locationProvider: simulatedLocationProvider,
            routePlanner: routePlanner
        )
        let navigation = try! OnlineTomTomNavigationFactory.create(configuration: navigationConfiguration)

        self.init(locationProvider: locationProvider, simulatedLocationProvider: simulatedLocationProvider, routePlanner: routePlanner, navigation: navigation as! TomTomNavigation)
    }

    init(locationProvider: LocationProvider, simulatedLocationProvider: SimulatedLocationProvider, routePlanner: TomTomSDKRoutePlannerOnline.OnlineRoutePlanner, navigation: TomTomNavigation) {
        self.locationProvider = locationProvider
        self.simulatedLocationProvider = simulatedLocationProvider
        self.routePlanner = routePlanner
        self.navigation = navigation

        super.init()

        self.navigation.addProgressObserver(self)
        self.navigation.addRouteAddObserver(self)
        self.navigation.addRouteRemoveObserver(self)
        self.navigation.addRouteUpdateObserver(self)
        self.navigation.addActiveRouteChangeObserver(self)
        self.navigation.addLocationContextObserver(self)
        locationProvider.enable()
        setupLocationManager()
        
        startFreeDriving()
    }

    let locationProvider: LocationProvider
    let simulatedLocationProvider: SimulatedLocationProvider
    let routePlanner: TomTomSDKRoutePlannerOnline.OnlineRoutePlanner
    let navigation: TomTomNavigation

    var routePlanningOptions: TomTomSDKRoutePlanner.RoutePlanningOptions?
    var displayedRoutes: [UUID: TomTomSDKRoute.Route] = [:]

    let displayedRouteSubject = PassthroughSubject<TomTomSDKRoute.Route?, Never>()
    let navigateRouteSubject = PassthroughSubject<TomTomSDKRoute.Route?, Never>()
    let progressOnRouteSubject = PassthroughSubject<Measurement<UnitLength>, Never>()
    let mapMatchedLocationProvider = PassthroughSubject<LocationProvider, Never>()

    @Published var showNavigationView: Bool = false

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func initializeStartCoord() {
            startCoordSubject.send(startCoord)
        
    }

    func startFreeDriving() {
        do {
            try? navigation.start()
            initializeStartCoord()
        }catch{
            initializeStartCoord()
        }
       // navigateToEndCoord()
    }

    func stopFreeDriving() {
        navigation.stop()
        stopTimer()
        isNavigationStarted = false
    }

    func checkIfReachedStartCoord(currentCoord: CLLocationCoordinate2D) {
        //guard let startCoord = startCoord else { return }
        //let distance = calculateDistance(from: currentCoord, to: startCoord)
        //if distance < 10 {
          //  startCoordTime = Date()
            //startTimer()
            navigateToEndCoord()
            showNavigationView = true
            setCamera(trackingMode: .followDirection())
        //}
    }

    func checkIfReachedEndCoord(currentCoord: CLLocationCoordinate2D) {
        setCamera(trackingMode: .followDirection())
        //guard let endCoord = endCoord else { return }
        //let distance = calculateDistance(from: currentCoord, to: endCoord)
        //if distance < 10 {
       //     endCoordTime = Date()
        //    stopTimer()
            endCoordReachedSubject.send(())
        //    calculateSpeedMetrics()
       //     uploadDataAndShowSummary()
        //}
    }

    func navigateToEndCoord() {
        guard let endCoord = endCoord else { return }
        planAndDisplayRoute(destination: endCoord)
    }

    func planAndDisplayRoute(destination: CLLocationCoordinate2D) {
        planRoute { [weak self] result in
            switch result {
            case let .success(planRouteResult):
                guard let self, let route: TomTomSDKRoute.Route = planRouteResult.0 else { return }
                let routePlanningOptions: RoutePlanningOptions = planRouteResult.1

                self.simulatedLocationProvider.updateCoordinates(route.geometry, interpolate: true)
                self.simulatedLocationProvider.enable()

                let routePlan = RoutePlan(route: route, routePlanningOptions: routePlanningOptions)
                let navigationOptions = NavigationOptions(activeRoutePlan: routePlan)

                do {
                    if !self.isNavigationStarted {
                        try self.navigation.start(navigationOptions: navigationOptions)
                        self.isNavigationStarted = true
                        self.setCamera(trackingMode: .followRouteDirection())
                    }
                } catch {
                    print("start navigation error: \(error)")
                }

                self.displayedRouteSubject.send(route)
            case let .failure(error):
                print("route planning error: \(error.localizedDescription)")
            }
        }
    }

    func planRoute(completionHandler: @escaping (Result<(TomTomSDKRoute.Route?, RoutePlanningOptions), Error>) -> ()) {
        do {
            //guard let startCoord = startCoord, let endCoord = endCoord else { return }
            let startPoint = ItineraryPoint(coordinate: startCoord)
            let endPoint = ItineraryPoint(coordinate: endCoord!)
            let itinerary = Itinerary(origin: startPoint, destination: endPoint)
            let routePlanningOptions = try RoutePlanningOptions(itinerary: itinerary, guidanceOptions: GuidanceOptions())

            routePlanner.planRoute(options: routePlanningOptions, onRouteReady: nil) { result in
                switch result {
                case let .success(routePlanningResponse):
                    let result = (routePlanningResponse.routes?.first, routePlanningOptions)
                    completionHandler(.success(result))
                case let .failure(error):
                    print(error.localizedDescription)
                    completionHandler(.failure(error))
                }
            }
        } catch {
            completionHandler(.failure(error))
        }
    }

    private func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }

    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1.0
            self.timerValueSubject.send(self.elapsedTime)
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - LocationProviderObservable Methods

    func onLocationUpdated(location: TomTomSDKLocationProvider.GeoLocation) {
        // Handle location updates here
    }

    func onHeadingUpdate(newHeading: CLHeading, lastLocation: TomTomSDKLocationProvider.GeoLocation) {
        // Handle heading updates here
    }

    func onAuthorizationStatusChanged(isGranted: Bool) {
        // Handle authorization status changes here
    }

    // MARK: - NavigationLocationContextObserver Methods

    func didDetectLocationContext(locationContext: LocationContext) {
        let speed: Measurement<UnitSpeed> = locationContext.speed
        speedMeasurements.append(speed)
       // speedSubject.send(speed)
    }

    // MARK: - NavigationProgressObserver Methods

    func didUpdateProgress(progress: TomTomSDKNavigationEngines.RouteProgress) {
        progressOnRouteSubject.send(progress.distanceAlongRoute)

        if let currentCoord = locationProvider.lastKnownLocation?.location.coordinate {
            checkIfReachedStartCoord(currentCoord: currentCoord)
            checkIfReachedEndCoord(currentCoord: currentCoord)
        }
    }

    // MARK: - NavigationRouteAddObserver Methods

    func didAddRoute(route: TomTomSDKRoute.Route, options: TomTomSDKRoutePlanner.RoutePlanningOptions, reason: TomTomSDKNavigation.RouteAddedReason) {
        displayedRouteSubject.send(nil)
        displayedRouteSubject.send(route)
    }

    // MARK: - NavigationRouteRemoveObserver Methods

    func didRemoveRoute(route: TomTomSDKRoute.Route, reason: TomTomSDKNavigation.RouteRemovedReason) {}

    // MARK: - NavigationActiveRouteChangeObserver Methods

    func didChangeActiveRoute(route: TomTomSDKRoute.Route) {}

    // MARK: - NavigationRouteUpdateObserver Methods

    func didUpdateRoute(route: TomTomSDKRoute.Route, reason: TomTomSDKNavigation.RouteUpdatedReason) {}

    // MARK: - CLLocationManagerDelegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last?.coordinate else { return }
        checkIfReachedStartCoord(currentCoord: currentLocation)
        checkIfReachedEndCoord(currentCoord: currentLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }

    private func calculateSpeedMetrics() {
        guard !speedMeasurements.isEmpty else { return }

        //maxSpeed = speedMeasurements.max()
        let totalSpeed = speedMeasurements.reduce(0) { $0 + $1.value }
        let averageSpeedValue = totalSpeed / Double(speedMeasurements.count)
       // averageSpeed = Measurement(value: averageSpeedValue, unit: UnitSpeed.metersPerSecond).converted(to: .kilometersPerHour)
        //maxSpeed = maxSpeed?.converted(to: .kilometersPerHour)
    }

    private func showSummaryAlert() {
       // guard let maxSpeed = maxSpeed, let averageSpeed = averageSpeed else { return }
       // showSummaryAlertSubject.send((maxSpeed: maxSpeed, averageSpeed: averageSpeed, elapsedTime: elapsedTime))
    }

    private func uploadDataAndShowSummary() {
        //guard let startCoordTime = startCoordTime, let endCoordTime = endCoordTime, let maxSpeed = maxSpeed, let averageSpeed = averageSpeed else {
       //     return
      //  }
        
        
    }

    private func saveDataLocally(_ data: [String: Any]) {
        var storedData = UserDefaults.standard.array(forKey: "pendingUploads") as? [[String: Any]] ?? []
        storedData.append(data)
        UserDefaults.standard.set(storedData, forKey: "pendingUploads")
    }

    private func tryToUploadStoredData() {
        let storedData = UserDefaults.standard.array(forKey: "pendingUploads") as? [[String: Any]] ?? []
        guard !storedData.isEmpty else { return }

        for data in storedData {
            guard let trackId = data["trackId"] as? Int else { continue }
            let urlString = "https://culture.apiimd.com/pista/\(trackId)/tiempo"
            guard let url = URL(string: urlString) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                request.httpBody = jsonData
            } catch {
                print("Failed to serialize JSON: \(error)")
                continue
            }

            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Failed to upload data: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error")
                    return
                }

                var storedData = UserDefaults.standard.array(forKey: "pendingUploads") as? [[String: Any]] ?? []
                if let index = storedData.firstIndex(where: { $0["trackId"] as? Int == trackId }) {
                    storedData.remove(at: index)
                    UserDefaults.standard.set(storedData, forKey: "pendingUploads")
                }
            }

            task.resume()
        }
    }

    
   

    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func setCamera(trackingMode: TomTomSDKMapDisplay.CameraTrackingMode) {
        mapCoordinator?.setCamera(trackingMode: trackingMode)
    }
}

extension Date {
    func iso8601String() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}

