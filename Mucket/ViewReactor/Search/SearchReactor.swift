//
//  SearchReactor.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import ReactorKit

final class SearchReactor: Reactor {
    
    var initialState: State = State()
    
    private let repository: RecipeRepositoryType = RecipeRepository.shared
    
    enum Route: Equatable {
        case none
        case detail(recipe: RecipeEntity)
    }
    
    enum Action {
        case backButtonTapped
        case searchButtonTapped(query: String)
        case searchCellTapped(recipe: RecipeEntity)
        case clearRouting
    }
    
    enum Mutation {
        case popToPrevView
        case setSearchResult([RecipeEntity])
        case setSearchTableViewHidden(Bool)
        case setEmptyStateHidden(Bool)
        case setLoadingIndicator(Bool)
        case setRoute(Route)
    }
    
    struct State {
        var shouldPopToPrevView = false
        var isSearchTableViewHidden = true
        var isEmptyStateHidden = true
        var searchResult: [RecipeEntity] = []
        var isLoading = false
        var route: Route = .none
    }
}

extension SearchReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.popToPrevView)
            
        case .searchButtonTapped(let query):
            return .concat([
                .just(.setLoadingIndicator(true)),
                fetchSearchData(query: query)
                    .flatMap { result in
                        Observable.from([
                            .setSearchResult(result),
                            .setEmptyStateHidden(result.isEmpty == false),
                            .setSearchTableViewHidden(result.isEmpty)
                        ])
                    },
                .just(.setLoadingIndicator(false))
            ])
        case .searchCellTapped(recipe: let recipe):
            return .just(.setRoute(.detail(recipe: recipe)))
        case .clearRouting:
            return .just(.setRoute(.none))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .popToPrevView:
            newState.shouldPopToPrevView = true
        case .setSearchResult(let result):
            newState.searchResult = result
        case .setEmptyStateHidden(let hidden):
            newState.isEmptyStateHidden = hidden
        case .setSearchTableViewHidden(let isHidden):
            newState.isSearchTableViewHidden = isHidden
        case .setLoadingIndicator(let isLoading):
            newState.isLoading = isLoading
        case .setRoute(let route):
            newState.route = route
        }
        return newState
    }
}

// MARK: - Functions
extension SearchReactor {
    // TODO: 검색어 유효성 검사 로직 추가
    private func fetchSearchData(query: String) -> Observable<[RecipeEntity]> {
        return Observable.create { [weak self] observer in
            Task {
                do {
                    let result = try await self?.repository.search(startIndex: 1, count: 10, byIngredient: query) ?? []
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    print("❌ 검색 실패: \(error)")
                    observer.onNext([])
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
