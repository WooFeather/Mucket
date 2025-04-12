//
//  SearchAddressReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/10/25.
//

import ReactorKit

final class SearchAddressReactor: Reactor {
    
    var initialState: State = State()
    
    private let repository: SearchPlaceRepositoryType = SearchPlaceRepository.shared
    private let mockRepository: SearchPlaceRepositoryType = MockPlaceRepository()
    
    enum Action {
        case closeButtonTapped
        case searchButtonTapped(query: String)
        case searchCellTapped(place: PlaceDetail)
        case loadNextPage
        case clearAlert
    }
    
    enum Mutation {
        case popToPrevView
        case setSearchResult([PlaceDetail])
        case appendSearchResult([PlaceDetail])
        case setSearchTableViewHidden(Bool)
        case setEmptyStateHidden(Bool)
        case setLoadingIndicator(Bool)
        case setQuery(String)
        case setPage(Int)
        case setIsEnd(Bool)
        case showAlert(message: String)
        case clearAlertMessage
    }
    
    struct State {
        var shouldPopToPrevView = false
        var isSearchTableViewHidden = true
        var isEmptyStateHidden = true
        var searchResult: [PlaceDetail] = []
        var isLoading = false
        var currentQuery: String = ""
        var currentPage: Int = 1
        var isEnd: Bool = false
        var alertMessage: String? = nil
    }
}

extension SearchAddressReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .closeButtonTapped:
            return .just(.popToPrevView)
        case .searchButtonTapped(let query):
            let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedQuery.isEmpty else {
                return .just(.showAlert(message: "검색어를 입력해주세요."))
            }
            
            return .concat([
                .just(.setQuery(trimmedQuery)),
                .just(.setPage(1)),
                .just(.setIsEnd(false)),
                .just(.setLoadingIndicator(true)),
                fetchSearchEntity(query: trimmedQuery, page: 1)
                    .flatMap { entity in
                        Observable.from([
                            .setSearchResult(entity.details),
                            .setEmptyStateHidden(!entity.details.isEmpty),
                            .setSearchTableViewHidden(entity.details.isEmpty),
                            .setIsEnd(entity.info.isEnd)
                        ])
                    },
                .just(.setLoadingIndicator(false))
            ])
        case .searchCellTapped(_):
            return .just(.popToPrevView)
        case .loadNextPage:
            guard !currentState.isEnd else {
                return .empty()
            }
            
            let nextPage = currentState.currentPage + 1
            return .concat([
                .just(.setLoadingIndicator(true)),
                fetchSearchEntity(query: currentState.currentQuery, page: nextPage)
                    .flatMap { entity in
                        Observable.from([
                            .appendSearchResult(entity.details),
                            .setEmptyStateHidden(!entity.details.isEmpty),
                            .setSearchTableViewHidden(entity.details.isEmpty),
                            .setIsEnd(entity.info.isEnd),
                            .setPage(nextPage)
                        ])
                    },
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
        case .appendSearchResult(let result):
            newState.searchResult += result
        case .setSearchTableViewHidden(let hidden):
            newState.isSearchTableViewHidden = hidden
        case .setEmptyStateHidden(let hidden):
            newState.isEmptyStateHidden = hidden
        case .setLoadingIndicator(let isLoading):
            newState.isLoading = isLoading
        case .setQuery(let query):
            newState.currentQuery = query
        case .setPage(let page):
            newState.currentPage = page
        case .showAlert(message: let message):
            newState.alertMessage = message
        case .clearAlertMessage:
            newState.alertMessage = nil
        case .setIsEnd(let isEnd):
            newState.isEnd = isEnd
        }
        return newState
    }
}

extension SearchAddressReactor {
    private func fetchSearchEntity(query: String, page: Int) -> Observable<PlaceEntity> {
        return Observable.create { [weak self] observer in
            Task {
                do {
                    guard let entity = try await self?.repository.search(query: query, page: page)
                    else {
                        observer.onNext(PlaceEntity(details: [], info: SearchInfo(isEnd: true)))
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(entity)
                    observer.onCompleted()
                } catch {
                    print("❌ 검색 실패: \(error)")
                    observer.onNext(PlaceEntity(details: [], info: SearchInfo(isEnd: true)))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
