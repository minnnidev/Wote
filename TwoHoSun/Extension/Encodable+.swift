//
//  Encodable+.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation

extension Encodable {

  func toDictionary() -> [String: Any] {
      do {
          let data = try JSONEncoder().encode(self)
          let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
          return dic ?? [:]
      } catch {
          return [:]
      }
  }
}
