//
//  FileMetaData.swift
//  Atunda
//
//  Created by Mas'ud on 11/29/22.
//

import Foundation
import SwiftyDropbox

enum FileType : String {
    
    case file = "file", folder = "folder"
}

class FileMetaData {
    
    var name: String
    var size: Int?
    var NumOfItems: Int?
    var type: FileType
    
    init(name: String, size: Int? = nil, NumOfItems: Int? = nil, type: FileType) {
        self.name = name
        self.size = size
        self.NumOfItems = NumOfItems
        self.type = type
    }
    
    func getNumberOfItems(completion: @escaping (Int) -> Void) {
        
        DropBox.shared.readFolders(name: self.name, completion: {response in
            
            if response.check {
                if let names = response.object as? [FileMetaData] {
                    
                    completion(names.count)
                }
                
            }
        })
        
    }
    
     func getSize(completion: @escaping (String) -> Void) {
        
        DropBox.shared.readFolders(name: self.name, completion: {[weak self] response in
            
            if response.check {
                if let names = response.object as? [FileMetaData] {
                    
                    var count = 0
                    for name in names {
                       
                        count += name.size!
                    }
                    self?.size = count
                    completion(self!.sizeText())
                }
                
            }
        })
    }
    
    func sizeText() -> String {
        
        if let size = size {
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useMB, .useGB, .useKB] // optional: restricts the units to MB only
            bcf.countStyle = .file
            let string = bcf.string(fromByteCount: Int64(size))
            return string
        }else {
            return "0mb"
        }
    }
 
}
