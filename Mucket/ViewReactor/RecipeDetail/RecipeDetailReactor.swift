//
//  File.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import ReactorKit

final class RecipeDetailReactor: Reactor {
    let initialState: State

    init(recipe: RecipeEntity) {
        self.initialState = State(recipe: recipe)
    }
    
    enum Action {
        case backButtonTapped
    }
    
    enum Mutation {
        case popToPrevView
    }
    
    struct State {
        var shouldPopToPrevView = false
        let recipe: RecipeEntity
        var manualSteps: [RecipeManualStep] { recipe.manualSteps }
    }
}

extension RecipeDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
           return .just(.popToPrevView)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .popToPrevView:
            newState.shouldPopToPrevView = true
        }
        
        return newState
    }
}
