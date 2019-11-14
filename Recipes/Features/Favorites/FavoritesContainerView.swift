//
//  FavoritesContainerView.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

struct FavoritesContainerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>

    var body: some View {
        RecipesView(recipes: store.state.favorited)
            .navigationBarTitle("favorites")
    }
}
