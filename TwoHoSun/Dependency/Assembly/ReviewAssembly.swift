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
        container.register(ReviewListViewModel.self) { _ in
            ReviewListViewModel()
        }

        // MARK: UseCases

        // MARK: Repositories

        // MARK: DataSource

    }
}

