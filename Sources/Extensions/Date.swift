import Argo
import Runes

extension Date: Decodable {
  public static func decode(_ json: JSON) -> Decoded<Date> {
    return Date.init(timeIntervalSince1970:) <^> Double.decode(json)
  }
}

extension Date: Encodable {
  func encode() -> JSON {
    let number = NSNumber(value: timeIntervalSince1970)
    return .number(number)
  }
}
