//
//  TypeTestViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/9/23.
//
import Combine
import SwiftUI

final class TypeTestViewModel: ObservableObject {

    enum Action {
        case setConsumerType
        case registerConsumerType
    }

    @Published var testChoices: [Int] = [-1, -1, -1, -1, -1, -1, -1]
    @Published var typeScores: [ConsumerType: Int] = .init()
    @Published var testProgressValue: Double = 1.0
    @Published var isPutDataSucceed: Bool = false 
    @Published var userType: ConsumerType?

    private var cancellables: Set<AnyCancellable> = []

    private let userUseCase: UserUseCaseType

    init(userUseCase: UserUseCaseType) {
        self.userUseCase = userUseCase
    }

    var questionNumber: Int {
        Int(testProgressValue)
    }

    var isLastQuestion: Bool {
        questionNumber >= 7 ? true : false
    }

    func moveToPreviousQuestion() {
        testProgressValue -= 1.0
    }

    func moveToNextQuestion() {
        testProgressValue += 1.0
    }

    func setChoice(order: Int, types: [ConsumerType]) {
        testChoices[questionNumber - 1] = order

        for type in types {
            typeScores[type, default: 0] += 1
        }
    }

    func send(action: Action) {
        switch action {
        case .setConsumerType:
            let maxScore = typeScores.values.max()!
            let maxScoreTypes = typeScores.filter { $0.value == maxScore }.map { $0.key }
            userType = maxScoreTypes.randomElement()!

        case .registerConsumerType:
            guard let consumerType = userType else { return }

            userUseCase.registerConsumerType(consumerType)
                .sink { _ in
                } receiveValue: { [weak self] _ in
                    self?.isPutDataSucceed.toggle()
                }
                .store(in: &cancellables)
        }
    }
}
