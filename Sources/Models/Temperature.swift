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

  var value: Double {
    switch self {
    case .fahrenheit(let value):
      return value
    case .celsius(let value):
      return value
    }
  }

  var fahrenheit: Temperature {
    switch self {
    case .fahrenheit:
      return self
    case .celsius:
      return .fahrenheit(measurement.converted(to: .fahrenheit).value)
    }
  }

  var celsius: Temperature {
    switch self {
    case .fahrenheit:
      return .celsius(measurement.converted(to: .celsius).value)
    case .celsius:
      return self
    }
  }
}

extension Temperature: Decodable {
  static func decode(_ json: JSON) -> Decoded<Temperature> {
    return Temperature.fahrenheit <^> Double.decode(json)
  }
}

extension Temperature: Encodable {
  func encode() -> JSON {
    let number = NSNumber(value: fahrenheit.value)
    return .number(number)
  }
}
