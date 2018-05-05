import UIKit

class PXLoadingViewController: UIViewController {

    override func viewDidLoad() {
        _ = PXLoadingComponent.shared.showInView(view)
    }
}
