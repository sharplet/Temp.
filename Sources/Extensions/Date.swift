import Argo
import Runes

extension Date: Decodable {
  public static func decode(_ json: JSON) -> Decoded<Date> {
    return Date.init(timeIntervalSince1970:) <^> Double.decode(json)
  }
}
