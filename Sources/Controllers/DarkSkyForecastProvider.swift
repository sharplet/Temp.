import Argo
import ReactiveSwift
import Swish
import Result

enum DarkSky {
  enum API {
    static let forecastURL = URL(string: "https://api.darksky.net/forecast/6d151d55d894d57243b9aa380aa3888d")!
  }

  final class ForecastProvider: DataProvider {
    let latest: Property<Forecast?>
    let update: Action<Location, Forecast, Temp.Error>

    init() {
      update = Action { location in
        let request = CurrentConditionsRequest(location: location)

        return APIClient().rac_response(for: request)
          .mapError(Temp.Error.network)
      }

      latest = Property(initial: nil, then: update.values.map(Optional.some))
    }
  }

  struct CurrentConditionsRequest: Request {
    typealias ResponseObject = Forecast

    var location: Location

    func build() -> URLRequest {
      let latitude = string(for: location.latitude)
      let longitude = string(for: location.longitude)
      let url = API.forecastURL.appendingPathComponent("\(latitude),\(longitude)")
      return URLRequest(url: url)
    }

    func parse(_ json: JSON) -> Result<Forecast, SwishError> {
      return .fromDecoded(json <| "currently")
    }

    private func string(for number: Double) -> String {
      return String(format: "%f", number)
    }
  }
}
