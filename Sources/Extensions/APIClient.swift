import ReactiveSwift
import Swish

extension APIClient {
  func rac_response<Request: Swish.Request>(for request: Request) -> SignalProducer<Request.ResponseObject, SwishError> {
    return SignalProducer { observer, disposable in
      var task: URLSessionDataTask?

      disposable += { task?.cancel() }

      task = APIClient().performRequest(request) {
        SignalProducer(result: $0).start(observer)
      }
    }
  }
}
