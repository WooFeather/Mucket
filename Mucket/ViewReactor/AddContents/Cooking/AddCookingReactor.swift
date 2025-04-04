//
//  AddCookingReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import ReactorKit

final class AddCookingReactor: Reactor {
    private let folderRepository: FolderRepositoryType

    var initialState: State

    enum Route: Equatable {
        case none
        case folder
    }

    enum Action {
        case addPhotoButtonTapped
        case folderSelectButtonTapped
        case clearRouting
        case setSelectedFolder(FolderEntity)
    }

    enum Mutation {
        case presentImagePicker(Bool)
        case setRoute(Route)
        case setSelectedFolder(FolderEntity)
    }

    struct State {
        var isPresent = false
        var route: Route = .none
        var selectedFolder: FolderEntity?
    }

    init(folderRepository: FolderRepositoryType = FolderRepository()) {
        self.folderRepository = folderRepository

        let defaultSelected = folderRepository.getSelectedFolder() ?? folderRepository.getDefaultFolder()
        self.initialState = State(selectedFolder: defaultSelected)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addPhotoButtonTapped:
            return Observable.concat([
                .just(.presentImagePicker(true)),
                .just(.presentImagePicker(false)).delay(.milliseconds(100), scheduler: MainScheduler.instance)
            ])
        case .folderSelectButtonTapped:
            return .just(.setRoute(.folder))
        case .clearRouting:
            return .just(.setRoute(.none))
        case .setSelectedFolder(let folder):
            return .just(.setSelectedFolder(folder))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .presentImagePicker(let present):
            newState.isPresent = present
        case .setRoute(let route):
            newState.route = route
        case .setSelectedFolder(let folder):
            newState.selectedFolder = folder
        }
        return newState
    }
}
