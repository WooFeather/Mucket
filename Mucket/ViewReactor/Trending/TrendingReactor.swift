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
    enum Route: Equatable {
        case none
        case searchView
        case detail(recipe: RecipeEntity)
    }
    
    enum Action {
        case loadAll(type: String)
        case loadTheme(type: String)
        case searchViewTapped
        case clearRouting
        case recipeCellTapped(recipe: RecipeEntity)
    }
    
    enum Mutation {
        case setRoute(Route)
        case setRecommendedList([RecipeEntity])
        case setThemeList([RecipeEntity])
        case setLoadingRecommended(Bool)
        case setLoadingTheme(Bool)
    }
    
    struct State {
        var route: Route = .none
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
            return .just(.setRoute(.searchView))
        case .recipeCellTapped(let recipe):
            return .just(.setRoute(.detail(recipe: recipe)))
        case .clearRouting:
            return .just(.setRoute(.none))
        case .loadAll(let type):
            return .concat([
                .just(.setLoadingRecommended(true)),
                .just(.setLoadingTheme(true)),

                fetchRecommendedList()
                    .map { .setRecommendedList($0) },

                fetchThemeList(type: type)
                    .map { .setThemeList($0) },

                .just(.setLoadingRecommended(false)),
                .just(.setLoadingTheme(false)),
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
        case .setRoute(let route):
            newState.route = route
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
                    print("추천리스트 로딩 실패", error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        .retry(1)
    }

    private func fetchThemeList(type: String) -> Observable<[RecipeEntity]> {
        return Observable.create { [weak self] observer in
            Task {
                do {
//                    let theme = try await self?.repository.fetchTheme(type: type) ?? []
                    
                    // TODO: theme 요청하는 파라미터 문제 있어서 일단 이렇게 수정 -> 추후 답변 오면 원래 코드 쓸 예정
                    let all = try await self?.repository.fetchAll() ?? []
                    let theme = all.filter { $0.type?.contains(type) ?? true }
                    
                    observer.onNext(Array(theme.shuffled().prefix(10)))
                    observer.onCompleted()
                } catch {
                    print("테마리스트 로딩 실패", error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        .retry(1)
    }
}
