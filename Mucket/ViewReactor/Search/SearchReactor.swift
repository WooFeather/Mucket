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
        case loadNextPageIfNeeded(index: Int)
        case clearAlert
    }
    
    enum Mutation {
        case popToPrevView
        case setSearchResult([RecipeEntity])
        case appendSearchResult([RecipeEntity])
        case setSearchTableViewHidden(Bool)
        case setEmptyStateHidden(Bool)
        case setLoadingIndicator(Bool)
        case setRoute(Route)
        case setQuery(String)
        case setPage(Int)
        case showAlert(message: String)
        case clearAlertMessage
    }
    
    struct State {
        var shouldPopToPrevView = false
        var isSearchTableViewHidden = true
        var isEmptyStateHidden = true
        var searchResult: [RecipeEntity] = []
        var isLoading = false
        var route: Route = .none
        var currentQuery: String = ""
        var currentPage: Int = 1
        var alertMessage: String? = nil
    }
}

extension SearchReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.popToPrevView)
            
        case .searchButtonTapped(let query):
            let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedQuery.isEmpty else {
                return .just(.showAlert(message: "검색어를 입력해주세요."))
            }

            return .concat([
                .just(.setQuery(trimmedQuery)),
                .just(.setPage(1)),
                .just(.setLoadingIndicator(true)),
                fetchSearchData(query: trimmedQuery, page: 1)
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
        case .loadNextPageIfNeeded(let index):
            guard !currentState.isLoading,
                  index >= currentState.searchResult.count - 3,
                  !currentState.searchResult.isEmpty,
                  !currentState.currentQuery.isEmpty else {
                return .empty()
            }

            let nextPage = currentState.currentPage + 1
            return .concat([
                .just(.setLoadingIndicator(true)),
                .just(.setPage(nextPage)),
                fetchSearchData(query: currentState.currentQuery, page: nextPage)
                    .map { .appendSearchResult($0) },
                .just(.setLoadingIndicator(false))
            ])
        case .clearAlert:
            return .just(.clearAlertMessage)
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
        case .appendSearchResult(let result):
            newState.searchResult += result
        case .setQuery(let query):
            newState.currentQuery = query
        case .setPage(let page):
            newState.currentPage = page
        case .showAlert(message: let message):
            newState.alertMessage = message
        case .clearAlertMessage:
            newState.alertMessage = nil
        }
        return newState
    }
}

// MARK: - Functions
extension SearchReactor {
    // TODO: 페이지네이션 구현 -> 수정필요
    private func fetchSearchData(query: String, page: Int) -> Observable<[RecipeEntity]> {
        return Observable.create { [weak self] observer in
            Task {
                do {
                    let result = try await self?.repository.search(startIndex: (page - 1) * 10 + 1, count: 20, byIngredient: query) ?? []
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    print("❌ 검색 실패: \(error)")
                    if let networkError = error as? NetworkError {
                        observer.onNext([])
                        print(networkError.localizedDescription)
                    } else {
                        observer.onNext([])
                        print("알 수 없는 오류가 발생했습니다.")
                    }
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
