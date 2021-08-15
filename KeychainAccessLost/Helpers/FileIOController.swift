//
//  FileIOController.swift
//  KeychainAccessLost
//
//  Created by Vladimir Espinola Lezcano on 2021-08-15.
//

import Foundation

//Based on https://www.swiftbysundell.com/articles/working-with-files-and-folders-in-swift/

class FileIOController {
    fileprivate static var manager = FileManager.default
    
    fileprivate static let rootFolder = "backup"
    
    class func write<T: Encodable>(
        object: T,
        toDocumentNamed documentName: String,
        encodeUsing encoder: JSONEncoder = .init()
    ) throws {
        let rootFolderURL = try manager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        
        let nestedFolderURL = rootFolderURL.appendingPathComponent(rootFolder)
        
        if !manager.fileExists(atPath: nestedFolderURL.path) {
            do {
                try manager.createDirectory(
                    at: nestedFolderURL,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
            } catch(let exception) {
                throw exception
            }
        }
        
        let fileURL = nestedFolderURL.appendingPathComponent(documentName)
        let data = try encoder.encode(object)
        try data.write(to: fileURL, options: .completeFileProtectionUntilFirstUserAuthentication)
    }
    
    class func read(
        toDocumentNamed documentName: String
    ) throws -> Data? {
        let rootFolderURL = try manager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        
        let nestedFolderURL = rootFolderURL.appendingPathComponent(rootFolder)
        
        guard manager.fileExists(atPath: nestedFolderURL.path) else {
            return nil
        }
        
        let fileURL = nestedFolderURL.appendingPathComponent(documentName)
        
        guard manager.fileExists(atPath: fileURL.path) else { return nil }
        
        return manager.contents(atPath: fileURL.path)
    }
}
