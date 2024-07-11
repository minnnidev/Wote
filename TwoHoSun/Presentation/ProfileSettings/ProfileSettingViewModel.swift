//
//  ProfileSettingViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/17/23.
//

import Combine
import Observation
import SwiftUI

import Alamofire
import Moya

final class ProfileSettingViewModel: ObservableObject {

    enum Action {
        case selectImage
        case checkDuplicatedNickname(_ nickname: String)
        case selectSchool
    }

    @Published var nickname = ""
    @Published var selectedSchoolInfo: SchoolInfoModel?
    @Published var selectedGrade: String?
    @Published var nicknameValidationType = NicknameValidationType.none
    @Published var selectedImageData: Data?
    @Published var isNicknameDuplicated = false
    @Published var isFormValid = true
    @Published var model: ProfileSetting?
    @Published var isProfileSheetShowed: Bool = false

    private let forbiddenWord = ["금지어1", "금지어2"]
    private var cancellables = Set<AnyCancellable>()

    var firstNickname = ""
    var firstSchool: SchoolInfoModel?

    private let userUseCase: UserUseCaseType

    init(userUseCase: UserUseCaseType) {
        self.userUseCase = userUseCase
    }

    var isSchoolFilled: Bool {
        return selectedSchoolInfo != nil
    }
    var isAllInputValid: Bool {
        return (nicknameValidationType == .valid
        && isSchoolFilled)
        || (selectedImageData != nil && nickname == firstNickname && selectedSchoolInfo?.school.schoolName == firstSchool?.school.schoolName)
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
    
    func checkSchoolRegisterDate(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: date) {
            if let datePlusSixMonths = Calendar.current.date(byAdding: .month, value: 6, to: date) {
                if Date() > datePlusSixMonths {
                    return false
                } else {
                    return true
                }
            }
        }
        return false
    }
    
    func setProfile(_ isRestricted: Bool, _ isRegsiter: Bool) {
        guard let school = selectedSchoolInfo?.school else { return }
        if isRestricted {
            model = ProfileSetting(imageFile: selectedImageData ?? Data(),
                                   nickname: nickname,
                                   school: nil)
        } else {
            model = ProfileSetting(imageFile: selectedImageData ?? Data(),
                                   nickname: nickname,
                                   school: school)
        }
    }
    
    func postNickname() {
        // TODO: - 닉네임 중복 체크 API
    }

    func send(_ action: Action) {
        switch action {
        case .selectImage:
            // TODO: - 이미지 선택 로직
            return

        case .checkDuplicatedNickname:
            userUseCase.checkNicknameDuplicated(nickname)
                .sink { _ in
                } receiveValue: { [weak self] isExist in
                    if isExist {
                        self?.nicknameValidationType = .duplicated
                    } else {
                        self?.nicknameValidationType = .valid
                    }
                }
                .store(in: &cancellables)

        case .selectSchool:
            // TODO: - 학교 선택 로직
            return
        }
    }
}
