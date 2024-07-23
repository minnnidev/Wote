//
//  SearchUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

protocol SearchUseCaseType {

}

final class SearchUseCase: SearchUseCaseType {

    private let searchRepository: SearchRepositoryType

    init(searchRepository: SearchRepositoryType) {
        self.searchRepository = searchRepository
    }
}

final class StubSearchUseCase: SearchUseCaseType {

}
