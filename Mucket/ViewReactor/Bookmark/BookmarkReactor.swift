//
//  BookmarkReactor.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import ReactorKit

final class BookmarkReactor: Reactor {
    
    var initialState: State = State()
    
    private let repository: BookmarkedRecipeRepositoryType
    
    enum Route: Equatable {
        case none
        case detail(recipe: RecipeEntity)
    }
    
    init(repository: BookmarkedRecipeRepositoryType) {
        self.repository = repository
    }
    
    enum Action {
        case viewWillAppear
        case searchButtonTapped(query: String)
        case recipeCellTapped(RecipeEntity)
        case clearRouting
    }
    
    enum Mutation {
        case setRoute(Route)
        case setKeyboardHidden(Bool)
        case setBookmarkedRecipes([RecipeEntity])
    }
    
    struct State {
        var route: Route = .none
        var isKeyboardHidden = false
        var bookmarkRecipes: [RecipeEntity] = []
    }
}

extension BookmarkReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let recipes = repository.fetchAll()
            return .just(.setBookmarkedRecipes(recipes))
        case .searchButtonTapped(let query):
            let all = repository.fetchAll()
            let trimmed = query.trimmingCharacters(in: .whitespaces)
            let filtered = trimmed == "" ? all : all.filter { $0.name.contains(trimmed) }
            return .concat([
                .just(.setBookmarkedRecipes(filtered)),
                .just(.setKeyboardHidden(true))
            ])
        case .recipeCellTapped(let recipe):
            return .just(.setRoute(.detail(recipe: recipe)))
        case .clearRouting:
            return .just(.setRoute(.none))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRoute(let route):
            newState.route = route
        case .setKeyboardHidden(let isHidden):
            newState.isKeyboardHidden = isHidden
        case .setBookmarkedRecipes(let recipes):
            newState.bookmarkRecipes = recipes
        }
        
        return newState
    }
}
