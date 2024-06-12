import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
            HStack(alignment: .top) {
                if let imageData = recipe.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 105, height: 130)
                        .cornerRadius(8)
                        .padding(5)
                } else {
                    Image("mat")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 105, height: 130)
                        .cornerRadius(8)
                        .padding(5)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        if let category = recipe.category {
                            Text(category.title)
                                .font(.custom("Glacialindifference-Regular", size: 14))
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        Image(systemName: "arrow.forward")
                            .font(.system(size: 14))
                            .padding(5)
                    }
                    
                    Text(recipe.title)
                        .font(.custom("Glacialindifference-Bold", size: 16))
                    
                    Text(recipe.shortDescription)
                        .font(.custom("Glacialindifference-Regular", size: 14))
                    
                    Spacer()
                    
                    HStack {
                        if !recipe.preparationTime.isEmpty {
                            Text(recipe.preparationTime)
                                .font(.custom("Glacialindifference-Regular", size: 14))
                        }
                        Spacer()
                        if !recipe.servings.isEmpty {
                            Text(recipe.servings)
                                .font(.custom("Glacialindifference-Bold", size: 14))
                                .padding(10)
                        }
                    }
                    
                }
                .padding(.vertical, 5)
            }
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding(.vertical, 1)
        }
        .buttonStyle(.plain)
    }
}
