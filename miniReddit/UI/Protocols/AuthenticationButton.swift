
import UIKit

protocol AuthenticationButton: UIButton {
    func authenticate(completion: () -> Void)
}
