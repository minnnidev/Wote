//
//  UserRepositoryType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation
import Combine

protocol UserRepositoryType {
    func checkNicknameDuplicated(_ nickname: String) -> AnyPublisher<Bool, WoteError>
    func getSchoolsData(_ query: String) async throws -> [SchoolInfoModel]
}
