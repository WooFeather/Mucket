//
//  SelectFolderReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/4/25.
//

import ReactorKit

final class SelectFolderReactor: Reactor {
    private let repository: FolderRepositoryType
    private let selectedCookingId: String?
    var initialState: State

    enum Action {
        case viewWillAppear
        case setSelectedFolder(folderId: String)
        case addFolder(name: String)
    }

    enum Mutation {
        case setFolderList([FolderEntity], selectedFolderId: String?)
    }

    struct State {
        var folderList: [FolderEntity] = []
        var selectedFolderId: String?
    }

    init(repository: FolderRepositoryType, selectedCookingId: String?) {
        self.repository = repository
        self.selectedCookingId = selectedCookingId

        // 초기 상태는 selectedCookingId로 폴더 찾아서 설정
        let folderId: String? = {
            guard let id = selectedCookingId,
                  let cookingObject = repository.getCookingObject(by: id),
                  let folder = cookingObject.folder.first else {
                return repository.getDefaultFolder().id
            }
            return folder.id.stringValue
        }()

        self.initialState = State(
            folderList: repository.fetchAll(),
            selectedFolderId: folderId
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let list = repository.fetchAll()
            return .just(.setFolderList(list, selectedFolderId: currentState.selectedFolderId))
        case .setSelectedFolder(let folderId):
            return .just(.setFolderList(currentState.folderList, selectedFolderId: folderId))
        case .addFolder(name: let name):
            let newFolder = repository.add(name: name)
            let updatedList = repository.fetchAll()
            return .just(.setFolderList(updatedList, selectedFolderId: newFolder.id))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setFolderList(folders, selectedId):
            newState.folderList = folders
            newState.selectedFolderId = selectedId
        }
        return newState
    }
}
