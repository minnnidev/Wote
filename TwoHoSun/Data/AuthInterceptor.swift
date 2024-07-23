//
//  AuthInterceptor.swift
//  TwoHoSun
//
//  Created by 김민 on 7/9/24.
//

import Foundation
import Alamofire

class AuthInterceptor: RequestInterceptor {

    static let shared = AuthInterceptor()

    private init() { }

    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        print("====== retry ======")

        guard let response = request.task?.response as? HTTPURLResponse,
                response.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }

        reissueToken { succeed in
            if succeed {
                completion(.retry)
            } else {
                // TODO: - 갱신 실패 시 처리
            }
        }
    }

    func reissueToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = KeychainManager.shared.read(key: TokenType.refreshToken) else { return }

        let requestTokenObject: RefreshTokenRequestObject = .init(
            refreshToken: refreshToken
        )

        let reissueTokenAPI: AuthAPI = .getNewToken(requestTokenObject)
        

        AF.request(reissueTokenAPI.baseURL,
            method: reissueTokenAPI.method,
            parameters: requestTokenObject.toDictionary(),
            encoding: URLEncoding.default,
            headers: ["Content-Type":"application/json"])
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
                // TODO: - 에러 처리
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
