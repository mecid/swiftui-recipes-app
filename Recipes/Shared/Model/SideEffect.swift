//
//  SideEffect.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import Combine

extension Publisher where Failure == Never {
    func eraseToEffect() -> Effect<Output> {
        Effect(publisher: eraseToAnyPublisher())
    }
}

extension Effect {
    static func search(query: String, health: Health, page: Int = 0) -> Effect<AppAction> {
        Current.fetch(query, health, page)
            .replaceError(with: [])
            .map { .append(recipes: $0)}
            .eraseToEffect()
    }
}
