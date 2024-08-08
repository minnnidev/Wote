//
//  GeneralResponse.swift
//  TwoHoSun
//
//  Created by 235 on 10/17/23.
//

import Foundation

struct GeneralResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String
    let divisionCode: String?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case divisionCode
        case data
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        divisionCode = (try? values.decode(String.self, forKey: .divisionCode)) ?? nil
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}

struct NoData: Decodable {}
