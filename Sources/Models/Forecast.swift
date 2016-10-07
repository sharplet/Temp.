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
