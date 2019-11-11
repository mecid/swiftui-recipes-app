//
//  ActivityView.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

struct ActivityView: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView

    func makeUIView(context: UIViewRepresentableContext<ActivityView>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: .medium)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityView>) {
        uiView.startAnimating()
    }

}
