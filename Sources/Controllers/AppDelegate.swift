import UIKit

private let forecastCacheURL: URL = {
  let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
  return caches.appendingPathComponent("latest-temperature")
}()

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var temperatureViewController: TemperatureViewController? {
    return window?.rootViewController?.childViewControllers.first as? TemperatureViewController
  }

  var window: UIWindow?

  let locationProvider = CoreLocationProvider()

  let forecastProvider = PersistentDataProvider(
    DarkSky.ForecastProvider(),
    at: forecastCacheURL
  )

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    temperatureViewController?.viewModel = TemperatureViewModel(forecast: forecastProvider.latest)
    return true
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    locationProvider.update.apply()
      .flatMap(.latest, transform: forecastProvider.update.apply)
      .start()
  }
}
