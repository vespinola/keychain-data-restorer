//
//  KeychainAccessConfig.swift
//  KeychainAccessLost
//
//  Created by Vladimir Espinola Lezcano on 2021-08-15.
//

import Foundation
import KeychainAccess


let keychain = Keychain(service:  Bundle.main.bundleIdentifier ?? "")

struct KechainDataIdentifiers {
    private init() {}
    static let importantData = "importantData"
}
