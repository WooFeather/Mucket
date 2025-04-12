//
//  AddRestaurantReactor.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import ReactorKit

final class AddPlaceReactor: Reactor {
    private let folderRepository: PlaceFolderRepositoryType
    private let myPlaceRepository: MyPlaceRepositoryType
    
    var initialState: State = State()
    
    init(
        folderRepository: PlaceFolderRepositoryType = PlaceFolderRepository(),
        myPlaceRepository: MyPlaceRepositoryType = MyPlaceRepository(),
        editingPlaceId: String? = nil  // 맛집 ID 전달 여부로 분기
    ) {
        self.folderRepository = folderRepository
        self.myPlaceRepository = myPlaceRepository

        // 편집 중인 맛집이라면 → 해당 요리가 속한 폴더를 조회
        if let placeId = editingPlaceId,
           let placeObject = myPlaceRepository.fetchById(placeId),
           let folderObject = placeObject.folder.first {
            print("맛집 편집", placeId, placeObject, folderObject)
            let selected = folderObject.toEntity()
            self.initialState = State(
                selectedFolder: selected,
                nameContents: placeObject.name,
                imageURLContents: placeObject.imageFileURL,
                ratingContents: placeObject.rating,
                memoContents: placeObject.memo,
                addressContents: placeObject.address,
                latitude: placeObject.latitude,
                longitude: placeObject.longitude
            )
        } else {
            // 새 맛집 생성 → 기본 폴더 선택
            print("새 맛집")
            let defaultFolder = folderRepository.getDefaultFolder()
            self.initialState = State(selectedFolder: defaultFolder)
        }
    }
    
    enum Route: Equatable {
        case none
        case searchAddress
        case folder
    }
    
    enum Action {
        case addPhotoButtonTapped
        case folderPlaceButtonTapped
        case searchAddressButtonTapped
        case clearRouting
        case setSelectedFolder(PlaceFolderEntity)
        case savePlace(name: String, memo: String?, rating: Double?, imageURL: String?, address: String?, latitude: Double?, longitude: Double?)
        case setAddressInfo(address: String, latitude: Double?, longitude: Double?)
    }
    
    enum Mutation {
        case setRoute(Route)
        case presentImagePicker(Bool)
        case setSelectedFolder(PlaceFolderEntity)
        case setSaveCompleted(Bool)
        case setAddress(address: String, latitude: Double?, longitude: Double?)
    }
    
    struct State {
        var isPresent = false
        var route: Route = .none
        var selectedFolder: PlaceFolderEntity?
        var isSaveCompleted = false
        var nameContents: String?
        var imageURLContents: String?
        var ratingContents: Double?
        var memoContents: String?
        var addressContents: String?
        var latitude: Double?
        var longitude: Double?
    }
}

extension AddPlaceReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addPhotoButtonTapped:
            return Observable.concat([
                .just(.presentImagePicker(true)),
                .just(.presentImagePicker(false)).delay(.milliseconds(100), scheduler: MainScheduler.instance)
            ])
        case .searchAddressButtonTapped:
            return .just(.setRoute(.searchAddress))
        case .clearRouting:
            return .just(.setRoute(.none))
        case .setSelectedFolder(let folder):
            return .just(.setSelectedFolder(folder))
        case .savePlace(name: let name, memo: let memo, rating: let rating, imageURL: let imageURL, address: let address, latitude: _, longitude: _):
            let entity = MyPlaceEntity(
                id: "",
                name: name,
                latitude: currentState.latitude,
                longitude: currentState.longitude,
                address: address,
                imageFileURL: imageURL,
                memo: memo,
                rating: rating,
                createdAt: Date(),
                folderId: currentState.selectedFolder?.id
            )
            myPlaceRepository.add(entity, toFolderId: currentState.selectedFolder?.id)
            return .just(.setSaveCompleted(true))
        case .folderPlaceButtonTapped:
            return .just(.setRoute(.folder))
        case let .setAddressInfo(address, lat, lng):
            return .just(.setAddress(address: address, latitude: lat, longitude: lng))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .presentImagePicker(let isPresent):
            newState.isPresent = isPresent
        case .setRoute(let route):
            newState.route = route
        case .setSelectedFolder(let folder):
            newState.selectedFolder = folder
        case .setSaveCompleted(let value):
            newState.isSaveCompleted = value
        case let .setAddress(address, lat, lng):
            newState.addressContents = address
            newState.latitude = lat
            newState.longitude = lng
        }
        return newState
    }
}
