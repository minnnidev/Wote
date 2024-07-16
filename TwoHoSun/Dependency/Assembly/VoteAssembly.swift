//
//  VoteAssembly.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation
import Swinject

final class VoteAssembly: Assembly {
    
    func assemble(container: Container) {

        container.register(VoteListViewModel.self) { res in
            VoteListViewModel(voteUseCase: res.resolve(VoteUseCaseType.self)!)
        }

        container.register(VoteUseCaseType.self) { res in
            VoteUseCase(repository: res.resolve(VoteRepositoryType.self)!)
        }

        container.register(VoteRepositoryType.self) { res in
            VoteRepository(dataSource: res.resolve(VoteDataSourceType.self)!)
        }

        container.register(VoteDataSourceType.self) { _ in VoteDataSource() }
    }
}
