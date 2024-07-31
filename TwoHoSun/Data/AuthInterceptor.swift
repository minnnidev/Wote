//
//  AuthInterceptor.swift
//  TwoHoSun
//
//  Created by 김민 on 7/9/24.
//

import Foundation
import Alamofire
import SwiftUI

final class AuthInterceptor: RequestInterceptor {

    @AppStorage(AppStorageKey.loginState) private var isLoggedIn: Bool = false

    static let shared = AuthInterceptor()

    private init() { }

    /// 네트워크 실패 시 retry 메서드 실행 
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")

        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }

        reissueToken { [weak self] succeed in
            if succeed {
                /// 토큰  재발급에 성공하여 실패했던 통신을 재시도
                completion(.retry)
            } else {
                /// 토큰 재발급을 실패하면 로그인 화면으로 진입
                self?.isLoggedIn = false
                completion(.doNotRetryWithError(error))
            }
        }
    }

    func reissueToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = KeychainManager.shared.read(key: TokenType.refreshToken) else { return }

        let requestTokenObject: RefreshTokenRequestObject = .init(
            refreshToken: refreshToken
        )

        let reissueTokenAPI: AuthAPI = .getNewToken(requestTokenObject)

        AF.request(URL(string: URLConst.baseURL + reissueTokenAPI.path)!,
                   method: reissueTokenAPI.method,
                   parameters: requestTokenObject.toDictionary(),
                   encoding: JSONEncoding.default,
                   headers: APIConstants.httpsHeaderWithAuthorization)
        .response { response in
            switch response.result {

            case let .success(data):
                guard let data = data else { return }

                do {
                    let result = try JSONDecoder().decode(GeneralResponse<TokenObject>.self, from: data)

                    guard let tokens = result.data?.toToken() else { 
                        completion(false)
                        return 
                    }

                    KeychainManager.shared.save(key: TokenType.accessToken, token: tokens.accessToken)
                    KeychainManager.shared.save(key: TokenType.refreshToken, token: tokens.refreshToken)

                    completion(true)
                } catch {
                    completion(false)
                }

            case let .failure(error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
