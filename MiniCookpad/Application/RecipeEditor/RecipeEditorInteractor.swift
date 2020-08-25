import Foundation
import UIKit

class RecipeEditorInteractor: RecipeEditorInteractorProtocol {
    private let recipeDataStore: RecipeDataStoreProtocol
    private let imageDataStore: ImageDataStoreProtocol
    
    init(recipeDataStore: RecipeDataStoreProtocol, imageDataStore: ImageDataStoreProtocol) {
        self.recipeDataStore = recipeDataStore
        self.imageDataStore = imageDataStore
    }
    
    func createRecipe(title: String?, steps: [String?], image: UIImage?, completion: @escaping ((Result<Void, RecipeEditorError>) -> Void)) {
        
        let result = Self.validate(title: title, steps: steps, imageData: image?.jpegData(compressionQuality: 0.1))
        
        let title: String
        let steps: [String]
        let imageData: Data
        switch result {
        case let .success((validatedTitle, validatedSteps, validatedImagedata)):
            title = validatedTitle
            steps = validatedSteps
            imageData = validatedImagedata
        case let .failure(error):
            completion(.failure(error))
            return
        }
        
        imageDataStore.createImage(imageData: imageData, completion: { [weak self] imageResult in
            switch imageResult {
            case let .success(imagePath):
                self?.recipeDataStore.createRecipe(title: title, steps: steps, imagePath: imagePath.path) { recipeResult in
                    switch recipeResult {
                    case .success:
                        completion(.success(()))
                    case let .failure(error):
                        completion(.failure(.creationError(error)))
                    }
                }
            case let .failure(error):
                completion(.failure(.creationError(error)))
            }
        })
    }
    
    private static func validate(title: String?, steps: [String?], imageData: Data?) -> Result<(title: String, steps:[String], imageData: Data), RecipeEditorError> {
        guard let title = title else {
            return .failure(.validationError)
        }
        
        let steps = steps.compactMap { $0 }
        if steps.isEmpty || title.isEmpty {
            // stepsの空文字がエラーにならない
            return .failure(.validationError)
        }
        
        if containsEmoji(text: title) || (steps.map { Self.containsEmoji(text: $0) }).contains(true) {
            return .failure(.validationError)
        }
        
        guard let imageData = imageData else {
            return .failure(.validationError)
        }
        
        return .success((title: title, steps: steps, imageData: imageData))
    }
    
        private static func containsEmoji(text: String) -> Bool {
            var surrogatePairCharacters: [Character] {
            // 順序を保持しつつ、重複要素を取り除くためreduceを使用
            return text.filter { String($0).utf16.count > 1 }.reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
            }
            return !surrogatePairCharacters.isEmpty
        }
}
