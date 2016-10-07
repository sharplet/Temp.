import ReactiveSwift
import UIKit

final class TemperatureViewController: UIViewController {
  @IBOutlet private var celsiusLabel: UILabel!
  @IBOutlet private var fahrenheitLabel: UILabel!

  var viewModel: TemperatureViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.celsiusTemperature.producer
      .take(during: rac_lifetime)
      .startWithValues { [celsiusLabel] celsius in celsiusLabel?.text = celsius }

    viewModel.fahrenheitTemperature.producer
      .take(during: rac_lifetime)
      .startWithValues { [fahrenheitLabel] fahrenheit in fahrenheitLabel?.text = fahrenheit }
  }
}
