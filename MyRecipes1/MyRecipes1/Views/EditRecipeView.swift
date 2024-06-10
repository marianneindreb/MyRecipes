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
        ZStack {
            Color.bg.edgesIgnoringSafeArea(.all)
            List {
                if let imageData = recipe.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                }
                
                Section(header: Text("Add / Edit photo")) {
                    PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                        Label("Pick a Photo", systemImage: "photo")
                            .foregroundStyle(.black)
                    }
                }
                Section (header: Text("Recipe")) {
                    TextField("Title", text: $recipe.title)
                }
                Section(header: Text("Description")) {
                    TextField("Short description", text: $recipe.shortDescription)
                }
                Section(header: Text("Estimated time")) {
                    TextField("time", text: $recipe.preparationTime)
                }
                Section (header: Text("Category")) {
                    if !categories.isEmpty {
                        Picker("Category", selection: Binding(
                            get: { selectedCategory ?? categories.first },
                            set: { selectedCategory = $0 }
                        )) {
                            ForEach(categories) { category in
                                Text(category.title)
                                    .tag(category as Category?)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    if showNewCategoryTextField {
                        HStack {
                            TextField("New category", text: $newCategoryTitle)
                                .textFieldStyle(.roundedBorder)
                            
                            Button("Save") {
                                addNewCategory()
                                showNewCategoryTextField = false
                            }
                        }
                        .padding()
                    }
                    Button(action: {
                        showNewCategoryTextField.toggle()
                    }) {
                        Label("New category", systemImage: "plus")
                    }
                }
                Section(header: Text("Ingredients")) {
                    TextField("Ingredients", text: $recipe.ingredient, axis: .vertical)
                }
                
                Section(header: Text("Directions")) {
                    TextField("Directions", text: $recipe.directions, axis: .vertical)
                }
                Button {
                    save()
                    dismiss()
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                }
                .background(Color.black)
                .cornerRadius(22)
                .listRowBackground(Color.clear)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .background(Color.bg)
            .scrollContentBackground(.hidden)
            .navigationTitle("Recipe")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
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
            .onAppear {
                if selectedCategory == nil && !categories.isEmpty {
                    selectedCategory = categories.first
                }
            }
        }
    }
}

private extension EditRecipeView {
    func save() {
        modelContext.insert(recipe)
        recipe.category = selectedCategory
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
