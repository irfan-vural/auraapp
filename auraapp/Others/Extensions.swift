//
//  Extension.swift
//  auraapp
//
//  Created by İrfan Vural on 14.03.2026.
//

import Foundation

extension Encodable{
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else{
            return[:]
        }
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = json as? [String: Any] else {
            fatalError("Couldn't convert to dictionary")
        }
        return dictionary
    }
}
