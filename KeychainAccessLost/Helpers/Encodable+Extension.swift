//
//  Encodable+Extension.swift
//  KeychainAccessLost
//
//  Created by Vladimir Espinola Lezcano on 2021-08-15.
//

import Foundation

extension Encodable {
    func encode(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}
