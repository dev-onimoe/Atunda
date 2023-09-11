//
//  ModeViewModel.swift
//  Atunda
//
//  Created by Mas'ud on 11/1/22.
//

import Foundation

class ModeViewModel{
    
    var downloadObserver : Observable<Data?> = Observable(nil)
     
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

