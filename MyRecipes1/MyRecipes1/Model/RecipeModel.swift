import Foundation
import SwiftData

@Model
class Recipe: Identifiable {
    var title: String
    var shortDescription: String
    
    @Relationship(inverse: \Category.recipes)
    var category: Category?
    var imageData: Data?
    var preparationTime: String
    var directions: String
    var ingredient: String
    var servings: String
   
    
    init(title: String = "", shortDescription: String = "", imageData: Data? = nil, category: Category? = nil, preparationTime: String = "", directions: String = "", ingredient: String = "", servings: String = "") {
        self.title = title
        self.shortDescription = shortDescription
        self.imageData = imageData
        self.category = category
        self.preparationTime = preparationTime
        self.directions = directions
        self.ingredient = ingredient
        self.servings = servings
    }
}

@Model
class Category {
    @Attribute(.unique)
    var title: String
    var image: Data?
    var recipes: [Recipe]?
    
    init(title: String, image: Data? = nil) {
        self.title = title
        self.image = image
    }
}
