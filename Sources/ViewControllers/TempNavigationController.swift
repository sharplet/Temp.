import UIKit

final class TempNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationBar.shadowImage = UIImage()
    navigationBar.setBackgroundImage(UIImage(), for: .default)
  }
}
