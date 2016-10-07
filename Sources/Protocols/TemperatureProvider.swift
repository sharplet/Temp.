import ReactiveSwift

protocol TemperatureProvider: class {
  var latestTemperature: Property<Temperature?> { get }
  var updateTemperature: Action<Location, Temperature, Temp.Error> { get }
}
