//
//  ProfileModifyViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Combine
import SwiftUI
import PhotosUI

final class ProfileModifyViewModel: ObservableObject {

    enum Action {
        case loadProfile
        case loadTransferable(_ item: PhotosPickerItem?)
        case presentProfileModifySheet
        case checkDuplicatedNickname(_ nickname: String)
        case modifyProfile
        case initImages
        case presentPhotoPicker
    }

    /// 유효성
    @Published var nickname = ""
    @Published var selectedSchoolInfo: SchoolInfoModel?
    @Published var nicknameValidationType = NicknameValidationType.none
    @Published var isNicknameDuplicated = false
    @Published var isFormValid = true

    /// 이미지
    @Published var selectedImage: PhotosPickerItem? = nil {
        didSet {
            send(.loadTransferable(selectedImage))
        }
    }
    @Published var selectedImageData: Data?
    @Published var isProfileSheetShowed: Bool = false
    @Published var isPhotoPickerShowed: Bool = false

    /// 로딩
    @Published var isLoading: Bool = false

    /// 프로필 세팅
    @Published var myProfile: ProfileModel?
    @Published var isUpdateConsumerTypePossible: Bool = false
    @Published var isModifyCompleted: Bool = false

    private let forbiddenWord = ["금지어1", "금지어2"]
    private var cancellables = Set<AnyCancellable>()

    var firstNickname = ""
    var firstSchool: SchoolInfoModel?

    private let userUseCase: UserUseCaseType
    private let photoUseCase: PhotoUseCaseType

    init(userUseCase: UserUseCaseType, photoUseCase: PhotoUseCaseType) {
        self.userUseCase = userUseCase
        self.photoUseCase = photoUseCase
    }

    var isSchoolFilled: Bool {
        return selectedSchoolInfo != nil
    }
    var isAllInputValid: Bool {
        return nicknameValidationType == .valid && isSchoolFilled
    }

    private func isNicknameLengthValid(_ text: String) -> Bool {
        let pattern = #"^.{1,10}$"#
        if let range = text.range(of: pattern, options: .regularExpression) {
            return text.distance(from: range.lowerBound, to: range.upperBound) == text.count
        }
        return false
    }

    private func isNicknameIncludeForbiddenWord(_ text: String) -> Bool {
        for word in forbiddenWord where text.contains(word) {
            return true
        }
        return false
    }

    func checkNicknameValidation(_ text: String) {
        isNicknameDuplicated = false
        if !isNicknameLengthValid(text) {
            nicknameValidationType = .length
        } else if isNicknameIncludeForbiddenWord(text) {
            nicknameValidationType = .forbiddenWord
        } else {
            nicknameValidationType = .none
        }
    }

    func isDuplicateButtonEnabled() -> Bool {
        return isNicknameLengthValid(nickname) && !isNicknameIncludeForbiddenWord(nickname)
    }

    func setInvalidCondition() {
        if nickname.isEmpty { nicknameValidationType = .empty }
        isFormValid = false
    }

    func send(_ action: Action) {
        switch action {
        case .loadProfile:
            isLoading = true

            userUseCase.loadProfile()
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] profile in
                    self?.myProfile = profile
                    self?.nickname = profile.nickname
                    self?.selectedSchoolInfo = .init(school: profile.school, schoolAddress: nil)
                    self?.isUpdateConsumerTypePossible = profile.canUpdateConsumerType
                    self?.isLoading = false
                }
                .store(in: &cancellables)

            return

        case let .loadTransferable(item):
            photoUseCase.loadTransferable(item)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                } receiveValue: { [weak self] data in
                    self?.selectedImageData = data
                }
                .store(in: &cancellables)

        case .presentProfileModifySheet:
            isProfileSheetShowed.toggle()

        case .checkDuplicatedNickname:
            userUseCase.checkNicknameDuplicated(nickname)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                } receiveValue: { [weak self] isExist in
                    if isExist {
                        self?.nicknameValidationType = .duplicated
                    } else {
                        self?.nicknameValidationType = .valid
                    }
                }
                .store(in: &cancellables)

        case .modifyProfile:
            isLoading = true

            guard let school = selectedSchoolInfo?.school else { return }

            let profile: ProfileSettingModel = .init(
                imageFile: selectedImageData ?? nil,
                nickname: nickname,
                school: school)

            userUseCase.setProfile(profile)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] _  in
                    self?.isLoading = false
                    self?.isModifyCompleted.toggle()
                }
                .store(in: &cancellables)

        case .initImages:
            selectedImage = nil
            selectedImageData = nil

        case .presentPhotoPicker:
            isPhotoPickerShowed.toggle()
        }
    }
}
