//
//  ReviewWriteViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/7/23.
//

import Combine
import SwiftUI
import PhotosUI

final class ReviewWriteViewModel: ObservableObject {

    enum Action {
        case loadTransferable(_ item: PhotosPickerItem?)
        case presentPhotoPicker
        case removeImage
        case selectReviewType(isPurchased: Bool)
        case registerReview
    }

    /// 이미지
    @Published var selectedData: Data?
    @Published var isImageSheetShowed: Bool = false
    @Published var isPhotoPickerShowed: Bool = false
    @Published var selectedItem: PhotosPickerItem? = nil {
        didSet {
            send(action: .loadTransferable(selectedItem))
        }
    }

    /// 리뷰
    @Published var isPurchased: Bool = true
    @Published var title: String = ""
    @Published var price: String = ""
    @Published var content: String = ""
    @Published var placeholderText = "욕설,비방,광고 등 소비 고민과 관련없는 내용은 통보 없이 삭제될 수 있습니다."

    @Published var isCreatingReview = false
    @Published var review: ReviewCreateModel?

    private let voteId: Int
    private let reviewUseCase: ReviewUseCaseType
    private let photoUseCase: PhotoUseCaseType

    init(
        voteId: Int,
        reviewUseCase: ReviewUseCaseType,
        photoUseCase: PhotoUseCaseType
    ) {
        self.voteId = voteId
        self.reviewUseCase = reviewUseCase
        self.photoUseCase = photoUseCase
    }

    private var cancellables: Set<AnyCancellable> = []

    var isValid: Bool {
        if isPurchased {
            if !title.isEmpty && selectedData != nil {
                return true
            } else {
                return false
            }
        } else {
            if !title.isEmpty {
                return true
            } else {
                return false
            }
        }
    }

    func send(action: Action) {
        switch action {
        case let .selectReviewType(isPurchased):
            self.isPurchased = isPurchased

        case .registerReview:
             // TODO: API 연결
            return

        case let .loadTransferable(item):
            photoUseCase.loadTransferable(item)
                .receive(on: DispatchQueue.main)
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
        }
    }
}
