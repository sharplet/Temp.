import UIKit

private let forecastCacheURL: URL = {
  let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
  return caches.appendingPathComponent("latest-temperature")
}()

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  let locationProvider = CoreLocationProvider()

  let forecastProvider = PersistentDataProvider(
    DarkSky.ForecastProvider(),
    at: forecastCacheURL
  )

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    forecastProvider.latest.producer.startWithValues { print($0?.temperature.celsius ?? "-") }
    return true
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    locationProvider.update.apply()
      .flatMap(.latest, transform: forecastProvider.update.apply)
      .start()
  }
}
