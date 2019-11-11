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
    var isLoading = false
    var nextPage = 0
}

enum AppAction {
    case append(recipes: [Recipe], nextPage: Int)
    case saveToFavorites(recipe: Recipe)
    case removeFromFavorites(recipe: Recipe)
    case set(loading: Bool)
    case resetState
}

let appReducer: Reducer<AppState, AppAction> = Reducer { state, action in
    switch action {
    case let .append(recipes, nextPage):
        state.recipes.append(contentsOf: recipes)
        state.nextPage = nextPage
        state.isLoading = false
    case let .saveToFavorites(recipe):
        state.favorited.append(recipe)
    case let .removeFromFavorites(recipe):
        state.favorited.removeAll { $0.url == recipe.url }
    case let .set(loading):
        state.isLoading = loading
    case .resetState:
        state.recipes.removeAll()
        state.isLoading = false
        state.nextPage = 0
    }
}
