import Argo
import ReactiveSwift

final class PersistentDataProvider<Base: DataProvider>: DataProvider
  where Base.Value: Encodable & Decodable,
    Base.Value.DecodedType == Base.Value,
    Base.StoredValue == Base.Value?
{
  let latest: Property<Base.StoredValue>

  var update: Action<Base.Input, Base.Value, Base.Error> {
    return base.update
  }

  private let base: Base
  private let lifetime: Lifetime
  private let token = Lifetime.Token()

  init(_ base: Base, at url: URL) {
    self.base = base
    self.lifetime = Lifetime(token)

    let initial: Base.StoredValue
    do {
      let data = try Data(contentsOf: url)
      let json = try JSONSerialization.jsonObject(with: data)
      initial = decode(json)
    } catch {
      initial = nil
    }

    latest = Property(initial: initial, then: base.latest.signal)

    base.latest.signal
      .take(during: lifetime)
      .observeValues { value in
        if let value = value {
          do {
            let data = try JSONSerialization.data(withJSONObject: value.encode().jsonObject())
            try data.write(to: url)
          } catch {
            // no-op
          }
        } else {
          try? FileManager.default.removeItem(at: url)
        }
      }
  }
}
