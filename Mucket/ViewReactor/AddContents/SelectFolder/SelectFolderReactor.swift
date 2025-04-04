//
//  SelectFolderReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/4/25.
//

import ReactorKit

final class SelectFolderReactor: Reactor {
    private let repository: FolderRepositoryType
    var initialState: State

    enum Action {
        case viewWillAppear
        case setSelectedFolder(folderId: String)
        case addFolderButtonTapped(name: String)
    }

    enum Mutation {
        case setFolderList([FolderEntity], selectedFolder: FolderEntity)
        case updateSelectedFolderAndList([FolderEntity], FolderEntity)
        case insertNewFolder([FolderEntity])
    }

    struct State {
        var folderList: [FolderEntity] = []
        var selectedFolder: FolderEntity
    }

    init(repository: FolderRepositoryType) {
        self.repository = repository

        let current = repository.getSelectedFolder() ?? repository.getDefaultFolder()
        self.initialState = State(
            folderList: repository.fetchAll(),
            selectedFolder: current
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let folders = repository.fetchAll()
            let selected = repository.getSelectedFolder() ?? repository.getDefaultFolder()
            return .just(.setFolderList(folders, selectedFolder: selected))
        case .setSelectedFolder(let folderId):
            repository.setSelectedFolder(folderId)
            let updated = repository.getSelectedFolder() ?? repository.getDefaultFolder()
            let list = repository.fetchAll()
            return .just(.updateSelectedFolderAndList(list, updated))
        case .addFolderButtonTapped(let name):
            _ = repository.add(name: name)
            let updatedList = repository.fetchAll()
            return .just(.insertNewFolder(updatedList))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setFolderList(let list, let selected):
            newState.folderList = list
            newState.selectedFolder = selected
        case .updateSelectedFolderAndList(let list, let selected):
            newState.folderList = list
            newState.selectedFolder = selected
        case .insertNewFolder(let updated):
            newState.folderList = updated
        }
        return newState
    }
}
