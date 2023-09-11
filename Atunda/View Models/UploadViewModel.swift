//
//  UploadViewModel.swift
//  Atunda
//
//  Created by Mas'ud on 11/22/22.
//

import Foundation

class uploadViewModel {
    
    var uploadsObject : Observable<Response?> = Observable(nil)
    var downloadObject : Observable<Response?> = Observable(nil)
    
    
    func readFolders(path: String) {
        
        DropBox.shared.readFolders(name: path, completion: { [weak self] response in
            //print(Constants.DropboxToken)
            self?.uploadsObject.value = response
        })
    }
    
    func download(path: String, destination: URL) {
        
        DropBox.shared.download(path: path, destinationUrl: destination, completion: {[weak self] response in
            
            self?.downloadObject.value = response
        })
    }
}
