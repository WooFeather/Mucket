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
        case loadNextPage(page: Int)
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
                .just(.setLoadingIndicator(true)),
                fetchSearchData(query: trimmedQuery, page: 1)
                    .flatMap{ result in
                        Observable.from([
                            .setSearchResult(result),
                            .setEmptyStateHidden(result.isEmpty == false),
                            .setSearchTableViewHidden(result.isEmpty)
                        ])
                    },
                .just(.setLoadingIndicator(false))
            ])
        case .searchCellTapped(_):
            return .just(.popToPrevView) // TODO: 해당 cell의 roadAddressName넘기기
        case .loadNextPage(_):
            return .empty() // TODO: 페이지네이션 구현
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
        }
        return newState
    }
}

// TODO: 페이지네이션 구현
extension SearchAddressReactor {
    private func fetchSearchData(query: String, page: Int) -> Observable<[PlaceDetail]> {
        return Observable.create { [weak self] observer in
            Task {
                do {
                    let result = try await self?.repository.search(query: query, page: page).details ?? []
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
