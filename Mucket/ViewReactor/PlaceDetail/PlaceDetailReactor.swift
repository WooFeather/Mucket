//
//  PlaceDetailReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/12/25.
//

import ReactorKit

final class PlaceDetailReactor: Reactor {
    
    var initialState: State
    
    private let repository: MyPlaceRepositoryType
    
    init(place: MyPlaceEntity, repository: MyPlaceRepositoryType) {
        self.repository = repository
        self.initialState = State(place: place)
    }
    
    enum Route: Equatable {
        case none
        case prevView
        case editView(place: MyPlaceEntity)
    }
    
    enum Action {
        case backButtonTapped
        case editButtonTapped(MyPlaceEntity)
        case deleteButtonTapped
        case clearRouting
        case clearShowAlert
        case confirmDeleteTapped
        case refreshData
    }
    
    enum Mutation {
        case setRoute(Route)
        case ShowDeleteAlert(Bool)
        case setPlace(MyPlaceEntity)
    }
    
    struct State {
        var route: Route = .none
        var showDeleteAlert = false
        var place: MyPlaceEntity
    }
}

extension PlaceDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.setRoute(.prevView))
        case .editButtonTapped(let myPlaceEntity):
            return .just(.setRoute(.editView(place: myPlaceEntity)))
        case .clearRouting:
            return .just(.setRoute(.none))
        case .deleteButtonTapped:
            return .just(.ShowDeleteAlert(true))
        case .clearShowAlert:
            return .just(.ShowDeleteAlert(false))
        case .confirmDeleteTapped:
            repository.delete(id: currentState.place.id)
            
            return .just(.setRoute(.prevView))
        case .refreshData:
            let placeId = currentState.place.id
            if let updatedPlace = repository.fetchById(placeId)?.toEntity() {
                return .just(.setPlace(updatedPlace))
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
        case .setPlace(let place):
            newState.place = place
        }
        
        return newState
    }
}
