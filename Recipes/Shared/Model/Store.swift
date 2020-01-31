//
//  Store.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/10/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI
import Combine

typealias Reducer<State, Action> = (inout State, Action) -> Void

func combine<State, Action>(_ reducers: Reducer<State, Action>...) -> Reducer<State, Action> {
    return { state, action in
        reducers.forEach { $0(&state, action) }
    }
}

func lift<ViewState, State, ViewAction, Action>(
    _ reducer: @escaping Reducer<ViewState, ViewAction>,
    keyPath: WritableKeyPath<State, ViewState>,
    transform: @escaping (Action) -> ViewAction?
) -> Reducer<State, Action> {
    return { state, action in
        if let localAction = transform(action) {
            reducer(&state[keyPath: keyPath], localAction)
        }
    }
}

final class Store<State, Action>: ObservableObject {
    typealias Effect = AnyPublisher<Action, Never>

    @Published private(set) var state: State

    private let reducer: Reducer<State, Action>
    private var cancellables: Set<AnyCancellable> = []
    private var viewCancellable: AnyCancellable?

    init(initialState: State, reducer: @escaping Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }

    func send(_ action: Action) {
        reducer(&state, action)
    }

    func send(_ effect: Effect){
        var didComplete = false
        var cancellable: AnyCancellable?
        cancellable = effect
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                didComplete = true
                if let cancellable = cancellable {
                    self?.cancellables.remove(cancellable)
                }
            }, receiveValue: send)
        if !didComplete, let cancellable = cancellable {
            cancellables.insert(cancellable)
        }
    }
}

extension Store {
    func view<ViewState, ViewAction>(
        state toLocalState: @escaping (State) -> ViewState,
        action toGlobalAction: @escaping (ViewAction) -> Action
    ) -> Store<ViewState, ViewAction> {
        let viewStore = Store<ViewState, ViewAction>(
            initialState: toLocalState(state)
        ) { state, action in
            self.send(toGlobalAction(action))
        }
        viewStore.viewCancellable = $state
            .map(toLocalState)
            .assign(to: \.state, on: viewStore)
        return viewStore
    }
}

extension Store {
    func binding<Value>(
        for keyPath: KeyPath<State, Value>,
        _ action: @escaping (Value) -> Action
    ) -> Binding<Value> {
        Binding<Value>(
            get: { self.state[keyPath: keyPath] },
            set: { self.send(action($0)) }
        )
    }
}

extension Store where State: Codable {
    func save() {
        DispatchQueue.global(qos: .utility).async {
            guard
                let documentsURL = Current.files.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
                let data = try? Current.encoder.encode(self.state)
                else { return }

            try? Current.files.createDirectory(
                at: documentsURL,
                withIntermediateDirectories: true,
                attributes: nil
            )

            let stateURL = documentsURL.appendingPathComponent("state.json")

            if Current.files.fileExists(atPath: stateURL.absoluteString) {
                try? Current.files.removeItem(at: stateURL)
            }

            try? data.write(to: stateURL, options: .atomic)
        }
    }

    func load() {
        DispatchQueue.global(qos: .utility).async {
            guard
                let documentsURL = Current.files.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
                let data = try? Data(contentsOf: documentsURL.appendingPathComponent("state.json")),
                let state = try? Current.decoder.decode(State.self, from: data)
                else { return }

            DispatchQueue.main.async {
                self.state = state
            }
        }
    }
}
