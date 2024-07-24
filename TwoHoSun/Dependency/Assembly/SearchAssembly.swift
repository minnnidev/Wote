//
//  SearchAssembly.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Swinject
import Moya

final class SearchAssembly: Assembly {

    func assemble(container: Container) {

        // MARK: ViewModels

        container.register(SearchViewModel.self) { res in
            SearchViewModel(searchUseCase: res.resolve(SearchUseCaseType.self)!)
        }

        // MARK: UseCases

        container.register(SearchUseCaseType.self) { res in
            SearchUseCase(searchRepository: res.resolve(SearchRepositoryType.self)!)
        }

        // MARK: Repositories

        container.register(SearchRepositoryType.self) { res in
            SearchRepository(searchDataSource: res.resolve(SearchDataSourceType.self)!)
        }

        // MARK: DataSource

        container.register(SearchDataSourceType.self) { res in
            SearchDataSource(provider: NetworkProvider.shared)
        }
    }
}
