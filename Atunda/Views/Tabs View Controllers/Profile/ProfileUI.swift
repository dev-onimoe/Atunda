//
//  ProfileUI.swift
//  Atunda
//
//  Created by Mas'ud on 9/14/22.
//

import Foundation
import UIKit
import PhotosUI

class ProfileUI{
    
    var vc : ProfileViewController?
    var notifications = UIImageView()
    var pic = UIImageView()
    var progressView = UIView()
    var nameText = UILabel()
    var emailText = UILabel()
    var settingsText = UILabel()
    var deleteAccountText = UILabel()
    var modeView = UIView()
    var imagePicker = UIImagePickerController()
    
    init(viewController: ProfileViewController) {
        vc = viewController
        
    }
    
    func setup() {
        
        guard let view = vc?.view else {return}
        view.initSetup()
        
        let text = UILabel()
        text.frame = CGRect(x: 32, y: 100, width: 250, height: 30)
        view.addSubview(text)
        //text.constraint(equalToTop: view.topAnchor, equalToLeft: view.leadingAnchor, paddingTop: 100, paddingLeft: 32)
        text.text = "Profile"
        text.textColor = .white
        text.font = Constants.boldFont(size: 18)
        text.textAlignment = .left
        //print(text.frame)
        
        notifications = UIImageView(image: UIImage(named: "Notification"))
        notifications.frame.origin = CGPoint(x: view.frame.width - 48.0, y: 100)
        view.addSubview(notifications)
        notifications.isUserInteractionEnabled = true
        notifications.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProgress)))
        //print(notifications.frame)
        //notifications.constraint(equalToRight: view.trailingAnchor, paddingRight: 32, width: 20, height: 25)
        
        let picview = UIView()
        view.centreHorizontally(view: picview, y: text.frame.origin.y + text.frame.size.height + 70, height: 200.0, width: 200.0)
        picview.layer.borderColor = UIColor.white.cgColor
        picview.layer.borderWidth = 1.5
        picview.backgroundColor = .none
        picview.layer.cornerRadius = 100
        
        
        pic = UIImageView(image: UIImage(systemName: "person.circle"))
        picview.addSubview(pic)
        pic.tintColor = .white
        pic.constraint(paddingTop: 100, width: 185, height: 185)
        pic.centre(centerX: picview.centerXAnchor, centreY: picview.centerYAnchor)
        pic.contentMode = .scaleToFill
        pic.clipsToBounds = true
        pic.layer.cornerRadius = 92.5
        pic.isUserInteractionEnabled = true
        pic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadPic)))
        
        let name_ic = UIImageView(image: UIImage(named: "contact"))
        name_ic.constraint(width: 20, height: 20)
        name_ic.contentMode = .scaleToFill
        
        nameText = UILabel()
        nameText.text = "Name"
        nameText.textColor = .white
        nameText.font = Constants.regularFont(size: 14)
        nameText.textAlignment = .left
        
        let nameStack = UIStackView(arrangedSubviews: [name_ic, nameText])
        nameStack.spacing = 12
        
        let email_ic = UIImageView(image: UIImage(named: "mail"))
        email_ic.constraint(width: 20, height: 15)
        email_ic.contentMode = .scaleToFill
        
        emailText = UILabel()
        emailText.text = "Email"
        emailText.textColor = .white
        emailText.font = Constants.regularFont(size: 14)
        emailText.textAlignment = .left
        
        let emailStack = UIStackView(arrangedSubviews: [email_ic, emailText])
        emailStack.spacing = 12
        
        let firstview = UIView()
        firstview.backgroundColor = .white
        firstview.constraint(height: 1.5)
        
        let settings_ic = UIImageView(image: UIImage(systemName: "gearshape.fill"))
        settings_ic.tintColor = .white
        settings_ic.constraint(width: 20, height: 20)
        settings_ic.contentMode = .scaleToFill
        
        let settingsText = UILabel()
        //settingsText = UILabel()
        settingsText.text = "Settings"
        settingsText.textColor = .white
        settingsText.font = Constants.regularFont(size: 14)
        settingsText.textAlignment = .left
        
        let settingsStack = UIStackView(arrangedSubviews: [settings_ic, settingsText])
        settingsStack.spacing = 12
        settingsStack.isUserInteractionEnabled = true
        settingsStack.tag = 0
        settingsStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSettings)))
        
        let secondview = UIView()
        secondview.backgroundColor = .white
        secondview.constraint(height: 1.5)
        
        let delAcct_ic = UIImageView(image: UIImage(named: "mail"))
        delAcct_ic.constraint(width: 25, height: 20)
        delAcct_ic.contentMode = .scaleToFill
        
        let deleteAccountText = UILabel()
        //deleteAccountText = UILabel()
        deleteAccountText.text = "Delete Account"
        deleteAccountText.textColor = .white
        deleteAccountText.font = Constants.regularFont(size: 14)
        deleteAccountText.textAlignment = .left
        
        let deleteStack = UIStackView(arrangedSubviews: [delAcct_ic, deleteAccountText])
        deleteStack.spacing = 12
        deleteStack.isUserInteractionEnabled = true
        deleteStack.tag = 1
        deleteStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSettings)))
        
        let vStack = UIStackView(arrangedSubviews: [nameStack, emailStack, firstview, settingsStack])
        view.addSubview(vStack)
        vStack.constraint(equalToTop: pic.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        vStack.axis = .vertical
        vStack.spacing = 32
        
        if let user = Constants.currentUser {
            nameText.text = user.userName
            emailText.text = user.email
        }
    }
    
    @objc func showProgress() {
        
        let close = UIImageView(image: UIImage(systemName: "x.circle"))
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeProgress)))
        
        vc?.homevc!.view.showProgress(back: progressView, close: close)
    }
    
    @objc func removeProgress() {
        
        self.progressView.removeProperly()
    }
    
    func removeGlow(view: UIView) {
        
        view.layer.shadowOpacity = 0
    }
    
    @objc func uploadPic() {
        
        /*PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite, handler: {status in
            
            switch status {
            case .authorized:
                var config = PHPickerConfiguration()
                config.selectionLimit = 1
                config.filter = .images
                
                DispatchQueue.main.async {
                    let vc = PHPickerViewController(configuration: config)
                    vc.delegate = self.vc!
                    self.vc?.present(vc, animated: true)
                }
            case .denied:
                print("Access denied")
            default:
                print("get access")
            }
        })*/
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { granted in
                
                if granted == .authorized {
                    
                    DispatchQueue.main.async {
                        
                        //self.saveBtnOutlet.alpha = 0
                    }
                    
                    
                    
                    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                                //print("Button capture")

                        DispatchQueue.main.async {
                            self.imagePicker.delegate = self.vc
                            self.imagePicker.sourceType = .savedPhotosAlbum
                            self.imagePicker.allowsEditing = true

                            self.vc?.present(self.imagePicker, animated: true, completion: nil)
                        }
                        
                        
                            }
                }else if granted == .denied || granted == .restricted {
                    
                   return
                }
            }
        }else {
            
            if PHPhotoLibrary.authorizationStatus() == .authorized {
                
                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                            //print("Button capture")

                    DispatchQueue.main.async {
                        
                        //self.saveBtnOutlet.alpha = 0
                        
                        self.imagePicker.delegate = self.vc!
                        self.imagePicker.sourceType = .savedPhotosAlbum
                        self.imagePicker.allowsEditing = true

                        self.vc?.present(self.imagePicker, animated: true, completion: nil)
                    }
                    
                    
                        }
            }else if PHPhotoLibrary.authorizationStatus() == .denied || PHPhotoLibrary.authorizationStatus() == .restricted {
                
                PHPhotoLibrary.requestAuthorization { granted in
                    
                    if granted == .authorized {
                        
                        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                                    //print("Button capture")

                            DispatchQueue.main.async {
                                self.imagePicker.delegate = self.vc
                                self.imagePicker.sourceType = .savedPhotosAlbum
                                self.imagePicker.allowsEditing = true

                                self.vc?.present(self.imagePicker, animated: true, completion: nil)
                            }
                            
                            
                                }
                    }else if granted == .denied || granted == .restricted {
                        
                       return
                    }
                }
            }
        }
    }
    
    @objc func goToSettings(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag
        switch tag {
        case 0:
            let vc = SettingsViewController()
            vc.modalPresentationStyle = .fullScreen
            self.vc?.present(vc, animated: true)
        case 1:
            print(tag)
        default:
            print(tag)
        }
    }
}

