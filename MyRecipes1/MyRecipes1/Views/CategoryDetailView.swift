import SwiftUI
import SwiftData
import PhotosUI

struct CategoryDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var category: Category
    @Query var recipes: [Recipe]
    
    @State private var selectedCategoryImage: PhotosPickerItem?
    
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
                    PhotosPicker(selection: $selectedCategoryImage, matching: .images, photoLibrary: .shared()) {
                        ZStack {
                            Rectangle()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.white)
                                .cornerRadius(6)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                    }
                    
                    .task(id: selectedCategoryImage) {
                        if let data = try? await selectedCategoryImage?.loadTransferable(type: Data.self) {
                            category.image = data
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
