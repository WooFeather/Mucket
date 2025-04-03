//
//  AddCookingReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import ReactorKit

final class AddCookingReactor: Reactor {
    
    var initialState: State = State()
    
    enum Route: Equatable {
        case none
        case folder // TODO: 현재 폴더 기억한채로 이동(기본값은 기본폴더)
    }
    
    enum Action {
        case addPhotoButtonTapped
        case folderSelectButtonTapped
        case clearRouting
    }
    
    enum Mutation {
        case presentImagePicker(Bool)
        case setRoute(Route)
    }
    
    struct State {
        var isPresent = false
        var route: Route = .none
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
        case .folderSelectButtonTapped:
            return .just(.setRoute(.folder))
        case .clearRouting:
            return .just(.setRoute(.none))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .presentImagePicker(let isPresent):
            newState.isPresent = isPresent
        case .setRoute(let route):
            newState.route = route
        }
        return newState
    }
}
