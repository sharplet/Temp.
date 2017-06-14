import Argo
import Curry
import Runes

struct Forecast {
  var temperature: Temperature
  var time: Date
}

extension Forecast: Decodable {
  static func decode(_ json: JSON) -> Decoded<Forecast> {
    return curry(Forecast.init)
      <^> json <| "temperature"
      <*> json <| "time"
  }
}

extension Forecast: Encodable {
  func encode() -> JSON {
    return .object([
      "temperature": temperature.encode(),
      "time": time.encode()
    ])
  }
}
