import CoreLocation
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

final class CoreLocationProvider: NSObject, DataProvider {
  let latest: Property<Location?>
  let update: Action<(), Location, Temp.Error>

  override init() {
    let locationDelegate = LocationDelegate()
    update = Action {
      let authorize = locationDelegate.requestAuthorization()
      let update = locationDelegate.updateLocation()
      return authorize.then(update)
    }
    latest = Property(initial: nil, then: update.values.map(Optional.some))
    super.init()
  }
}

private final class LocationDelegate: NSObject, CLLocationManagerDelegate {
  let manager: CLLocationManager

  let (authorization, authorizationObserver) = Signal<CLAuthorizationStatus, NoError>.pipe()
  let (locations, locationsObserver) = Signal<Location, NoError>.pipe()
  let (errors, errorsObserver) = Signal<Temp.Error, NoError>.pipe()

  override init() {
    manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    super.init()
    manager.delegate = self
  }

  func requestAuthorization() -> SignalProducer<Bool, NoError> {
    return SignalProducer { observer, disposable in
      let currentAuthorization = CLLocationManager.authorizationStatus()

      guard !currentAuthorization.isDetermined else {
        observer.send(value: currentAuthorization.isAuthorizedWhenInUse)
        observer.sendCompleted()
        return
      }

      disposable += self.authorization.filter { $0.isDetermined }
        .take(first: 1)
        .map { $0.isAuthorizedWhenInUse }
        .observe(observer)

      self.manager.requestWhenInUseAuthorization()
    }
  }

  func updateLocation() -> SignalProducer<Location, Temp.Error> {
    return SignalProducer { observer, disposable in
      let nextLocation = self.locations.take(first: 1)
      let locationUpdated = nextLocation.map { _ in }
      let updateFailed = self.errors
        .take(until: locationUpdated)
        .take(first: 1)

      disposable += nextLocation.promoteErrors(Temp.Error.self).observe(observer)
      disposable += updateFailed.observeValues(observer.send(error:))
      disposable += self.manager.stopUpdatingLocation

      self.manager.requestLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    authorizationObserver.send(value: status)
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locations.forEach {
      locationsObserver.send(value: $0.toLocation())
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    errorsObserver.send(value: .coreLocation(error))
  }
}

private extension CLAuthorizationStatus {
  var isAuthorizedWhenInUse: Bool {
    return self == .authorizedWhenInUse || self == .authorizedAlways
  }

  var isDetermined: Bool {
    return self != .notDetermined
  }
}

private extension CLLocation {
  func toLocation() -> Location {
    return Location(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude
    )
  }
}
