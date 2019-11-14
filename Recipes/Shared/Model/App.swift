//
//  App.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

struct AppState: Codable {
    var recipes: [Recipe] = []
    var favorited: [Recipe] = []
    var health: Health = .gluten
    var nextPage = 0
}

enum AppAction {
    case append(recipes: [Recipe], nextPage: Int)
    case saveToFavorites(recipe: Recipe)
    case removeFromFavorites(recipe: Recipe)
    case setHealth(health: Health)
    case resetState
}

let appReducer: Reducer<AppState, AppAction> = Reducer { state, action in
    switch action {
    case let .append(recipes, nextPage):
        state.recipes.append(contentsOf: recipes)
        state.nextPage = nextPage
    case let .saveToFavorites(recipe):
        state.favorited.append(recipe)
    case let .removeFromFavorites(recipe):
        state.favorited.removeAll { $0.uri == recipe.uri }
    case .resetState:
        state.recipes.removeAll()
        state.nextPage = 0
    case .setHealth(let health):
        state.health = health
    }
}
