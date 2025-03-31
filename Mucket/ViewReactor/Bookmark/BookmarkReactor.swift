//
//  BookmarkReactor.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import ReactorKit

final class BookmarkReactor: Reactor {
    
    var initialState: State = State()
    
    enum Action {
        case searchButtonTapped
    }
    
    enum Mutation {
        case filtering
    }
    
    struct State {
        var isKeyboardHidden = false
    }
}

extension BookmarkReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchButtonTapped:
                .just(.filtering)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .filtering:
            // TODO: 추후에 필터링 기능 추가 예정
            newState.isKeyboardHidden = true
        }
        return newState
    }
}
