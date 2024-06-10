import SwiftUI
import SwiftData

struct CategoryDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var category: Category
    @Query var recipes: [Recipe]
    
    var body: some View {
        ZStack {
            Color.bg.edgesIgnoringSafeArea(.all)
            ScrollView {
                ForEach(filteredRecipes) { recipe in
                    RecipeCardView(recipe: recipe)
                }
                .padding()
            }
            .navigationTitle(category.title)
            .navigationBarBackButtonHidden(true)
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.white)
                                .cornerRadius(6)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                    }
                    .accessibilityLabel("go back")
                }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    // Edit category image
                                } label: {
                                    ZStack {
                                        Rectangle()
                                            .frame(width: 35, height: 35)
                                            .foregroundStyle(.white)
                                            .cornerRadius(6)
                                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                                        Image(systemName: "photo")
                                            .font(.system(size: 14))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
            }
        }
    }
    
    private var filteredRecipes: [Recipe] {
        return recipes.filter { $0.category?.title == category.title }
    }
       
}
