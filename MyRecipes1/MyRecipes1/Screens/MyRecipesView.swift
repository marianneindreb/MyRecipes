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

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if !categories.isEmpty {
                        Text("Categories")
                            .font(.custom("Glacialindifference-Bold", size: 14))
                            .foregroundStyle(Color.gray)
                            .padding(.top)

                        ScrollView(.horizontal, showsIndicators: false) {
                            CategoryItems()
                        }
                    }

                    if !recipes.isEmpty {
                        Text("Recipes")
                            .font(.custom("Glacialindifference-Bold", size: 14))
                            .foregroundStyle(Color.gray)
                    }

                    if recipes.isEmpty {
                        VStack {
                            Text("No recipes added")
                                .font(.custom("Glacialindifference-Bold", size: 18))
                                .padding(.top, 20)
                            Text("Click the + button to add a recipe")
                                .font(.custom("Glacialindifference-Regular", size: 16))
                                .foregroundStyle(Color.gray)
                        }
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(recipes) { recipe in
                            RecipeCardView(recipe: recipe)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("My Recipes")
                        .font(.custom("Glacialindifference-Bold", size: 24))
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
