//
//  Recipe.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import Foundation
import Combine

enum Health: String, CaseIterable, Codable {
    case vegan
    case vegetarian
    case gluten = "gluten-free"
    case keto = "keto-friendly"
}

struct Recipe: Codable, Hashable {
    let uri: String
    let title: String
    let ingredients: [String]
    let image: URL
    let calories: Double
    let totalWeight: Double
    let shareAs: URL
    let url: String
    let cautions: [String]

    enum CodingKeys: String, CodingKey {
        case uri
        case title = "label"
        case ingredients = "ingredientLines"
        case image
        case calories
        case totalWeight
        case shareAs
        case cautions
        case url
    }
}

extension Recipe {
    static let mock = Recipe(
        uri: "http://www.edamam.com/ontologies/edamam.owl#recipe_ad1c8d4088d41ffbcf0715a5fa9b9572",
        title: "Breakfast",
        ingredients: ["123", "123", "123"],
        image: URL(string: "https://www.edamam.com/web-img/70a/70aaa8022bf8706c375551c44718eaab.jpg")!,
        calories: 10,
        totalWeight: 10,
        shareAs: URL(string: "http://www.seriouseats.com/recipes/2008/03/sack-lunch-fairytale-picnic-fresh-pickled-vegetables-recipe.html")!,
        url: "http://www.seriouseats.com/recipes/2008/03/sack-lunch-fairytale-picnic-fresh-pickled-vegetables-recipe.html",
        cautions: []
    )
}

enum RecipesServiceError: Error {
    case invalidURL
    case url(error: URLError)
    case decoder(error: Error)
}

protocol RecipesService {
    func fetch(matching query: String, in diet: Health, page: Int) -> AnyPublisher<[Recipe], RecipesServiceError>
}

struct RecipesServiceLive: RecipesService {
    private enum RecipeServiceConstants {
        static let count = 100
    }

    private struct RecipesResponse: Decodable {
        let hits: [Hit]

        struct Hit: Decodable {
            let recipe: Recipe
        }
    }

    let session: URLSession
    let decoder: JSONDecoder

    func fetch(matching query: String, in diet: Health, page: Int) -> AnyPublisher<[Recipe], RecipesServiceError> {
        let from = page * RecipeServiceConstants.count
        let to = from + RecipeServiceConstants.count

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
            .init(name: "health", value: diet.rawValue)
        ]

        guard let url = components.url else {
            return Fail<[Recipe], RecipesServiceError>(error: .invalidURL)
                .eraseToAnyPublisher()
        }

        return session
            .dataTaskPublisher(for: URLRequest(url: url))
            .mapError { RecipesServiceError.url(error: $0) }
            .map { $0.data }
            .decode(type: RecipesResponse.self, decoder: decoder)
            .mapError { RecipesServiceError.decoder(error: $0) }
            .map { $0.hits.map { $0.recipe } }
            .eraseToAnyPublisher()
    }
}

struct RecipesServiceMock: RecipesService {
    func fetch(matching query: String, in diet: Health, page: Int) -> AnyPublisher<[Recipe], RecipesServiceError> {
        Just([Recipe.mock])
            .setFailureType(to: RecipesServiceError.self)
            .eraseToAnyPublisher()
    }
}
