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

        // MARK: ViewModels
        container.register(VoteListViewModel.self) { res in
            VoteListViewModel(voteUseCase: res.resolve(VoteUseCaseType.self)!)
        }

        container.register(DetailViewModel.self) { res, postId in
            DetailViewModel(postId:postId, voteUseCase: res.resolve(VoteUseCaseType.self)!)
        }

        container.register(VoteWriteViewModel.self) { res in
            VoteWriteViewModel(
                photoUseCase: res.resolve(PhotoUseCaseType.self)!,
                voteUseCase: res.resolve(VoteUseCaseType.self)!
            )
        }

        // MARK: UseCases

        container.register(VoteUseCaseType.self) { res in
            VoteUseCase(voteRepository: res.resolve(VoteRepositoryType.self)!)
        }

        // MARK: Repositories

        container.register(VoteRepositoryType.self) { res in
            VoteRepository(voteDataSource: res.resolve(VoteDataSourceType.self)!)
        }

        // MARK: DataSource

        container.register(VoteDataSourceType.self) { _ in VoteDataSource() }
    }
}
