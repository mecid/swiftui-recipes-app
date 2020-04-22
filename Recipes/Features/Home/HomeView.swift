//
//  HomeView.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

struct CategoryView: View {
    let category: Category

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(category.query)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)

            LinearGradient(
                gradient: .init(colors: [Color.clear, Color.black.opacity(0.7)]),
                startPoint: .center,
                endPoint: .bottom
            )

            Text(LocalizedStringKey(category.title))
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
        }
    }
}

struct HomeView: View {
    @Binding var health: Health

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Picker(selection: $health, label: Text("health")) {
                    ForEach(Health.allCases, id: \.self) { health in
                        Text(LocalizedStringKey(health.rawValue)).tag(health)
                    }
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ForEach(0..<Home.categories.count) { index in
                    NavigationLink(destination: RecipesContainerView(query: Home.categories[index].query)) {
                        CategoryView(category: Home.categories[index])
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(health: .init(get: { .gluten }, set: { _ in }))
    }
}
