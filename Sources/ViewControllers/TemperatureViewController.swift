import ReactiveSwift
import UIKit

final class TemperatureViewController: UIViewController {
  @IBOutlet private var celsiusLabel: UILabel!
  @IBOutlet private var fahrenheitLabel: UILabel!
  @IBOutlet private var separator: UIView!

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

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    separator.alpha = 0
    coordinator.animate(alongsideTransition: nil) { _ in
      self.separator.alpha = 1
    }
  }
}
