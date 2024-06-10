
import SwiftUI
import SwiftData

struct MyRecipesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var recipes: [Recipe]
    @Query var categories: [Category]
    @State var searchText = ""
    
    
    var body: some View {
        
        
        ZStack {
            Color.bg.edgesIgnoringSafeArea(.all)
            
            ScrollView (showsIndicators: false){
                
                VStack (alignment: .leading) {
                    Text("Categories")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        CategoryItems()
                    }
                    
                    HStack{
                        Text("Recipes")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                        Spacer()
                        Image(systemName: "magnifyingglass")
                    }
                    
                    ForEach(recipes) { recipe in
                        RecipeCardView(recipe: recipe)
                        
                    }
                }
            }
            
            
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("My Recipes")
                        .bold()
                        .font(.title2)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: EditRecipeView()) {
                        ZStack {
                            Rectangle()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.white)
                                .cornerRadius(6)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            Image(systemName: "plus")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
}
