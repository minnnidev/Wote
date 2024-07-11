//
//  SchoolSearchViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/17/23.
//

import Foundation
import Combine

import Alamofire

final class SchoolSearchViewModel: ObservableObject {

    enum Action {
        case submit(_ searchSchoolText: String)
    }

    @Published var schools: [SchoolInfoModel] = [SchoolInfoModel]()
    @Published var isLoading: Bool = false
    @Published var searchSchoolText: String = ""
    @Published var textFieldState: SearchTextFieldState = .inactive

    private let userUseCase: UserUseCaseType

    private var cancellables = Set<AnyCancellable>()

    init(userUseCase: UserUseCaseType) {
        self.userUseCase = userUseCase
    }

    func send(action: Action) {
        switch action {
        case let .submit(searchSchoolText):
            isLoading = true

            userUseCase.searchSchool(searchSchoolText)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] schools in
                    self?.textFieldState = .submitted
                    self?.isLoading = false

                    self?.schools = schools
                }
                .store(in: &cancellables)
        }
    }
}
