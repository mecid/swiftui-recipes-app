//
//  App.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
struct AppState: Codable, Equatable {
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

func appReducer(state: inout AppState, action: AppAction) {
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
        state.allRecipes = state.allRecipes.filter { key, _ in
            state.favorited.contains(key)
        }
    case .setHealth(let health):
        state.health = health
    }
}
