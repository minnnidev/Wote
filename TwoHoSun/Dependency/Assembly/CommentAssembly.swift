//
//  CommentAssembly.swift
//  TwoHoSun
//
//  Created by 김민 on 7/30/24.
//

import Foundation
import Swinject
import Moya

final class CommentAssembly: Assembly {

    func assemble(container: Container) {

        // MARK: ViewModels

        container.register(CommentsViewModel.self) { res, postId in
            CommentsViewModel(
                postId: postId,
                commentUseCase: res.resolve(CommentUseCaseType.self)!,
                userUseCase: res.resolve(UserUseCaseType.self)!
            )
        }

        // MARK: UseCases

        container.register(CommentUseCaseType.self) { res in
            CommentUseCase(commentRepository: res.resolve(CommentRepositoryType.self)!)
        }

        // MARK: Repositories

        container.register(CommentRepositoryType.self) { res in
            CommentRepository(commentDataSource: res.resolve(CommentDataSourceType.self)!)
        }

        // MARK: DataSource

        container.register(CommentDataSourceType.self) { res in
            CommentDataSource(provider: NetworkProvider.shared)
        }
    }
}
