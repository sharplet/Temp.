import ReactiveSwift

protocol DataProvider: class {
  associatedtype Input
  associatedtype Value
  associatedtype StoredValue = Value?
  associatedtype Error: Swift.Error

  var latest: Property<StoredValue> { get }
  var update: Action<Input, Value, Error> { get }
}
