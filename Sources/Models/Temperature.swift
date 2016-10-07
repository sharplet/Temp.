import Argo
import Runes

enum Temperature {
  case fahrenheit(Double)
  case celsius(Double)

  var measurement: Measurement<UnitTemperature> {
    switch self {
    case .fahrenheit(let value):
      return Measurement(value: value, unit: .fahrenheit)
    case .celsius(let value):
      return Measurement(value: value, unit: .celsius)
    }
  }

  var fahrenheitValue: Temperature {
    switch self {
    case .fahrenheit:
      return self
    case .celsius:
      return .fahrenheit(measurement.converted(to: .fahrenheit).value)
    }
  }

  var celsiusValue: Temperature {
    switch self {
    case .fahrenheit:
      return .celsius(measurement.converted(to: .celsius).value)
    case .celsius:
      return self
    }
  }
}

extension Temperature {
  static func decodeFahrenheit(_ json: JSON) -> Decoded<Temperature> {
    return Temperature.fahrenheit <^> Double.decode(json)
  }

  static func decodeCelsius(_ json: JSON) -> Decoded<Temperature> {
    return Temperature.celsius <^> Double.decode(json)
  }
}
