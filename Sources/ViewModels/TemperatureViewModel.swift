import ReactiveSwift
import enum Result.NoError

final class TemperatureViewModel {
  let celsiusTemperature: SignalProducer<String, NoError>
  let fahrenheitTemperature: SignalProducer<String, NoError>

  init<P: PropertyProtocol>(forecast: P) where P.Value == Forecast? {
    let temperature = forecast.producer.map { $0?.temperature }
    celsiusTemperature = temperature.map(celsiusString(from:)).observe(on: UIScheduler())
    fahrenheitTemperature = temperature.map(fahrenheitString(from:)).observe(on: UIScheduler())
  }
}

private func celsiusString(from temperature: Temperature?) -> String {
  return (temperature?.celsius.value).map { String(format: "%.0fºC", $0) } ?? "--ºC"
}

private func fahrenheitString(from temperature: Temperature?) -> String {
  return (temperature?.fahrenheit.value).map { String(format: "%.0fºF", $0) } ?? "--ºF"
}
