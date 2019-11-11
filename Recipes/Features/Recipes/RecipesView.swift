//
//  RecipesView.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import Grid
import KingfisherSwiftUI
import SwiftUI

struct RecipesView: View {
    let recipes: [Recipe]

    private var grid: some View {
        Grid {
            ForEach(recipes, id: \.self) { recipe in
                NavigationLink(destination: RecipeDetailsContainerView(recipe: recipe)) {
                    ZStack(alignment: .bottomLeading) {
                        KFImage(recipe.image)
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fill)

                        LinearGradient(
                            gradient: .init(colors: [Color.clear, .gray]),
                            startPoint: .center,
                            endPoint: .bottom
                        )

                        Text(recipe.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
        }.gridStyle(FixedColumnsGridStyle(columns: 2, itemHeight: 200, spacing: 0))
    }

    var body: some View {
        Group {
            if recipes.isEmpty {
                ActivityView()
            } else {
                grid
            }
        }
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView(recipes: [.mock, .mock, .mock, .mock])
    }
}
