//
//  SelectFolderReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/4/25.
//

import ReactorKit

final class SelectFolderReactor: Reactor {
    private let repository: CookingFolderRepositoryType
    private let selectedCookingId: String?
    var initialState: State

    enum Action {
        case viewWillAppear
        case setSelectedFolder(folderId: String)
        case addFolder(name: String)
        case deleteFolder(id: String)
    }

    enum Mutation {
        case setFolderList([CookingFolderEntity], selectedFolderId: String?)
        case updateFolderList
    }

    struct State {
        var folderList: [CookingFolderEntity] = []
        var selectedFolderId: String?
    }

    init(repository: CookingFolderRepositoryType, selectedCookingId: String?) {
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
        case .deleteFolder(let id):
            repository.delete(id: id)
            return .just(.updateFolderList)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setFolderList(folders, selectedId):
            newState.folderList = folders
            newState.selectedFolderId = selectedId
        case .updateFolderList:
            let updated = repository.fetchAll()
            newState.folderList = updated
            
            // 현재 선택한 폴더가 삭제되었을 수도 있으므로 재설정
            if let selectedId = state.selectedFolderId,
               !updated.contains(where: { $0.id == selectedId }) {
                newState.selectedFolderId = repository.getDefaultFolder().id
            }
        }
        return newState
    }
}
