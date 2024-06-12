import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var recipe: Recipe
    
    @State private var isFavorite: Bool = false
    @State private var navigateToEditView = false
    @State private var showDeleteActionSheet = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            GeometryReader { reader in
                if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .offset(y: -reader.frame(in: .global).minY)
                        .frame(width: UIScreen.main.bounds.width, height: reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY + 300 : 300)
                } else {
                    Image("mat")
                        .resizable()
                        .scaledToFill()
                        .offset(y: -reader.frame(in: .global).minY)
                        .frame(width: UIScreen.main.bounds.width, height: reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY + 300 : 300)
                }
            }
            .ignoresSafeArea(.all)
            .frame(height: 300)
            
            VStack(alignment: .leading) {
                    if let category = recipe.category {
                        Text(category.title)
                            .font(.custom("Glacialindifference-Regular", size: 16))
                            .foregroundStyle(.gray)
                            .padding(.bottom, 1)
                    }
                
                Text(recipe.title)
                    .font(.custom("Glacialindifference-Bold", size: 26))
                    .padding(.bottom, 1)
                
                Text(recipe.shortDescription)
                    .font(.custom("Glacialindifference-Regular", size: 18))
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                HStack {
                    Text(recipe.preparationTime)
                        .font(.custom("Glacialindifference-Regular", size: 16))
                    Spacer()
                    if !recipe.servings.isEmpty {
                        Text(recipe.servings)
                            .font(.custom("Glacialindifference-Regular", size: 16))
                    }
                }
                
                Divider()
                
                if !recipe.ingredient.isEmpty {
                    Text("Ingredients:")
                        .font(.custom("Glacialindifference-Bold", size: 18))
                        .padding(.top, 10)
                    Text(recipe.ingredient)
                        .font(.custom("Glacialindifference-Regular", size: 16))
                        .padding(.bottom, 20)
                }
                
                if !recipe.directions.isEmpty {
                    Text("Directions:")
                        .font(.custom("Glacialindifference-Bold", size: 18))
                    Text(recipe.directions)
                        .font(.custom("Glacialindifference-Regular", size: 16))
                        .padding(.bottom)
                }
                Spacer()
            }
            .padding(.top, 25)
            .padding(.horizontal)
            .background(.white)
            .cornerRadius(20)
            .offset(y: -35)
        })
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(.black)
                            .cornerRadius(6)
                            .opacity(0.5)
                        
                        Image(systemName: "arrow.backward")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .black)
                            .font(.system(size: 16))
                    }
                }
                .accessibilityLabel("go back")
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Edit recipe") {
                        navigateToEditView = true
                    }
                    
                    Button("Delete recipe", role: .destructive) {
                        showDeleteActionSheet = true
                    }
                    .accessibilityLabel("Delete recipe")
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(.black)
                            .cornerRadius(6)
                            .opacity(0.5)
                        
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .black)
                    }
                }
                .accessibilityLabel("Menu to edit or delete recipe")
            }
        }
        
        .navigationDestination(isPresented: $navigateToEditView) {
            EditRecipeView(recipe: recipe)
        }
        
        .confirmationDialog(
            "Do you really want to delete this recipe?",
            isPresented: $showDeleteActionSheet,
            titleVisibility: .visible
        ) {
            Button("Delete recipe", role: .destructive) {
                modelContext.delete(recipe)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete \(recipe.title)")
        }
    }
}
