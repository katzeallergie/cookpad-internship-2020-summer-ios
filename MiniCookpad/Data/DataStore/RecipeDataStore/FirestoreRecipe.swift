import Foundation
import FirebaseFirestoreSwift

struct FirestoreRecipe: Codable, Equatable {
    @DocumentID var id: String?
    var title: String
    var imagePath: String
    var steps: [String]
    var createdAt = Date()
}
