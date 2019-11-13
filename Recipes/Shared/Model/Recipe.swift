//
//  Recipe.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import Foundation
import Combine

enum Health: String, Codable {
    case gluten = "gluten-free"
    case keto = "keto-friendly"
    case vegan
    case vegetarian
}

struct Recipe: Codable, Hashable {
    let title: String
    let ingredients: [String]
    let image: URL
    let calories: Double
    let totalWeight: Double
    let url: URL
    let cautions: [String]

    enum CodingKeys: String, CodingKey {
        case title = "label"
        case ingredients = "ingredientLines"
        case image
        case calories
        case totalWeight
        case url
        case cautions
    }
}

extension Recipe {
    static let mock = Recipe(
        title: "Breakfast",
        ingredients: ["123", "123", "123"],
        image: URL(string: "https://www.edamam.com/web-img/70a/70aaa8022bf8706c375551c44718eaab.jpg")!,
        calories: 10,
        totalWeight: 10,
        url: URL(string: "http://www.seriouseats.com/recipes/2008/03/sack-lunch-fairytale-picnic-fresh-pickled-vegetables-recipe.html")!,
        cautions: []
    )
}

struct RecipesService {
    private struct RecipesResponse: Decodable {
        let hits: [Hit]

        struct Hit: Decodable {
            let recipe: Recipe
        }
    }

    private enum Constants {
        static let count = 100
    }

    func fetch(query: String, health: Health = .gluten, page: Int = 1) -> AnyPublisher<[Recipe], Error> {
        let from = page * Constants.count
        let to = from + Constants.count

        var components = URLComponents()

        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/search"

        components.queryItems = [
            .init(name: "q", value: query),
            .init(name: "from", value: String(from)),
            .init(name: "to", value: String(to)),
            .init(name: "app_id", value: "af1dd513"),
            .init(name: "app_key", value: "14d7fdc54649351cd3531103e09fc830"),
            .init(name: "health", value: health.rawValue)
        ]

        guard let url = components.url else {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: url))
            .map { $0.data }
            .decode(type: RecipesResponse.self, decoder: Current.decoder)
            .map { $0.hits.map { $0.recipe } }
            .eraseToAnyPublisher()
    }
}
