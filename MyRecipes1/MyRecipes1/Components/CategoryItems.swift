import SwiftUI
import SwiftData

struct CategoryItems: View {
    @Query var categories: [Category]
    
    var body: some View {
        HStack {
            ForEach(categories) { category in
                NavigationLink(destination: CategoryDetailView(category: category)) {
                    VStack(alignment: .leading){
                        if let imageData = category.image,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 90)
                                .cornerRadius(10)
                        } else {
                            ZStack {
                                Rectangle()
                                    .frame(width: 110, height: 90)
                                    .cornerRadius(10)
                                    .foregroundStyle(Color.gray)
                                    .opacity(0.1)
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                            }
                        }
                        Text(category.title)
                            .font(.custom("Glacialindifference-Regular", size: 14))
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
