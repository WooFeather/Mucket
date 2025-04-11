//
//  PlaceReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/11/25.
//

import ReactorKit

final class PlaceReactor: Reactor {
    
    var initialState: State = State()
    
    enum Route: Equatable {
        
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
}

extension PlaceReactor {
    func mutate(action: Action) -> Observable<Mutation> {
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
