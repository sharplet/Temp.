import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  let locationProvider: LocationProvider = CoreLocationProvider()

  func applicationDidBecomeActive(_ application: UIApplication) {
    locationProvider.updateLocation.apply().logEvents(identifier: "updated location").start()
  }
}
