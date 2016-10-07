import Argo

extension JSON {
  func jsonObject() -> Any {
    switch self {
    case .null:
      return NSNull()
    case .bool(let value):
      return value
    case .number(let value):
      return value
    case .string(let value):
      return value
    case .object(let value):
      var object: [String: Any] = [:]
      for (key, value) in value {
        object[key] = value.jsonObject()
      }
      return object
    case .array(let value):
      return value.map { $0.jsonObject() }
    }
  }
}
