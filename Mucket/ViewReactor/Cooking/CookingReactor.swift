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
        case filterByFolder(folderId: String?) // folderId가 nil이면 전체보기
    }

    enum Mutation {
        case setCookings([MyCookingEntity])
        case setRoute(Route)
        case setFilteredCookings([MyCookingEntity])
    }

    struct State {
        var route: Route = .none
        var cookings: [MyCookingEntity] = [] // MyCookingEntity 리스트
        var filteredCookings: [MyCookingEntity] = [] // 필터링된 요리 목록
        var currentFolderId: String? // 현재 선택된 폴더 ID (nil이면 전체보기)
    }

    init(myCookingRepository: MyCookingRepositoryType) {
        self.myCookingRepository = myCookingRepository
        
        // 초기 상태에서 전체 요리 목록을 가져오고 filteredCookings에도 동일하게 설정
        let allCookings = myCookingRepository.fetchAll()
        self.initialState = State(
            cookings: allCookings,
            filteredCookings: allCookings
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchCookings:
                // MyCookingRepository에서 데이터를 받아옴
                let cookings = myCookingRepository.fetchAll()
                return .concat([
                    .just(.setCookings(cookings)),
                    .just(.setFilteredCookings(cookings)) // 초기에는 모든 요리 표시
                ])
        case .cookingCellTapped(let cookings):
            return .just(.setRoute(.detail(cooking: cookings)))
        case .clearRouting:
            return .just(.setRoute(.none))
        case .filterByFolder(let folderId):
            // folderId가 nil이면 전체 요리 표시, 아니면 해당 폴더의 요리만 필터링
            if let folderId = folderId {
                let filteredCookings = myCookingRepository.fetch(in: folderId)
                return .just(.setFilteredCookings(filteredCookings))
            } else {
                return .just(.setFilteredCookings(currentState.cookings))
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCookings(let cookings):
            newState.cookings = cookings
        case .setRoute(let route):
            newState.route = route
        case .setFilteredCookings(let cookings):
            newState.filteredCookings = cookings
        }
        return newState
    }
}
