//
//  AddCookingReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import ReactorKit
import Foundation

final class AddCookingReactor: Reactor {
    private let folderRepository: FolderRepositoryType
    private let myCookingRepository: MyCookingRepositoryType

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
        case saveCooking(name: String, memo: String?, rating: Double?, imageURL: String?, youtubeLink: String?)
    }

    enum Mutation {
        case presentImagePicker(Bool)
        case setRoute(Route)
        case setSelectedFolder(FolderEntity)
        case setSaveCompleted(Bool)
    }
    
    struct State {
        var isPresent = false
        var route: Route = .none
        var selectedFolder: FolderEntity?
        var isSaveCompleted = false
    }

    init(
        folderRepository: FolderRepositoryType = FolderRepository(),
        myCookingRepository: MyCookingRepositoryType = MyCookingRepository(),
        editingCookingId: String? = nil  // ⭐ 요리 ID 전달 여부로 분기
    ) {
        self.folderRepository = folderRepository
        self.myCookingRepository = myCookingRepository

        // 편집 중인 요리라면 → 해당 요리가 속한 폴더를 조회
        if let cookingId = editingCookingId,
           let cookingObject = myCookingRepository.fetchById(cookingId),
           let folderObject = cookingObject.folder.first {
            let selected = folderObject.toEntity()
            self.initialState = State(selectedFolder: selected)
        } else {
            // 새 요리 생성 → 기본 폴더 선택
            let defaultFolder = folderRepository.getDefaultFolder()
            self.initialState = State(selectedFolder: defaultFolder)
        }
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
        case .saveCooking(name: let name, memo: let memo, rating: let rating, imageURL: let imageURL, youtubeLink: let youtubeLink):
            let entity = MyCookingEntity(
                id: "",
                name: name,
                youtubeLink: youtubeLink,
                imageFileURL: imageURL,
                memo: memo,
                rating: rating,
                createdAt: Date(),
                folderId: currentState.selectedFolder?.id
            )
            myCookingRepository.add(entity, toFolderId: currentState.selectedFolder?.id)
            return .just(.setSaveCompleted(true))
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
        case .setSaveCompleted(let value):
            newState.isSaveCompleted = value
        }
        return newState
    }
}
