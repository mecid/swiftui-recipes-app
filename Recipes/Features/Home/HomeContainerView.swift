//
//  HomeContainerView.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

struct HomeContainerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var favoritesShown = false

    private var hasFavorites: Bool {
        !store.state.favorited.isEmpty
    }

    var body: some View {
        HomeView()
            .onAppear { self.store.send(.resetState) }
            .navigationBarTitle("Recipes")
            .navigationBarItems(
                trailing: hasFavorites ? Button(action: { self.favoritesShown = true }) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .accessibility(label: Text("Favorites"))
                } : nil
        ).sheet(isPresented: $favoritesShown) {
                FavoritesContainerView()
                    .environmentObject(self.store)
                    .embedInNavigation()
                    .accentColor(.green)
        }
    }
}
