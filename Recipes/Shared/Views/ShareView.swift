//
//  ShareView.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/17/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController

    let items: [Any]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareView>) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareView>) {
    }
}
