//
//  MoyaProviderType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation
import Moya

protocol Networkable {
    associatedtype target: TargetType

    var provider: MoyaProvider<target> { get }
}

extension Networkable {

    var provider: MoyaProvider<target> {
        MoyaProvider<target>(plugins: [])
    }
}
