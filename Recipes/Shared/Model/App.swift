//
//  App.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import Combine
import Foundation

// For more information check "How To Control The World" - Stephen Celis
// https://vimeo.com/291588126
struct AppEnvironment {
    let counter = LaunchCounter()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let files = FileManager.default

    var service: RecipesService {
        RecipesServiceLive(session: .shared, decoder: decoder)
    }
}

struct AppState: Codable, Equatable {
    var allRecipes: [String: Recipe] = [:]
    var recipes: [String] = []
    var favorited: [String] = []
    var health: Health = .gluten
    var currentQuery = ""
}

enum AppAction {
    case append(recipes: [Recipe])
    case saveToFavorites(recipe: Recipe)
    case removeFromFavorites(recipe: Recipe)
    case setHealth(health: Health)
    case search(query: String, page: Int = 0)
    case set(state: AppState)
    case resetState
    case load
    case save
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer { state, action, environment in
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
        state.recipes.removeAll()
        state.currentQuery = ""
    case let .search(newQuery, page):
        guard state.currentQuery != newQuery else {
            return Empty().eraseToAnyPublisher()
        }

        state.recipes.removeAll()
        state.currentQuery = newQuery

        return environment.service
            .fetch(matching: state.currentQuery, in: state.health, page: page)
            .replaceError(with: [])
            .map { .append(recipes: $0)}
            .eraseToAnyPublisher()
    case let .set(newState):
        state = newState
    case .load:
        return environment.files
            .read(name: "state.json", in: .applicationSupportDirectory)
            .decode(type: AppState.self, decoder: environment.decoder)
            .replaceError(with: AppState())
            .map { AppAction.set(state: $0) }
            .eraseToAnyPublisher()
    case .save:
        return Just(state)
            .encode(encoder: environment.encoder)
            .flatMap { environment.files.write(data: $0, name: "state.json", in: .applicationSupportDirectory) }
            .map { _ in AppAction.resetState }
            .replaceError(with: .resetState)
            .eraseToAnyPublisher()
    }

    return Empty(completeImmediately: true).eraseToAnyPublisher()
}

typealias AppStore = Store<AppState, AppAction>
