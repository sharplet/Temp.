import ReactiveSwift

protocol LocationProvider: class {
  var latestLocation: Property<Location?> { get }
  var updateLocation: Action<(), Location, Temp.Error> { get }
}
