//
//  App.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

struct AppState: Codable {
    var allRecipes: [String: Recipe] = [:]
    var recipes: [String] = []
    var favorited: [String] = []
    var health: Health = .gluten
}

enum AppAction {
    case append(recipes: [Recipe])
    case saveToFavorites(recipe: Recipe)
    case removeFromFavorites(recipe: Recipe)
    case setHealth(health: Health)
    case resetState
}

let appReducer: Reducer<AppState, AppAction> = Reducer { state, action in
    switch action {
    case let .append(recipes):
        recipes.forEach { state.allRecipes[$0.uri] = $0 }
        state.recipes = recipes.map { $0.uri }
    case let .saveToFavorites(recipe):
        state.favorited.append(recipe.uri)
    case let .removeFromFavorites(recipe):
        state.favorited.removeAll { $0 == recipe.uri }
    case .resetState:
        state.recipes.removeAll()
    case .setHealth(let health):
        state.health = health
    }
}
