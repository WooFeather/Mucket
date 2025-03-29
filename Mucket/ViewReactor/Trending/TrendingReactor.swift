//
//  TrendingReactor.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import ReactorKit

final class TrendingReactor: Reactor {
    
    var initialState: State = State()
    
    /// 화면 이동을 위한 열거형
    enum Route {
        case none
        case searchView
    }
    
    enum Action {
        case searchViewTapped
        case clearRouting
    }
    
    enum Mutation {
        case pushToSearchView
        case clearRoutingFlag
    }
    
    struct State {
        var shouldRouteToSearchView: Route = .none
    }
}


extension TrendingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchViewTapped:
                .just(.pushToSearchView)
        case .clearRouting:
                .just(.clearRoutingFlag)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .pushToSearchView:
            newState.shouldRouteToSearchView = .searchView
        case .clearRoutingFlag:
            newState.shouldRouteToSearchView = .none
        }
        
        return newState
    }
}
