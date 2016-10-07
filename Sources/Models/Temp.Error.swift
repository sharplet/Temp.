import Swish

enum Temp {
  enum Error: Swift.Error {
    case coreLocation(Swift.Error)
    case network(SwishError)
  }
}
