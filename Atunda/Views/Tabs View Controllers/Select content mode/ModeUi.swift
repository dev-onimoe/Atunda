//
//  ModeUi.swift
//  Atunda
//
//  Created by Mas'ud on 9/9/22.
//

import Foundation
import UIKit
import PhotosUI

class ModeUi{
    
    var vc : ModeViewController?
    var tableView = UITableView()
    var progressView = UIView()
    let loaderView = UIView()
    
    let pic = UIImageView(image: UIImage(systemName: "person.circle"))
    
    init(vc: ModeViewController) {
        self.vc = vc
    }
    
    func setup() {
        
        progressView.isUserInteractionEnabled = true
        //self.progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeProgress)))
        
        tableView = UITableView()
        Constants.tableView.delegate = vc
        Constants.tableView.dataSource = vc
        Constants.tableView.backgroundColor = Constants.pink
        Constants.tableView.register(CaptureTableViewCell.self, forCellReuseIdentifier: "capture")
        
        let cache = Cache()
        Constants.currentUser = cache.retrieveData(key: "user", castTo: User.self)
        //print(Constants.currentUser?.email)
        
        guard let view = vc?.view else {return}
        //view.initSetup()
        
        
        
        //let pic = UIImageView(image: UIImage(named: "photo"))
        view.addSubview(pic)
        pic.tintColor = .white
        pic.constraint(equalToTop: view.topAnchor, equalToLeft: view.leadingAnchor, paddingTop: 100, paddingLeft: 16, width: 30, height: 30)
        pic.contentMode = .scaleToFill
        pic.clipsToBounds = true
        pic.layer.cornerRadius = 15
        
        let notifications = UIImageView(image: UIImage(named: "Notification"))
        notifications.tintColor = Constants.darkPurple
        view.addSubview(notifications)
        notifications.constraint(equalToRight: view.trailingAnchor, paddingRight: 16, width: 20, height: 25)
        notifications.centre(centreY: pic.centerYAnchor)
        notifications.isUserInteractionEnabled = true
        notifications.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProgress)))

        
        let stack = UIView()
        view.addSubview(stack)
        //stack.constraint(height: 400)
        stack.centre(centerX: view.centerXAnchor, centreY: view.centerYAnchor)
        //stack.constraint(width: 350, height: 470)
        //stack.backgroundColor = .red
        
        let imageView = UIImageView(image: UIImage(named: "Group 3"))
        imageView.contentMode = .scaleAspectFit
        //imageView.constraint(width: 350)
        //imageView.backgroundColor = .blue
        stack.addSubview(imageView)
        imageView.constraint(height: 100)
        
        let record = UILabel()
        record.text = "Record"
        record.textAlignment = .center
        record.font = Constants.boldFont(size: 16)
        record.textColor = .white
        //label.backgroundColor = .green
        
        let stack1 = UIStackView()
        stack.addSubview(stack1)
        stack1.constraint(equalToTop: stack.topAnchor, equalToLeft: stack.leadingAnchor, equalToRight: stack.trailingAnchor)
        stack1.axis = .vertical
        stack1.spacing = 2
        stack1.addArrangedSubview(imageView)
        stack1.addArrangedSubview(record)
        stack1.isUserInteractionEnabled = true
        stack1.tag = 0
        stack1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigate)))
        
        let label = UILabel()
        label.text = "Or"
        label.textAlignment = .center
        label.font = Constants.boldFont(size: 16)
        label.textColor = .white
        //label.backgroundColor = .green
        stack.addSubview(label)
        label.constraint(equalToTop: stack1.bottomAnchor, equalToLeft: stack.leadingAnchor, equalToRight: stack.trailingAnchor, paddingTop: 50)
        
        let imageView2 = UIImageView(image: UIImage(named: "plus"))
        imageView2.contentMode = .scaleAspectFit
        //imageView.constraint(width: 350)
        //imageView.backgroundColor = .blue
        stack.addSubview(imageView2)
        imageView2.constraint(height: 100)
        
        let upload = UILabel()
        upload.text = "Upload"
        upload.textAlignment = .center
        upload.font = Constants.boldFont(size: 16)
        upload.textColor = .white
        //label.backgroundColor = .green
        
        let stack2 = UIStackView()
        stack.addSubview(stack2)
        stack2.constraint(equalToTop: label.bottomAnchor, equalToBottom: stack.bottomAnchor, equalToLeft: stack.leadingAnchor, equalToRight: stack.trailingAnchor, paddingTop: 50)
        stack2.axis = .vertical
        stack2.spacing = 2
        stack2.addArrangedSubview(imageView2)
        stack2.addArrangedSubview(upload)
        stack2.isUserInteractionEnabled = true
        stack2.tag = 1
        stack2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigate)))
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
    
    @objc func navigate(_ sender: UITapGestureRecognizer) {
        
        let tag = sender.view?.tag
        
        if tag == 0 {
            
            let vc = CaptureViewController()
            vc.modalPresentationStyle = .fullScreen
            self.vc?.present(vc, animated: true)
        }else {
            vc?.view.showLoader()
            
            if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
                PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite, handler: {status in
                    
                    switch status {
                    case .authorized:
                        var config = PHPickerConfiguration()
                        config.selectionLimit = 30
                        config.filter = .videos
                        
                        DispatchQueue.main.async {
                            let vc = PHPickerViewController(configuration: config)
                            vc.delegate = self.vc!
                            self.vc?.present(vc, animated: true, completion: {
                                self.vc!.view.removeLoader()
                            })
                        }
                    case .denied:
                        print("Access denied")
                        DispatchQueue.main.async {
                            self.vc?.view.showtoast(message2: "You need to give Atunda access to your gallery to continue, please check settings to give permission")
                            self.vc?.view.removeLoader()
                        }
                        
                    default:
                        print("get access")
                        DispatchQueue.main.async {
                            
                            self.vc?.view.showtoast(message2: "You need to give Atunda access to your gallery to continue, please check settings to give permission")
                            self.vc?.view.removeLoader()
                        }
                    }
                })
                
            }else {
                var config = PHPickerConfiguration()
                config.selectionLimit = 30
                config.filter = .videos
                
                DispatchQueue.main.async {
                    let vc = PHPickerViewController(configuration: config)
                    vc.delegate = self.vc!
                    self.vc?.present(vc, animated: true, completion: {
                        self.vc!.view.removeLoader()
                    })
                }
            }
            
        }
    }
    
    func showLoader() {
        
        loaderView.frame = CGRect(x: 0, y: 0, width: vc!.view.frame.width, height: vc!.view.frame.height)
        vc?.view.addSubview(loaderView)
        loaderView.backgroundColor = Constants.navyBlue2
        
        let loader = UIActivityIndicatorView()
        loader.tintColor = Constants.darkPurple
        loader.color = Constants.darkPurple
        loaderView.addCordinateSubviewToCentre(view: loader, width: 30, height: 30)
        loader.startAnimating()
        
    }
}
