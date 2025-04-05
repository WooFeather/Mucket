//
//  CookingDetailReactor.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import ReactorKit

final class CookingDetailReactor: Reactor {
    
    var initialState: State
    
    private let repository: MyCookingRepositoryType
    
    init(cooking: MyCookingEntity, repository: MyCookingRepositoryType) {
        self.repository = repository
        self.initialState = State(cooking: cooking)
    }
    
    enum Route: Equatable {
        case none
        case prevView
        case editView(cooking: MyCookingEntity)
    }
    
    enum Action {
        case backButtonTapped
        case editButtonTapped(MyCookingEntity)
        case deleteButtonTapped
        case clearRouting
        case clearShowAlert
        case confirmDeleteTapped
        case refreshData
    }
    
    enum Mutation {
        case setRoute(Route)
        case ShowDeleteAlert(Bool)
        case setCooking(MyCookingEntity)
    }
    
    struct State {
        var route: Route = .none
        var showDeleteAlert = false
        var cooking: MyCookingEntity
    }
}

extension CookingDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.setRoute(.prevView))
        case .editButtonTapped(let myCookingEntity):
            return .just(.setRoute(.editView(cooking: myCookingEntity)))
        case .clearRouting:
            return .just(.setRoute(.none))
        case .deleteButtonTapped:
            return .just(.ShowDeleteAlert(true))
        case .clearShowAlert:
            return .just(.ShowDeleteAlert(false))
        case .confirmDeleteTapped:
            repository.delete(id: currentState.cooking.id)
            
            return .just(.setRoute(.prevView))
        case .refreshData:
            let cookingId = currentState.cooking.id
            if let updatedCooking = repository.fetchById(cookingId)?.toEntity() {
                return .just(.setCooking(updatedCooking))
            }
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRoute(let route):
            newState.route = route
        case .ShowDeleteAlert(let isShow):
            newState.showDeleteAlert = isShow
        case .setCooking(let cooking):
            newState.cooking = cooking
        }
        
        return newState
    }
}
