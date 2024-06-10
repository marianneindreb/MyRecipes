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
                        .frame(width: 120, height: 140)
                        .cornerRadius(8)
                } else {
                    Image("mat")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 140)
                        .cornerRadius(8)
                }
                VStack(alignment: .leading) {
                    
                    HStack {
                        if let category = recipe.category {
                            Text(category.title)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        Image(systemName: "arrow.forward")
                            .font(.system(size: 14))
                            .padding(5)
                    }
                    Text(recipe.title)
                        .font(.headline)
                        .bold()
                    
                    Text(recipe.shortDescription)
                        .font(.caption)
                    
                    Spacer()
                    
                    if !recipe.preparationTime.isEmpty {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundStyle(.yellow)
                            Text(recipe.preparationTime)
                                .font(.caption)
                        }
                        .padding(.bottom, 5)
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
