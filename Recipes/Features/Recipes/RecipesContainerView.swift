//
//  RecipesContainerView.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

struct RecipesContainerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    let query: String

    var body: some View {
        RecipesView(recipes: store.state.recipes)
            .navigationBarTitle(Text(query.capitalized), displayMode: .inline)
            .onAppear(perform: fetch)
    }

    private func fetch() {
        store.send(SideEffect.search(query: query, health: store.state.health))
    }
}
