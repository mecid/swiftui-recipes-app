//
//  View.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

extension View {
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
}
