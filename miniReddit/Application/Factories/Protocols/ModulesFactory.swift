
import UIKit

protocol ModulesFactory {
    func makePostsModule() -> UIViewController
    func makeAccountModule() -> UIViewController
}
