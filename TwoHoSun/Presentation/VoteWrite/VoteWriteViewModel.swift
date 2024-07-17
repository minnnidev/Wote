//
//  WriteViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/22/23.
//

import Combine
import SwiftUI
import PhotosUI

final class VoteWriteViewModel: ObservableObject {

    enum Action {
        case loadTransferable(_ item: PhotosPickerItem?)
        case presentPhotoPicker
        case removeImage
        case createVote
    }
    
    @Published var title: String = ""
    @Published var price: String = ""
    @Published var externalURL: String = ""
    @Published var content: String = ""
    @Published var selectedItem: PhotosPickerItem? = nil {
        didSet {
            send(action: .loadTransferable(selectedItem))
        }
    }
    @Published var selectedData: Data?
    @Published var isImageSheetShowed: Bool = false
    @Published var isPhotoPickerShowed: Bool = false

    @Published var placeholderText = "욕설,비방,광고 등 소비 고민과 관련없는 내용은 통보 없이 삭제될 수 있습니다."

    @Published var postCreateModel: PostCreateModel?

    private var cancellables = Set<AnyCancellable>()

    private let photoUseCase: PhotoUseCaseType

    init(photoUseCase: PhotoUseCaseType) {
        self.photoUseCase = photoUseCase
    }

    var isTitleValid: Bool {
        guard !title.isEmpty else { return false }
        return true
    }

    func send(action: Action) {
        switch action {
        case let .loadTransferable(item):
            photoUseCase.loadTransferable(item)
                .sink { _ in
                } receiveValue: { [weak self] data in
                    self?.selectedData = data
                }
                .store(in: &cancellables)

        case .presentPhotoPicker:
            isPhotoPickerShowed.toggle()

        case .removeImage:
            selectedItem = nil
            selectedData = nil

        case .createVote:
            // TODO: - 투표 등록
            return
        }
    }
}
