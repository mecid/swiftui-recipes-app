//
//  Categories.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import Foundation

struct Home {
    static let categories = [
        Category(title: "Breakfast", query: "breakfast"),
        Category(title: "Lunch", query: "lunch"),
        Category(title: "Dinner", query: "dinner"),
        Category(title: "Smoothie", query: "smoothie"),
        Category(title: "Dessert", query: "dessert")
    ]
}

struct Category {
    let title: String
    let query: String
}
