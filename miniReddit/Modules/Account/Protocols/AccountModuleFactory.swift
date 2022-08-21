
import UIKit

protocol AccountModuleFactory {
    func create(action: @escaping () -> Void) -> UIViewController
}
