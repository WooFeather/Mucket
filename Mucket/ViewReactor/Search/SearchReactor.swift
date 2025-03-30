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
        case searchButtonTapped
    }
    
    enum Mutation {
        case popToPrevView
        case fetchSearchResult
    }
    
    struct State {
        var shouldPopToPrevView = false
        var isSearchTableViewHidden = true
    }
    
}

extension SearchReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
                .just(.popToPrevView)
        case .searchButtonTapped:
                .just(.fetchSearchResult)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .popToPrevView:
            newState.shouldPopToPrevView = true
        case .fetchSearchResult:
            // TODO: 추후에 네트워크 요청 붙일 예정
            newState.isSearchTableViewHidden = false
        }
        
        return newState
    }
}
