import Argo
import Runes

enum Temperature {
  case fahrenheit(Double)
  case celsius(Double)
}

extension Temperature {
  static func decodeFahrenheit(_ json: JSON) -> Decoded<Temperature> {
    return Temperature.fahrenheit <^> Double.decode(json)
  }

  static func decodeCelsius(_ json: JSON) -> Decoded<Temperature> {
    return Temperature.celsius <^> Double.decode(json)
  }
}
