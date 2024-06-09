
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
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .offset(y: -reader.frame(in: .global).minY)
                        .frame(width: UIScreen.main.bounds.width, height: reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY + 300 : 300)
                }
            }
            .ignoresSafeArea(.all)
            .frame(height: 300)
            
            VStack(alignment: .leading) {
                
                HStack {
                    if let category = recipe.category {
                        Text(category.title )
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding(.bottom, 1)
                    }
                    Spacer()
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 26))
                            .foregroundColor(.black)
                    }
                    
                }
                
                Text(recipe.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack {
                    Text(recipe.shortDescription)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(recipe.preparationTime)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                if !recipe.ingredient.isEmpty {
                    Text("Ingredienser:")
                        .font(.subheadline)
                        .bold()
                        .padding(.top, 10)
                    Text(recipe.ingredient)
                        .font(.body)
                        .padding(.bottom, 20)
                }
                
                if !recipe.directions.isEmpty {
                    Text("Fremgangsmåte:")
                        .font(.subheadline)
                        .bold()
                    Text(recipe.directions)
                        .font(.body)
                        .padding(.bottom)
                }
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
                    if navigateToEditView {
                        EditRecipeView()
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
        //            .navigationDestination(isPresented: $navigateToEditView, destination: {
        //                EditRecipeDetailView(recipe: recipe)
        //            })
        
        NavigationLink(
            destination: EditRecipeView(),
            isActive: $navigateToEditView,
            label: { EmptyView() }
        )
        
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









#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)
        let example = Recipe(title: "Mammas julekjeks", shortDescription: "Med mandler og sjokolade", imageData: nil, category: nil, preparationTime: "20 min", directions: "1. Sett ovnen på 180°C varmluft, eller 200°C over- og undervarme. 2.  Rør smør, sukker, og brunt sukker mykt og kremet. Tilsett egg og eggeplomme, og rør i 2-3 minutter. Bland mel og bakepulver sammen i en skål, og tilsett i deigen. 3. Rør til slutt raskt inn hakket sjokolade og mandler. Del deigen i 20 deler, og trill dem til kuler. Legg kulene med god avstand til hverandre på en stekeplate med bakepapir, og gi dem et lett trykk. Stek cookies'ene i 10-12 minutter til de er lysebrune. Avkjøles på rist", ingredient: "250 gram sukker, 1 ts vaniljesukker, 250 gram malte mandler,150 gram malt kokesjokolade, 2 egg")
        return RecipeDetailView(recipe: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
