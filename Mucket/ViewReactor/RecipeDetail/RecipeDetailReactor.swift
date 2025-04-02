//
//  File.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import ReactorKit

final class RecipeDetailReactor: Reactor {
    let initialState: State
    
    private let repository: BookmarkedRecipeRepositoryType

    init(recipe: RecipeEntity, repository: BookmarkedRecipeRepositoryType) {
        repository.getFileURL()
        self.repository = repository
        let isBookmarked = repository.isBookmarked(id: recipe.id)
        self.initialState = State(recipe: recipe, isBookmarked: isBookmarked)
    }
    
    enum Action {
        case backButtonTapped
        case bookmarkButtonTapped
    }
    
    enum Mutation {
        case popToPrevView
        case setBookmarked(Bool)
    }
    
    struct State {
        var shouldPopToPrevView = false
        let recipe: RecipeEntity
        var manualSteps: [RecipeManualStep] { recipe.manualSteps }
        var isBookmarked: Bool = false
    }
}

extension RecipeDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.popToPrevView)
        case .bookmarkButtonTapped:
            let isCurrentlyBookmarked = repository.isBookmarked(id: currentState.recipe.id)
            
            if isCurrentlyBookmarked {
                repository.delete(by: currentState.recipe.id)
            } else {
                repository.save(currentState.recipe)
            }
            
            return .just(.setBookmarked(!isCurrentlyBookmarked))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .popToPrevView:
            newState.shouldPopToPrevView = true
        case .setBookmarked(let isBookmarked):
            newState.isBookmarked = isBookmarked
        }
        
        return newState
    }
}
