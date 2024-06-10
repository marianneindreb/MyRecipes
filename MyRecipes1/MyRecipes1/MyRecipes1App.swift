//
//  MyRecipes1App.swift
//  MyRecipes1
//
//  Created by Marianne Indrebø on 09/06/2024.
//

import SwiftUI
import SwiftData

@main
struct MyRecipes1App: App {
    var body: some Scene {
        WindowGroup {
            MyRecipesView()
        }
        .modelContainer(for: Recipe.self)
    }
}
