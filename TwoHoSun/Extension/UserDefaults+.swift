//
//  UserDefaults+.swift
//  TwoHoSun
//
//  Created by 235 on 11/28/23.
//

import Foundation

extension UserDefaults {
    
    func setObject<T: Encodable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            self.set(data, forKey: key)
        }
    }

    func getObject<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = self.data(forKey: key),
           let object = try? JSONDecoder().decode(T.self, from: data) {
            return object
        }
        return nil
    }
}
