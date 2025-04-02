//
//  TrendingReactor.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import ReactorKit

final class TrendingReactor: Reactor {
    
    var initialState: State = State()
    
    private let repository: RecipeRepositoryType = RecipeRepository.shared
    
    /// 화면 이동을 위한 열거형
    enum Route {
        case none
        case searchView
    }
    
    enum Action {
        case loadRecommended
        case loadTheme(type: String)
        case searchViewTapped
        case clearRouting
    }
    
    enum Mutation {
        case pushToSearchView
        case clearRoutingFlag
        case setRecommendedList([RecipeEntity])
        case setThemeList([RecipeEntity])
        case setLoadingRecommended(Bool)
        case setLoadingTheme(Bool)
    }
    
    struct State {
        var shouldRouteToSearchView: Route = .none
        var recommendedList: [RecipeEntity] = []
        var themeList: [RecipeEntity] = []
        var isLoadingRecommended = false
        var isLoadingTheme = false
    }
}

extension TrendingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchViewTapped:
                return .just(.pushToSearchView)
        case .clearRouting:
                return .just(.clearRoutingFlag)
        case .loadRecommended:
            return .concat([
                .just(.setLoadingRecommended(true)),
                fetchRecommendedList().map { .setRecommendedList($0) },
                .just(.setLoadingRecommended(false))
                    
            ])
        case .loadTheme(let type):
            return .concat([
                .just(.setLoadingTheme(true)),
                fetchThemeList(type: type).map { .setThemeList($0) },
                .just(.setLoadingTheme(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .pushToSearchView:
            newState.shouldRouteToSearchView = .searchView
        case .clearRoutingFlag:
            newState.shouldRouteToSearchView = .none
        case .setRecommendedList(let list):
            newState.recommendedList = list
        case .setThemeList(let list):
            newState.themeList = list
        case .setLoadingRecommended(let isLoading):
            newState.isLoadingRecommended = isLoading
        case .setLoadingTheme(let isLoading):
            newState.isLoadingTheme = isLoading
        }
        
        return newState
    }
}

// MARK: - Functions
extension TrendingReactor {
    private func fetchRecommendedList() -> Observable<[RecipeEntity]> {
        return Observable.create { [weak self] observer in
            Task {
                do {
                    let all = try await self?.repository.fetchAll() ?? []
                    observer.onNext(Array(all.shuffled().prefix(10)))
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    private func fetchThemeList(type: String) -> Observable<[RecipeEntity]> {
        return Observable.create { [weak self] observer in
            Task {
                do {
                    let theme = try await self?.repository.fetchTheme(type: type) ?? []
                    observer.onNext(Array(theme.shuffled().prefix(10)))
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
