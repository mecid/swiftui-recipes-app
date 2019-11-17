//
//  RecipeDetailsView.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import KingfisherSwiftUI
import SwiftUI

struct RecipeDetailsView: View {
    let recipe: Recipe
    let showSteps: () -> Void

    private var subheadline: some View {
        Text("\(Int(recipe.calories)) kcal ")
            +
            Text("\(Int(recipe.totalWeight)) g")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                KFImage(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()

                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading) {
                        Text(recipe.title)
                            .font(.title)
                            .fixedSize(horizontal: false, vertical: true)

                        subheadline
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    ForEach(recipe.ingredients, id: \.self) { ingridient in
                        Text("• \(ingridient)")
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Button(action: showSteps) {
                        Text("steps")
                    }.buttonStyle(FilledButtonStyle())
                }.padding(.horizontal)
            }
        }
    }
}

struct RecipeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailsView(
            recipe: .mock,
            showSteps: {}
        )
    }
}
