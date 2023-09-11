//
//  ModeViewController.swift
//  Atunda
//
//  Created by Mas'ud on 9/9/22.
//

import UIKit
import PhotosUI

class ModeViewController: UIViewController, PHPickerViewControllerDelegate {
    
    var modeUi : ModeUi?
    var urls: [URL] = []
    
    var progressView : UIView?
    var homevc : HomeViewController?
    
    let viewModel = ModeViewModel()
    let cache = Cache()
    
    //let progressView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        modeUi = ModeUi(vc: self)
        modeUi?.setup()
        bind()
        //Constants.progresses.append(ProgressData(fractionCompleted: 0.6, hash: 1011, index: 0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cache.exists(key: "appKey") {
            if Constants.DropboxToken == "" {
                let username = cache.retrieve(key: "appKey") as! String //"28vp20gyhglt7fc"
                let password = cache.retrieve(key: "appSecret") as! String //"e4meqm59ra2h8hy"
                let token = cache.retrieve(key: "refreshToken") as! String
                let loginString = String(format: "%@:%@", username, password)
                let loginData = loginString.data(using: String.Encoding.utf8)!
                let base64LoginString = loginData.base64EncodedString()
                
                Service.shared.tokenRequest(data: base64LoginString, token: token)
                
            }
            
        }else {
            Service.shared.getToken()
        }
        Constants.tableView.delegate = self
        modeUi?.loaderView.removeProperly()
        progressView = UIView()
        progressView?.isUserInteractionEnabled = true
    }
    
    func bind() {
        
        viewModel.downloadObserver.bind(completion: {[weak self] data in
            
            if let data = data {
                
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.modeUi?.pic.image = image
                }
            }else {
                
                //self?.view.showtoast(message2: "No data was returned")
            }
        })
        
        viewModel.downloadPicture()
        
    }
    
    func dataFileSize(data: NSData?) -> String {
        
          if let data = data {
              
              let byte = data.count
              let mb = byte/1000000
              if mb < 1024 {
                  return String(mb) + "mb"
              }else {
                  return String(mb/1000) + "gb"
              }
          }else {
              return ""
          }
        
    }
    
    func dataFileName(url: URL?) -> String {
        
        if let url = url {
            let path = url.path
            let paths = path.split(separator: "/")
            var parent = ""
            if paths.count > 1 {
                parent = String(paths[paths.count - 2])
            }
            
            let rtn = String(paths.last!)
            return parent + rtn
        }else {
            return ""
        }
        
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func showProgress() {
        
        let close = UIImageView(image: UIImage(systemName: "x.circle"))
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeProgress)))
        
        homevc!.view.showProgress(back: progressView!, close: close)
    }
    
    @objc func removeProgress() {
        
        self.progressView!.removeProperly()
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if !results.isEmpty {
            picker.view.showLoader()
            var count = 0
            urls.removeAll()
            print(urls)
            for result in results {
                
                let itemProvider = result.itemProvider
                itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier, completionHandler: {[weak self] url, error in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            picker.dismiss(animated: true)
                            self?.view.showtoast(message2: error.localizedDescription)
                        }
                    }else {
                        
                        if !FileManager.default.fileExists(atPath: url!.path) {
                            print("file does not exist")
                            return
                        }
                        
                        let fileName = "\(Int(Date().timeIntervalSince1970))_\(self!.randomString(length: 4)).\(url!.pathExtension)"
                        // create new URL
                        let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
                        // copy item to APP Storage
                        try? FileManager.default.copyItem(at: url!, to: newUrl)
                        
                        self?.urls.append(newUrl)
                        
                        /*if let url = url {
                            self?.urls.append(url)
                        }*/
                        count += 1
                        if count == results.count {
                           
                            DispatchQueue.main.async {
                                picker.dismiss(animated: true)
                                
                                let vc = SelectedViewController()
                                vc.modalPresentationStyle = .fullScreen
                                vc.urls = self?.urls
                                vc.del = self
                                self?.present(vc, animated: true)
                            }
                        }
                    }
                })
            }
            
        }else {
            picker.dismiss(animated: true)
        }
        view.removeLoader()
    }
    
    
}

extension ModeViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.progresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "capture", for: indexPath) as! CaptureTableViewCell
        let progress = Constants.progresses[indexPath.row]
        let fileData : NSData?
        if let url = progress.url {
            fileData = NSData(contentsOf: url)
            cell.fileSize.text = dataFileSize(data: fileData)
        }
        cell.videoNumber.text = String(progress.videoNumber) + " Video(s)"
        cell.progress.text = String(Int(progress.fractionCompleted * 100)) + "%"
        
        cell.title.text = dataFileName(url: progress.url)
        DispatchQueue.main.async {
            cell.moveBar(fraction: progress.fractionCompleted)
        }
        return cell
    }
    
}

extension ModeViewController : showUploads {
    func showProgresses() {
        showProgress()
    }
    
}
