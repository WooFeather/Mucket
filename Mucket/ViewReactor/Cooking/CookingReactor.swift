//
//  CookingReactor.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import ReactorKit

final class CookingReactor: Reactor {
    private let myCookingRepository: MyCookingRepositoryType

    var initialState: State

    enum Route: Equatable {
        case none
        case detail(cooking: MyCookingEntity)
    }
    
    enum Action {
        case fetchCookings
        case cookingCellTapped(MyCookingEntity)
        case clearRouting
    }

    enum Mutation {
        case setCookings([MyCookingEntity])
        case setRoute(Route)
    }

    struct State {
        var route: Route = .none
        var cookings: [MyCookingEntity] = [] // MyCookingEntity 리스트
    }

    init(myCookingRepository: MyCookingRepositoryType) {
        self.myCookingRepository = myCookingRepository
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchCookings:
            // MyCookingRepository에서 데이터를 받아옴
            let cookings = myCookingRepository.fetchAll()
            return Observable.just(.setCookings(cookings))
        case .cookingCellTapped(let cookings):
            return .just(.setRoute(.detail(cooking: cookings)))
        case .clearRouting:
            return .just(.setRoute(.none))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCookings(let cookings):
            newState.cookings = cookings
        case .setRoute(let route):
            newState.route = route
        }
        return newState
    }
}
