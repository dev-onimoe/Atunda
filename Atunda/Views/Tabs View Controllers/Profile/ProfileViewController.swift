//
//  ProfileViewController.swift
//  Atunda
//
//  Created by Mas'ud on 9/14/22.
//

import UIKit
import PhotosUI

class ProfileViewController: UIViewController {
    
    var profileUI: ProfileUI?
    var urls: URL?
    let viewModel = profileViewModel()
    var homevc : HomeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileUI = ProfileUI(viewController: self)
        profileUI?.setup()
        binds()
        // Do any additional setup after loading the view.
    }
    
    func binds() {
        
        viewModel.uploadObserver.bind(completion: {[weak self] response in
            
            if let desc = response?.description {
                
                self?.view.showtoast(message2: desc)
            }
        })
        
        viewModel.downloadObserver.bind(completion: {[weak self] data in
            
            if let data = data {
                
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.profileUI?.pic.image = image
                }
            }else {
                
                //self?.view.showtoast(message2: "No data was returned")
            }
        })
        
        viewModel.downloadPicture()
    }

}

extension ProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if !results.isEmpty {
    
            let itemProvider = results.first!.itemProvider
            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.heic.identifier, completionHandler: {[weak self] url, error in
                
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    
                    let fileName = "\(Int(Date().timeIntervalSince1970)).\(url!.pathExtension)"
                   
                    let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
                    
                    try? FileManager.default.copyItem(at: url!, to: newUrl)
                    
                    self?.urls = newUrl
                    
                    let data = try? Data(contentsOf: newUrl)
                    
                    if let dataa = data {
                        
                        //self?.uploadData(data: dataa)
                        self?.viewModel.uploadPicture(data: dataa)
                    }
                    
                }
            })
            
            
        }
    }
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //var image : UIImage!
        //var data = NSData()
        var ImageData : NSData? = nil

        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
           
            ImageData = img.jpegData(compressionQuality: 0.3)! as NSData
            
            self.profileUI?.pic.image = UIImage(data: ImageData as! Data)
                
               

        }else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            ImageData = img.jpegData(compressionQuality: 0.3)! as NSData
            
            
            self.profileUI?.pic.image = UIImage(data: ImageData as! Data)
        }
        
        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            asset.requestContentEditingInput(with: nil) { input, info in
                        if let fileURL = input?.fullSizeImageURL {
                            //print("original URL", fileURL)
                            let path = fileURL.absoluteString
                            
                            //self.uploadTask(file: ImageData as! Data, fileName: "file")
                            self.viewModel.uploadPicture(data: ImageData as! Data)
                        }
                    }
            }


        self.profileUI?.imagePicker.dismiss(animated: true,completion: nil)
        
        
    }
}
