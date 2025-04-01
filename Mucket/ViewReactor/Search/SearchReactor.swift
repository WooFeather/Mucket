//
//  SearchReactor.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import ReactorKit

final class SearchReactor: Reactor {
    
    private let repository: RecipeRepositoryType = RecipeRepository.shared
    private var searchList: [RecipeEntity] = []
    
    var initialState: State = State()
    
    enum Action {
        case backButtonTapped
        case searchButtonTapped(query: String)
    }
    
    enum Mutation {
        case popToPrevView
        case setSearchResult([RecipeEntity])
        case setSearchTableViewHidden(Bool)
    }
    
    struct State {
        var shouldPopToPrevView = false
        var isSearchTableViewHidden = true
        var searchResult: [RecipeEntity] = []
    }
    
}

extension SearchReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.popToPrevView)
            
        case .searchButtonTapped(let query):
            return fetchSearchData(query: query)
                .flatMap { result in
                    Observable.from([
                        .setSearchResult(result),
                        .setSearchTableViewHidden(false)
                    ])
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .popToPrevView:
            newState.shouldPopToPrevView = true
            
        case .setSearchResult(let result):
            newState.searchResult = result
            
        case .setSearchTableViewHidden(let isHidden):
            newState.isSearchTableViewHidden = isHidden
        }
        return newState
    }
    
    // TODO: 검색어 유효성 검사 로직 추가
    private func fetchSearchData(query: String) -> Observable<[RecipeEntity]> {
        return Observable.create { [weak self] observer in
            Task {
                do {
                    let result = try await self?.repository.search(startIndex: 1, count: 10, byIngredient: query) ?? []
                    self?.searchList = result
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
