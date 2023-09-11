//
//  SelectionViewModel.swift
//  Atunda
//
//  Created by Mas'ud on 12/14/22.
//

import Foundation

class SelectionViewModel {
    
    var checkObserver : Observable<Response?> = Observable(nil)
    var uploadObserver : Observable<Response?> = Observable(nil)
    var batchUploadObserver : Observable<Response?> = Observable(nil)
    var createObserver : Observable<Response?> = Observable(nil)
    
    //var root = Constants.currentUser?.userName
    
    func checkExist(rooted: String, folder: String) {
        
        DropBox.shared.checkIfExists(rooted: rooted, name: folder, completion: { [weak self] response in
            
            self?.checkObserver.value = response
            
        })
    }
    
    func createFolder(danceTitle: String, base: Bool) {
        
        DropBox.shared.createFolder(name: danceTitle, base: base, completion: { [weak self] response in
            
            self?.createObserver.value = response
            
        })
    }
    
    func upload(path: String, file: URL?, fileData: Data?, track: Bool) {
        
        DropBox.shared.upload(path: path, file: file, track: track, fileData: fileData, completion: {[weak self] response, data in
            
            self?.uploadObserver.value = response
        })
    }
    
    func batchUpload(path: String, files: [URL], track: Bool) {
        
        DropBox.shared.batchUpload(path: path, files: files, track: track, completion: {[weak self] response, data  in
            
            self?.batchUploadObserver.value = response
        })
    }
    
}
