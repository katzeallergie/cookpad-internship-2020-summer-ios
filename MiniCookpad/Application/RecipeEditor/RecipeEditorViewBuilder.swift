struct RecipeEditorViewBuilder {
    static func build() -> RecipeEditorViewController {
        let viewController = RecipeEditorViewController()
        let interactor = RecipeEditorInteractor(recipeDataStore: RecipeDataStore(), imageDataStore: ImageDataStore())
        let wireframe = RecipeEditorWireframe(viewController: viewController)
        let presenter = RecipeEditorPresenter(view: viewController, interactor: interactor, wireframe: wireframe)
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
