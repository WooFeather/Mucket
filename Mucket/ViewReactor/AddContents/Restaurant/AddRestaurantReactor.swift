//
//  AddRestaurantReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import ReactorKit

final class AddRestaurantReactor: Reactor {
    
    var initialState: State = State()
    
    enum Route: Equatable {
        case none
        case searchAddress
        case folder
    }
    
    enum Action {
        case addPhotoButtonTapped
        case searchAddressButtonTapped
        case clearRouting
    }
    
    enum Mutation {
        case setRoute(Route)
        case presentImagePicker(Bool)
    }
    
    struct State {
        var isPresent = false
        var route: Route = .none
    }
}

extension AddRestaurantReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addPhotoButtonTapped:
            return Observable.concat([
                .just(.presentImagePicker(true)),
                .just(.presentImagePicker(false)).delay(.milliseconds(100), scheduler: MainScheduler.instance)
            ])
        case .searchAddressButtonTapped:
            return .just(.setRoute(.searchAddress))
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
