import SwiftUI
import SwiftData
import PhotosUI

struct EditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query private var categories: [Category]
    
    @State private var selectedImage: PhotosPickerItem?
    @State var selectedCategory: Category?
    @State var recipe = Recipe()
    @State private var newCategoryTitle = ""
    @State private var showNewCategoryTextField = false
    
    
    var body: some View {
        List {
            if let imageData = recipe.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 300)
            }
            
            Section(header: Text("Legg til / Endre bilde")) {
                PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                    Label("Velg Bilde", systemImage: "photo")
                        .foregroundStyle(.black)
                }
            }
            Section (header: Text("Oppskrift")) {
                
                TextField("Navn på oppskrift", text: $recipe.title)
            }
            Section(header: Text("Beskrivelse")) {
                TextField("Kort beskrivelse", text: $recipe.shortDescription)
            }
            Section(header: Text("Estimert tidsbruk")) {
                TextField("Tid", text: $recipe.preparationTime)
            }
            Section (header: Text("Kategori")) {
                
                if categories.isEmpty {
                    
                } else {
                    Picker("Kategori", selection: $selectedCategory) {
                        ForEach(categories) { category in
                            Text(category.title)
                                .tag(category as Category?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                
                
                if showNewCategoryTextField {
                    HStack {
                        TextField("Navn på kategori", text: $newCategoryTitle)
                            .textFieldStyle(.roundedBorder)
                        
                        Button("Lagre") {
                            addNewCategory()
                            showNewCategoryTextField = false
                        }
                        
                    }
                    .padding()
                }
                Button(action: {
                    showNewCategoryTextField.toggle()
                }) {
                    Label("Ny kategori", systemImage: "plus")
                }
            }
            Section(header: Text("Ingredienser")) {
                TextField("Ingredienser", text: $recipe.ingredient, axis: .vertical)
            }
            
            Section(header: Text("Fremgangsmåte")) {
                TextField("Fremgangsmåte", text: $recipe.directions, axis: .vertical)
            }
            Button {
                save()
                dismiss()
            } label: {
                Text("Lagre")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
            }
            .background(Color.black)
            .cornerRadius(22)
            .listRowBackground(Color.clear)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        
        
        
        .navigationTitle("Ny oppskrift")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Avbryt") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Ferdig") {
                    save()
                    dismiss()
                }
                .disabled(recipe.title.isEmpty)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .task(id: selectedImage) {
            if let data = try? await selectedImage?.loadTransferable(type: Data.self) {
                recipe.imageData = data
            }
        }
        
    }
}

private extension EditRecipeView {
    func save() {
        modelContext.insert(recipe)
        recipe.category = selectedCategory
        recipe.category?.image = recipe.imageData
        selectedCategory?.recipes?.append(recipe)
    }
    private func addNewCategory() {
        guard !newCategoryTitle.isEmpty else { return }
        
        let newCategory = Category(title: newCategoryTitle)
        modelContext.insert(newCategory)
        selectedCategory = newCategory
        newCategoryTitle = ""
    }
}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Recipe.self, configurations: config)
//        let example = Recipe(title: "", shortDescription: "", imageData: nil, category: nil, preparationTime: "", directions: "", ingredient: "", isFavorite: false)
//        return EditRecipeDetailView(recipe: example)
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container")
//    }
//}
