import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  let locationProvider: LocationProvider = CoreLocationProvider()
  let temperatureProvider: TemperatureProvider = DarkSky.TemperatureProvider()

  func applicationDidBecomeActive(_ application: UIApplication) {
    locationProvider.updateLocation.apply()
      .flatMap(.merge, transform: temperatureProvider.updateTemperature.apply)
      .map { $0.celsiusValue }
      .startWithResult {
        print($0)
      }
  }
}
