//
//  SideEffect.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import Combine

enum SideEffect: Effect {
    case search(query: String, page: Int = 0)

    func mapToAction() -> AnyPublisher<AppAction, Never> {
        switch self {
        case let .search(query, page):
            return Current.fetch(query, page)
                .replaceError(with: [])
                .map { .append(recipes: $0, nextPage: page + 1)}
                .prepend(.set(loading: true))
                .eraseToAnyPublisher()
        }
    }
}
