//
//  RecipeDetailsContainerView.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

struct RecipeDetailsContainerView: View {
    @EnvironmentObject var store: AppStore

    @State private var stepsShown = false
    @State private var shareShown = false

    let uri: String

    private var recipe: Recipe {
        store.state.allRecipes[uri] ?? .mock
    }

    private var isFavorited: Bool {
        store.state.favorited.contains(recipe.uri)
    }

    var body: some View {
        RecipeDetailsView(recipe: recipe, showSteps: { self.stepsShown = true })
            .navigationBarTitle(Text(recipe.title), displayMode: .inline)
            .navigationBarItems(
                trailing: HStack(spacing: 16) {
                    Button(action: {
                        if self.isFavorited {
                            self.store.send(.removeFromFavorites(recipe: self.recipe))
                        } else {
                            self.store.send(.saveToFavorites(recipe: self.recipe))
                        }
                    }) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.headline)
                            .accessibility(label: Text(isFavorited ? "removeFromFavorites" : "addToFavorites"))
                    }

                    Button(action: { self.shareShown = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.headline)
                            .accessibility(label: Text("share"))
                    }.sheet(isPresented: $shareShown) {
                        ShareView(items: [self.recipe.shareAs])
                    }
                }
        ).sheet(isPresented: $stepsShown) {
            SafariView(
                url: URL(string: self.recipe.url) ?? self.recipe.shareAs,
                readerMode: true
            )
                .navigationBarTitle(Text(self.recipe.title), displayMode: .inline)
                .accentColor(.green)
        }
    }
}
