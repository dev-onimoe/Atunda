//
//  SelectedViewController.swift
//  Atunda
//
//  Created by Mas'ud on 9/22/22.
//

import UIKit
import AVFoundation

class SelectedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, showUploads {
    
    func showProgresses() {
        //
    }
    

    var selectedui: SelectedUI?
    var urls: [URL]?
    var vm : SelectionViewModel?
    var visibleCells : [Int] = []
    var dCheck = false
    let loaderView = UIView()
    var keyHeight = 0.0
    var del : showUploads?
    var usr : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedui = SelectedUI(vc: self)
        selectedui?.setup()
        //print(Constants.currentUser)
        usr = Constants.currentUser
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        
    }
    
    func setup() {
        
        vm = SelectionViewModel()
        
        vm?.checkObserver.bind(completion: { [weak self] response in
            self!.view.removeLoader()
            if let response = response {
                
                if response.check {
            
                    if response.description == "" {
                        self!.vm?.checkExist(rooted: "/\(self!.usr!.userName.lowercased())", folder: self!.selectedui!.title.text!.lowercased())
                    }else {
                        let tagsData = self!.selectedui!.tags.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        let descData = self!.selectedui!.description.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        self!.vm?.upload(path: "\(self!.selectedui!.title.text!)/Tags.txt", file: nil, fileData: tagsData, track: false)
                        self!.vm?.upload(path: "\(self!.selectedui!.title.text!)/Description.txt", file: nil, fileData: descData, track: false)
                    }
                }else {
                    
                    //self?.vc?.view.showtoast(message2: response.description)
                    if response.description == "Folder does not exist" {
                        self?.vm?.createFolder(danceTitle: self!.selectedui!.title.text!.lowercased(), base: false)
                        
                    }else if response.description == "root" {
                        
                        self?.vm?.createFolder(danceTitle: self!.selectedui!.title.text!.lowercased(), base: true)
                    }else {
                        self?.view.showtoast(message2: response.description)
                        
                        print(response.description)
                    }
                }
            }
        })
        
        vm?.createObserver.bind(completion: { [weak self] response in
            
            self!.view.removeLoader()
            
            if let response = response {
                
                if response.check {
                    
                    if response.description == "root" {
                        self?.vm?.createFolder(danceTitle: self!.selectedui!.title.text!.lowercased(), base: false)
                    }else {
                        let tagsData = self!.selectedui!.tags.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        let descData = self!.selectedui!.description.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        self!.vm?.upload(path: "\(self!.selectedui!.title.text!)/Tags.txt", file: nil, fileData: tagsData, track: false)
                        self!.vm?.upload(path: "\(self!.selectedui!.title.text!)/Description.txt", file: nil, fileData: descData, track: false)
                    }
              
                }else {
                    self?.view.showtoast(message2: response.description)
                    print(response.description)
                    //Constants.removeLoading()
                }
            }
        })
        
        vm?.uploadObserver.bind(completion: { [weak self] response in
            
            self!.view.removeLoader()
            
            if let response = response {
                
                if response.check && response.description == "Completed"{
                    
                    //self?.vc?.view.showProgress(vc: self!.vc!, back: self!.progressView)
                    print(response.description)
                    //Constants.removeLoading()
                    if !self!.dCheck {
                        /*for link in self!.urls! {
                            let p = link.path.split(separator: "/")
                            Service.shared.backgroundUpload(fileURL: link, path: "\(self!.selectedui!.title.text!)/\(p.last!.lowercased())")
                            self?.dCheck = true
                        }*/
                        self?.vm?.batchUpload(path: "\(self!.selectedui!.title.text!)", files: self!.urls!, track: true)
                    }
                    
                    //showDesc()
                    DispatchQueue.main.async {
                        self!.view.removeLoader()
                        self?.view.showtoast(message2: "Upload is in progress")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            self?.dismiss(animated: true, completion: {[weak self] in
                                //print(self?.presentingViewController)
                                self?.del?.showProgresses()
                            })
                        })
                    }
                    
                }else {
                    //self?.vc?.view.showtoast(message2: response.description)
                    print(response.description)
                    DispatchQueue.main.async {
                        self!.view.removeLoader()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self?.dismiss(animated: true)
                        })
                    }
                    //self?.putTags()
                    //Constants.removeLoading()
                
                }
                
            }
        })
        
        vm?.batchUploadObserver.bind(completion: {[weak self] response in
            
            self!.view.removeLoader()
            
            guard let response = response else {return}
            
            if response.check {
                
                DispatchQueue.main.async {
                    self!.view.removeLoader()
                    self?.view.showtoast(message2: "Upload is complete")
                    
                }
            }else {
                
                DispatchQueue.main.async {
                    self!.view.removeLoader()
                    self?.view.showtoast(message2: response.description)
                    
                }
            }
        })
        
        selectedui?.upload.addTarget(self, action: #selector(uploadAction), for: .touchUpInside)
        selectedui?.delete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        selectedui?.title.delegate = self
        selectedui?.tags.delegate = self
        selectedui?.description.delegate = self
        
    }
    
    @objc func uploadAction() {
      
        if selectedui?.title.text == "" {
            self.view.showtoast(message2: "Please input dance title")
            
        }else if selectedui?.tags.text == "" {
            self.view.showtoast(message2: "Please input tags")
        }else if selectedui?.description.text == "" {
            self.view.showtoast(message2: "Please input dance description")
        }else {
            
            self.view.showLoader()
            vm?.checkExist(rooted: "", folder: Constants.currentUser!.userName.lowercased())
        }
    }
    
    func showDesc() {
        
        
        loaderView.tag = 1
        loaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 32.0, height: 80)
        view.addSubview(loaderView)
        loaderView.backgroundColor = Constants.navyBlue2
        
        let loader = UILabel()
        loader.text = "Upload in progress"
        loader.textColor = .white
        loader.font = Constants.regularFont(size: 14)
        loaderView.addCordinateSubviewToCentre(view: loader, width: 30, height: 30)
        //loader.startAnimating()
    }
    
    func upload() {
        
        for link in urls! {
            
            Service.shared.backgroundUpload(fileURL: link, path: "")
        }
    }
    
    @objc func deleteAction() {
        
        /*if let last = visibleCells.last {
            urls!.remove(at: last)
        }
        
        selectedui?.collectionView?.reloadData()*/
        
        
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    /*func getThumbnail(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let gen = AVAssetImageGenerator(asset: asset)
            gen.appliesPreferredTrackTransform = true
            
            let time = CMTimeMake(value: 7, timescale: 1)
            do {
              
                let image = try gen.copyCGImage(at: time, actualTime: nil)
                let img = UIImage(cgImage: image)
                DispatchQueue.main.async {
                    completion(img)
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }*/
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return urls!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedCell", for: indexPath) as! SelectedCollectionViewCell
        //print(urls![indexPath.row])
        //selectedui?.currentIndex = indexPath.row
        //printContent(selectedui?.currentIndex)
        let link = urls![indexPath.row]
        
        cell.player = AVPlayer(url: link)
        cell.player?.isMuted = true
        //print(urls![indexPath.row])
        //cell.playerLayer.removeFromSuperlayer()
        //player = AVPlayer(url: url)
        cell.playerLayer = AVPlayerLayer(player: cell.player!)
        cell.playerLayer!.frame = cell.bounds
        //print(cell.contentView.frame)
        cell.playerLayer!.videoGravity = .resizeAspectFill
        //cell.contentView.layer.insertSublayer(cell.playerLayer, at: 0)
        DispatchQueue.main.async {
            cell.layer.addSublayer(cell.playerLayer!)
            cell.player!.play()
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        visibleCells.append(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /*for i in 0..<visibleCells.count {
            if visibleCells[i] == indexPath.row {
                visibleCells.remove(at: i)
            }
        }*/
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if keyHeight == 0.0 {
                keyHeight = keyboardSize.height
            }
            self.view.frame.origin.y = -keyHeight
            //danceView.frame.origin.y = vc!.view.frame.height - (keyHeight + danceView.frame.height)
            
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        //danceView.frame.origin.y = (vc!.view.frame.height/2.0) - (danceView.frame.height/2.0)
        self.view.frame.origin.y = 0
        
    }
}

extension SelectedViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            view.endEditing(true)
        }
}


