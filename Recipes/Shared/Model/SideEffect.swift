//
//  SideEffect.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import Combine

func search(query: String, health: Health, page: Int = 0) -> AnyPublisher<AppAction, Never> {
    Current.service
        .fetch(query, health, page)
        .replaceError(with: [])
        .map { .append(recipes: $0)}
        .eraseToAnyPublisher()
}
