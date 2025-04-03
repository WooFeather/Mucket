//
//  SelectFolderReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/4/25.
//

import ReactorKit

final class SelectFolderReactor: Reactor {
    
    var initialState: State = State()
    
    private let repository: FolderRepositoryType
    
    init(repository: FolderRepositoryType) {
        self.repository = repository
    }
    
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case setFolderList([FolderEntity])
    }
    
    struct State {
        var folderList: [FolderEntity] = []
    }
}

extension SelectFolderReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let folders = repository.fetchAll()
            return .just(.setFolderList(folders))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setFolderList(let folders):
            newState.folderList = folders
        }
        
        return newState
    }
}
