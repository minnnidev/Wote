//
//  MultipartFormDataHelper.swift
//  TwoHoSun
//
//  Created by 김민 on 7/11/24.
//

import Foundation
import Moya

struct MultipartFormDataHelper {
    
    static func createMultipartFormData(from profileRequest: ProfileRequestObject) -> [MultipartFormData] {
        var formData = [MultipartFormData]()

        if let imageFile = profileRequest.imageFile {
            let imageMultipart = MultipartFormData(
                provider: .data(imageFile),
                name: "imageFile",
                fileName: "\(profileRequest.nickname).jpg",
                mimeType: "image/jpeg"
            )

            formData.append(imageMultipart)
        }

        var profileData: [String: Any] = [
             "nickname": profileRequest.nickname
         ]

        if profileRequest.school != nil {
            profileData["school"] = [
                "schoolName": profileRequest.school?.schoolName,
                "schoolRegion": profileRequest.school?.schoolRegion
             ]
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: profileData)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let stringData = MultipartFormData(provider: .data(jsonString.data(using: String.Encoding.utf8)!),
                                               name: "profileRequest",
                                               mimeType: "application/json")
            formData.append(stringData)
        } catch {
            print("error")
        }

        return formData
    }
}

