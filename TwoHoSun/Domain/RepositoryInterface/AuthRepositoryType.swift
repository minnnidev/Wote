//
//  AuthRepositoryType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation
import Combine

protocol AuthRepositoryType {
    func loginWithApple(_ authorizationCode: String) -> AnyPublisher<User, WoteError>
    func logout(_ deviceToken: String) -> AnyPublisher<Void, WoteError>
}
