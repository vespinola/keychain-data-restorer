//
//  KeychainDataRestorer.swift
//  KeychainAccessLost
//
//  Created by Vladimir Espinola Lezcano on 2021-08-15.
//

import Foundation
import KeychainAccess

struct KeychainDataRestorer {
    private init() {}
    
    private static let fileName = "data"
    
    static var shared: KeychainDataRestorer = { KeychainDataRestorer() }()
    
    private var storedData: KeychainData? {
        guard let fileContent = try? FileIOController.read(toDocumentNamed: KeychainDataRestorer.fileName) else { return KeychainData() }
        guard let data = try? JSONDecoder().decode(KeychainData.self, from: fileContent) else { return KeychainData() }
        return data
    }
    
    var storedImportantData: String? { storedData?.importantData }
    
    func getImportantData() -> String? {
        if let importantData = keychain[KechainDataIdentifiers.importantData] {
            saveImportantDataIfNeeded(importantData)
            return importantData
        } else if let storedImportantData = storedImportantData {
            keychain[KechainDataIdentifiers.importantData] = storedImportantData
            return storedImportantData
        } else {
            return nil
        }
    }
    
    func saveImportantDataIfNeeded(_ importantData: String, force: Bool = false) {
        guard var data = storedData else { return }
        guard data.importantData == nil || force else { return }
        data.importantData = importantData
        save(data: data)
    }
}

//MARK: Private Methods
extension KeychainDataRestorer {
    fileprivate func save(data: KeychainData) {
        try? FileIOController.write(object: data, toDocumentNamed: KeychainDataRestorer.fileName)
    }
}


