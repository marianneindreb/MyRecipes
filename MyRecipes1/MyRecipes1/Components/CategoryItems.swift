import SwiftUI
import SwiftData

struct CategoryItems: View {
    @Query var categories: [Category]
    
    var body: some View {
        HStack {
            ForEach(categories) { category in
                NavigationLink(destination: CategoryDetailView(category: category)) {
                    VStack {
                        if let imageData = category.image,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 90)
                                .cornerRadius(10)
                        } else {
                            Rectangle()
                                .frame(width: 110, height: 90)
                                .cornerRadius(10)
                                .foregroundStyle(Color.gray)
                                .opacity(0.1)
                        }
                        Text(category.title)
                            .font(.caption)
                    }
                    .padding(.bottom)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    CategoryItems()
}
