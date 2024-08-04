//
//  ReviewAssembly.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Swinject
import Moya

final class ReviewAssembly: Assembly {

    func assemble(container: Container) {

        // MARK: ViewModels
        
        container.register(ReviewListViewModel.self) { res in
            ReviewListViewModel(reviewUseCase: res.resolve(ReviewUseCaseType.self)!)
        }

        container.register(ReviewDetailViewModel.self) { res, postId in
            ReviewDetailViewModel(
                id: postId,
                reviewUseCase: res.resolve(ReviewUseCaseType.self)!,
                userUseCase: res.resolve(UserUseCaseType.self)!
            )
        }

        container.register(ReviewWriteViewModel.self) { res, postId in
            ReviewWriteViewModel(
                voteId: postId,
                reviewUseCase: res.resolve(ReviewUseCaseType.self)!,
                photoUseCase: res.resolve(PhotoUseCaseType.self)!
            )
        }

        // MARK: UseCases

        container.register(ReviewUseCaseType.self) { res in
            ReviewUseCase(reviewRepository: res.resolve(ReviewRepositoryType.self)!)
        }

        // MARK: Repositories

        container.register(ReviewRepositoryType.self) { res in
            ReviewRepository(reviewDataSource: res.resolve(ReviewDataSourceType.self)!)
        }

        // MARK: DataSource
        
        container.register(ReviewDataSourceType.self) { res in
            ReviewDataSource(provider: NetworkProvider.shared)
        }
    }
}

