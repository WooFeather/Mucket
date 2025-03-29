//
//  SearchReactor.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import ReactorKit

final class SearchReactor: Reactor {
    
    var initialState: State = State()
    
    enum Action {
        case backButtonTapped
    }
    
    enum Mutation {
        case popToPrevView
    }
    
    struct State {
        var shouldPopToPrevView = false
    }
    
}


extension SearchReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
                .just(.popToPrevView)
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
