//
//  AuthRepositoryType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation
import Combine

protocol AuthRepositoryType {
    func signIn(_ authorizationCode: String) -> AnyPublisher<Tokens, TestError>
}
