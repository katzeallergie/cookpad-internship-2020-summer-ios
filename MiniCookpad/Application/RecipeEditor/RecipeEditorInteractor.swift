import Foundation
import UIKit

class RecipeEditorInteractor: RecipeEditorInteractorProtocol {
    private let recipeDataStore: RecipeDataStoreProtocol
    private let imageDataStore: ImageDataStoreProtocol
    
    init(recipeDataStore: RecipeDataStoreProtocol, imageDataStore: ImageDataStoreProtocol) {
        self.recipeDataStore = recipeDataStore
        self.imageDataStore = imageDataStore
    }
    
    func createRecipe(title: String?, steps: [String?], image: UIImage?, completion: @escaping ((Result<Void, Error>) -> Void)) {
        
        guard let title = title else {
            return
        }
        
        let steps: [String] = steps.compactMap { $0 }
        if steps.isEmpty {
            return
        }
        
        guard let imageData: Data = image?.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        
        
        imageDataStore.createImage(imageData: imageData, completion: { [weak self] result in
            switch result {
            case let .success(imagePath):
                self?.recipeDataStore.createRecipe(title: title, steps: steps, imagePath: imagePath.path) { result in
                    // まだチェックしていない
                    switch result {
                    case .success:
                        completion(.success(()))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }

}
