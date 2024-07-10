//
//  AppDependency.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation
import Swinject

class AppDependency: ObservableObject {
    let container: Container

    init() {
        self.container = Container()

        assembleDependencies()
    }

    private func assembleDependencies() {
        let assemblies: [Assembly] = [
            AuthAssembly(),
            UserAssmbly()
        ]

        assemblies.forEach { $0.assemble(container: container) }
    }
}
