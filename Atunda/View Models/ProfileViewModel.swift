//
//  ProfileViewModel.swift
//  Atunda
//
//  Created by Mas'ud on 10/30/22.
//

import Foundation

class profileViewModel{
    
    
    var uploadObserver : Observable<Response?> = Observable(nil)
    var downloadObserver : Observable<Data?> = Observable(nil)
     
    
    func uploadPicture(data: Data) {
        
        Service.shared.uploadProfileImage(data: data, completion: {[weak self] response in
            
            self?.uploadObserver.value = response
        })
    }
    
    func downloadPicture() {
        
        if let pic = Constants.currentUser?.profileImage {
            
            Service.shared.download(completion: {[weak self] data in
                
                self?.downloadObserver.value = data
            })
        }else {
            
            Service.shared.downloadProfileImage(completion: {[weak self] data in
                
                self?.downloadObserver.value = data
            })
        }
    }
    
}
