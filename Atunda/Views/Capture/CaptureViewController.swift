//
//  CaptureViewController.swift
//  Atunda
//
//  Created by Mas'ud on 9/15/22.
//

import UIKit
import AVFoundation
import WebKit

class CaptureViewController: UIViewController {
    
    var cap:CaptureUI?
    let cache = Cache()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cap = CaptureUI(vc: self)
        cap?.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cap?.initSessions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let path = cache.retrieve(key: "lastVideo") as? String {
            let url = URL(fileURLWithPath: path)
            
            cap!.thumbnail.image = cap!.generateThumbnail(path: url)
            cap!.link = url
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cap?.timer?.invalidate()
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
}

extension CaptureViewController: AVCaptureFileOutputRecordingDelegate, UITextFieldDelegate  {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if let err = error {
            
            print(error?.localizedDescription)
        }else {
            
            print(outputFileURL)
            cap!.thumbnail.image = cap!.generateThumbnail(path: outputFileURL)
            cache.cacheData(data: outputFileURL.path, key: "lastVideo")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            view.endEditing(true)
        }
}

extension CaptureViewController: WKNavigationDelegate  {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        cap!.loadView2.removeFromSuperview()
    }
}

extension CaptureViewController: UITableViewDelegate, UITableViewDataSource  {
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
