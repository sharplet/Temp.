import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  let locationProvider = CoreLocationProvider()
  let temperatureProvider = DarkSky.TemperatureProvider()

  func applicationDidBecomeActive(_ application: UIApplication) {
    locationProvider.update.apply()
      .flatMap(.merge, transform: temperatureProvider.update.apply)
      .map { $0.celsiusValue }
      .startWithResult {
        print($0)
      }
  }
}
