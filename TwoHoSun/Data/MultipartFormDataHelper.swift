//
//  MultipartFormDataHelper.swift
//  TwoHoSun
//
//  Created by 김민 on 7/11/24.
//

import Foundation
import Moya
import UIKit

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

    static func createMultipartFormData(from vote: VoteCreateRequestObject) -> [MultipartFormData] {
        var formData: [MultipartFormData] = []
        if let data = UIImage(data: vote.image ?? Data())?.jpegData(compressionQuality: 0.3) {
            let imageData = MultipartFormData(provider: .data(data), name: "imageFile", fileName: "temp.jpg", mimeType: "image/jpeg")
            formData.append(imageData)
        }

        let postData: [String: Any] = [
            "visibilityScope": vote.visibilityScope.rawValue,
            "title": vote.title,
            "price": vote.price ?? 0,
            "contents": vote.contents ?? "",
            "externalURL": vote.externalURL ?? ""
        ]
        
        do {
            let json = try JSONSerialization.data(withJSONObject: postData)
            let jsonString = String(data: json, encoding: .utf8)!
            let stringData = MultipartFormData(provider: .data(jsonString.data(using: .utf8)!),
                                               name: "postRequest",
                                               mimeType: "application/json")
            formData.append(stringData)
        } catch {
            print("error: \(error)")
        }

        return formData
    }
}

