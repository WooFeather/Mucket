//
//  AddCookingReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import ReactorKit

final class AddCookingReactor: Reactor {
    
    var initialState: State = State()
    
    enum Action {
        case addPhotoButtonTapped
    }
    
    enum Mutation {
        case presentImagePicker(Bool)
    }
    
    struct State {
        var isPresent = false
    }
}

extension AddCookingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addPhotoButtonTapped:
            return Observable.concat([
                .just(.presentImagePicker(true)),
                .just(.presentImagePicker(false)).delay(.milliseconds(100), scheduler: MainScheduler.instance)
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .presentImagePicker(let isPresent):
            newState.isPresent = isPresent
        }
        return newState
    }
}
