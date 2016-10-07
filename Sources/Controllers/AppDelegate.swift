import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  let locationProvider = CoreLocationProvider()
  let forecastProvider = DarkSky.ForecastProvider()

  func applicationDidBecomeActive(_ application: UIApplication) {
    locationProvider.update.apply()
      .flatMap(.merge, transform: forecastProvider.update.apply)
      .map { $0.temperature.celsiusValue }
      .startWithResult {
        print($0)
      }
  }
}
