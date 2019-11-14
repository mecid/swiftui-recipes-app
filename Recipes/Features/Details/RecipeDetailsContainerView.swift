//
//  RecipeDetailsContainerView.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

struct RecipeDetailsContainerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var webViewShown = false

    let uri: String

    private var recipe: Recipe {
        store.state.allRecipes[uri] ?? .mock
    }

    private var isFavorited: Bool {
        store.state.favorited.contains(recipe.uri)
    }

    var body: some View {
        RecipeDetailsView(recipe: recipe)
            .navigationBarTitle(Text(recipe.title), displayMode: .inline)
            .navigationBarItems(
                trailing: HStack(spacing: 16) {
                    Button(action: { self.webViewShown = true }) {
                        Image(systemName: "list.number")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }

                    Button(action: {
                        if self.isFavorited {
                            self.store.send(.removeFromFavorites(recipe: self.recipe))
                        } else {
                            self.store.send(.saveToFavorites(recipe: self.recipe))
                        }
                    }) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .accessibility(label: Text(isFavorited ? "removeFromFavorites" : "addToFavorites"))
                    }
                }
        ).sheet(isPresented: $webViewShown) {
            WebView(url: self.recipe.shareAs)
                .navigationBarTitle(Text(self.recipe.title), displayMode: .inline)
                .embedInNavigation()
                .accentColor(.green)
        }
    }
}
