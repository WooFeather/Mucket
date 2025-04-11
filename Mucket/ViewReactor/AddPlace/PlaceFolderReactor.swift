//
//  PlaceFolderReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/11/25.
//

import Foundation
import ReactorKit

final class PlaceFolderReactor: Reactor {
    private let repository: PlaceFolderRepositoryType
    private let selectedPlaceId: String?
    var initialState: State

    enum Action {
        case viewWillAppear
        case setSelectedFolder(folderId: String)
        case addFolder(name: String)
        case deleteFolder(id: String)
    }

    enum Mutation {
        case setFolderList([PlaceFolderEntity], selectedFolderId: String?)
        case updateFolderList
    }

    struct State {
        var folderList: [PlaceFolderEntity] = []
        var selectedFolderId: String?
    }

    init(repository: PlaceFolderRepositoryType, selectedPlaceId: String?) {
        self.repository = repository
        self.selectedPlaceId = selectedPlaceId

        // 초기 상태는 selectedCookingId로 폴더 찾아서 설정
        let folderId: String? = {
            guard let id = selectedPlaceId,
                  let placeObject = repository.getPlaceObject(by: id),
                  let folder = placeObject.folder.first else {
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
