import UIKit

class RecipeEditorWireframe: RecipeEditorWireframeProtocol {
    private weak var viewController: UIViewController!
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func close() {
        self.viewController.dismiss(animated: true, completion: nil)
    }
}
