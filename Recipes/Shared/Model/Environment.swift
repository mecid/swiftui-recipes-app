
//
//  Environment.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import Foundation
import Combine

// For more information check "How To Control The World" - Stephen Celis
// https://vimeo.com/291588126

struct Environment {
    var counter = LaunchCounter()
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()
    var fetch = RecipesService().fetch
    var files = FileManager.default
}

var Current = Environment()
