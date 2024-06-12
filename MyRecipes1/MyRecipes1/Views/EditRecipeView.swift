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
    @State private var showDropdown = false

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
                            .font(.custom("Glacialindifference-Regular", size: 18))
                            .foregroundStyle(.black)
                    }
                }
                Section(header: Text("Recipe")) {
                    TextField("Title", text: $recipe.title)
                        .font(.custom("Glacialindifference-Regular", size: 18))
                }
                Section(header: Text("Description")) {
                    TextField("Short description", text: $recipe.shortDescription)
                        .font(.custom("Glacialindifference-Regular", size: 18))
                }
                Section(header: Text("Estimated time")) {
                    TextField("Preparation + cooking time", text: $recipe.preparationTime)
                        .font(.custom("Glacialindifference-Regular", size: 18))
                }
                Section(header: Text("Servings")) {
                    TextField("Total servings", text: $recipe.servings)
                        .font(.custom("Glacialindifference-Regular", size: 18))
                }
                Section(header: Text("Category")) {
                    if !categories.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text(selectedCategory?.title ?? categories.first?.title ?? "Select Category")
                                    .font(.custom("Glacialindifference-Regular", size: 18))
                                Spacer()
                                Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                            showDropdown.toggle()
                                    }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(Color.white)
                            .cornerRadius(8)
                            

                            if showDropdown {
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(categories) { category in
                                        Text(category.title)
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(selectedCategory == category ? Color.gray.opacity(0.2) : Color.clear)
                                            .onTapGesture {
                                                selectedCategory = category
                                                showDropdown = false
                                            }
                                    }
                                    if showNewCategoryTextField {
                                        HStack {
                                            TextField("New category", text: $newCategoryTitle)
                                                .textFieldStyle(.roundedBorder)
                                                .font(.custom("Glacialindifference-Regular", size: 18))
                                            
                                            Button("Save") {
                                                addNewCategory()
                                                showNewCategoryTextField = false
                                            }
                                            .foregroundColor(.blue)
                                        }
                                        .padding()
                                    } else {
                                        Button(action: {
                                            showNewCategoryTextField.toggle()
                                        }) {
                                            Text("Add New Category")
                                                .font(.custom("Glacialindifference-Regular", size: 18))
                                                .foregroundColor(.blue)
                                                .padding()
                                        
                                        }
                                    }
                                }
                                .background(Color.white)
                                .cornerRadius(8)
                               
                            }
                        }
                    }
                }
                Section(header: Text("Ingredients")) {
                    TextField("Ingredients", text: $recipe.ingredient, axis: .vertical)
                        .font(.custom("Glacialindifference-Regular", size: 18))
                }
                
                Section(header: Text("Directions")) {
                    TextField("Directions", text: $recipe.directions, axis: .vertical)
                        .font(.custom("Glacialindifference-Regular", size: 18))
                }
                Button {
                    save()
                    dismiss()
                } label: {
                    Text("Save")
                        .font(.custom("Glacialindifference-Bold", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                }
                .background(Color.black)
                .cornerRadius(16)
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
                    selectedCategory = recipe.category ?? categories.first
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
        showNewCategoryTextField = false
    }
}
