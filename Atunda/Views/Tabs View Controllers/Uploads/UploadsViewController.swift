//
//  UploadsViewController.swift
//  Atunda
//
//  Created by Mas'ud on 9/14/22.
//

import UIKit
import AVFoundation
import AVKit
import SwiftyDropbox

class UploadsViewController: UIViewController {
    
    var uploadsUI: UploadsUI?
    var viewModel: uploadViewModel?
    
    var homevc : HomeViewController?
    
    var folders: [FileMetaData] = []
    var files: [FileMetaData] = []
    
    var loaderView = UIView()
    let error = UIView()
    
    var pathString = ""
    var folder = ""
    var file = ""
    let txtView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadsUI = UploadsUI(viewController: self)
        uploadsUI?.setup()
        
        viewModel = uploadViewModel()
        // Do any additional setup after loading the view.
        observers()
        setup()
    }
    
    func setup() {
        
        uploadsUI?.moveUp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveUpAPath)))
    }
    
    @objc func moveUpAPath() {
        
        if folder.contains("/") {
            
            var sep = folder.split(separator: "/")
            sep.removeLast()
            let s = sep.joined(separator: "/")
            showLoader()
            folder = s
            viewModel?.readFolders(path: folder)
            
        }else {
            uploadsUI?.moveUp.alpha = 0
            folder = ""
            self.files = folders
            uploadsUI?.tableView.reloadData()
        }
    }
    
    func observers() {
        
        showLoader()
        
        viewModel?.uploadsObject.bind(completion: { [weak self] response in
            
            if let response = response {
                
                if response.check {
                    if let names = response.object as? [FileMetaData] {
                        
                        if !names.isEmpty {
                            
                            DispatchQueue.main.async {
                                
                                self?.loaderView.removeProperly()
                                self?.uploadsUI?.tableView.alpha = 1
                                self?.uploadsUI?.noUploads.removeFromSuperview()
                                
                                if response.description == "folder" {
                                    if  self!.folders.isEmpty {
                                        self?.folders = names
                                        self?.files = names
                                        self?.uploadsUI?.tableView.backgroundColor = .none
                                        self?.uploadsUI?.tableView.reloadData()
                                    }
                                }else {
                                    self?.files = names
                                    self?.uploadsUI?.tableView.reloadData()
                                }
                            }
                            
                            
                        }else {
                            DispatchQueue.main.async {
                                self?.showNoUploads()
                            }
                        }
                    }
                    
                }else {
                    
                    if response.description.contains("not_found") {
                        self?.showNoUploads()
                    }else {
                        self?.view.showtoast(message2: response.description)
                    }
                    
                    self?.loaderView.removeProperly()
                }
            }
        })
        print(Constants.DropboxToken)
        viewModel?.readFolders(path: "")
        
        viewModel?.downloadObject.bind(completion: {[weak self] response in
            
            if let response = response {
                
                if response.check {
                    if let url = response.object as? URL {
                        self?.loaderView.removeProperly()
                        
                        if response.description == downloadType.Video.rawValue || response.description == downloadType.Mov.rawValue {
                            DispatchQueue.main.async {
                                
                                let vc = AVPlayerViewController()
                                let player = AVPlayer(url: url)
                                vc.player = player
                                self?.present(vc, animated: true, completion: {vc.player?.play()})
                            }
                        }else {
                            do {
                                let result = try String(contentsOf: url, encoding: .utf8)
                                self?.showText(text: result)
                            }
                            catch {print(error.localizedDescription); self?.view.showtoast(message2: error.localizedDescription)}
                            
                        }
                    }
                    
                }else {
                    DispatchQueue.main.async {
                        self?.loaderView.removeProperly()
                        self?.view.showtoast(message2: response.description)
                    }
                }
            }
        })
    }
    
    func showText(text: String) {
        
        guard let window = UIApplication.shared.keyWindow else {return}
        
        txtView.backgroundColor = Constants.navyBlue2
        window.addSubview(txtView)
        txtView.constraint(equalToTop: window.topAnchor, equalToBottom: window.bottomAnchor, equalToLeft: window.leadingAnchor, equalToRight: window.trailingAnchor)
        
        let view = UIView()
        view.backgroundColor = Constants.navyBlue
        view.layer.cornerRadius = 12
        txtView.addSubview(view)
        view.constraint(equalToLeft: txtView.leadingAnchor, equalToRight: txtView.trailingAnchor, paddingLeft: 16, paddingRight: 16)
        view.centre(centreY: txtView.centerYAnchor)
        
        let xmark = UIImageView(image: UIImage(systemName: "xmark"))
        xmark.tintColor = .white
        view.addSubview(xmark)
        xmark.constraint(equalToTop: view.topAnchor, equalToRight: view.trailingAnchor, paddingTop: 16, paddingRight: 16, width: 20, height: 20)
        xmark.isUserInteractionEnabled = true
        xmark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeText)))
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.font = Constants.regularFont(size: 14)
        textLabel.textColor = .white
        view.addSubview(textLabel)
        textLabel.constraint(equalToTop: xmark.bottomAnchor, equalToBottom: view.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16)
        
    }
    
    @objc func removeText() {
        
        txtView.removeProperly()
    }
    
    func download(name: String) {
        
        print(name)
        
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent("Downloads")
        
        do{
            let p = name.split(separator: "/").first
            let namePath = logsPath?.appendingPathComponent(String(p!))
            let dir = contentsOfDirectoryAtPath(path: "Documents")
            if !dir!.contains(namePath!.path) {
                //try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.createDirectory(atPath: namePath!.path, withIntermediateDirectories: true, attributes: nil)
                
            }
            
            let path = logsPath?.appendingPathComponent(name)
            
            if let path = path {
                viewModel?.download(path: name, destination: path)
            }
            
        }catch let error as NSError{
            print("Unable to create directory and save file",error)
            self.view.showtoast(message2: error.localizedDescription)
            loaderView.removeProperly()
        }
        
    }
    
    func contentsOfDirectoryAtPath(path: String) -> [String]? {
        let documentDirectory = try? FileManager.default.url(
            for: .documentDirectory,
               in: .userDomainMask,
               appropriateFor: nil,
               create: true
        )
        var folders: [String] = []
        guard let paths = try? FileManager.default.contentsOfDirectory(at: documentDirectory!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {return nil}
        
        for urls in paths{
            let ul = urls.path.components(separatedBy: "/")
            if !ul.last!.contains("mp4") || !ul.last!.contains("mov") {
                folders.append(ul.last!)
            }
            
        }
        return folders //paths.map { aContent in (path as NSString).appendingPathComponent(aContent)}
    }
    
    func contentsOfSpecificDirectories(path: String) -> [String]? {
        let documentDirectory = try? FileManager.default.url(
            for: .documentDirectory,
               in: .userDomainMask,
               appropriateFor: nil,
               create: true
        )
        let url: URL? = URL(fileURLWithPath: documentDirectory!.path + "/\(path)")
        var folders: [String] = []
        guard let url = url else {self.view.showtoast(message2: "URL path not found"); return []}
        guard let paths = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {return nil}
        
        for urls in paths{
            let ul = urls.path
            folders.append(ul)
            
        }
        return folders //paths.map { aContent in (path as NSString).appendingPathComponent(aContent)}
    }
    
    func showLoader() {
        
        loaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(loaderView)
        loaderView.backgroundColor = Constants.navyBlue2
        
        let loader = UIActivityIndicatorView()
        loader.tintColor = Constants.darkPurple
        loader.color = Constants.darkPurple
        loaderView.addCordinateSubviewToCentre(view: loader, width: 30, height: 30)
        loader.startAnimating()
        
    }
    
    func showNoUploads() {
        
        uploadsUI?.tableView.alpha = 0
        
        let noUploads = uploadsUI!.noUploads
        
        self.view.addSubview(noUploads)
        noUploads.constraint(equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingLeft: 16, paddingRight: 16)
        noUploads.centre(centerX: view.centerXAnchor, centreY: view.centerYAnchor)
    }
    
    func setGesture() {
        
        
    }
    
}

extension UploadsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "uploadsCell", for: indexPath) as! UploadsTableViewCell
        //
        cell.delegate = self
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let entry = files[indexPath.row]
        cell.title.text = entry.name
        cell.delegate = self
        if entry.size != nil {
            cell.size.text = entry.sizeText()
        }else {
            entry.getSize(completion: {value in
                
                DispatchQueue.main.async {
                    cell.size.text = value
                }
            })
        }
        
        if entry.type == FileType.folder {
            entry.getNumberOfItems(completion: {items in
                DispatchQueue.main.async {
                    if items == 0 || items == 1 {
                        cell.numberOfVideos.text = "1 File"
                        entry.NumOfItems = 1
                    }else {
                        cell.numberOfVideos.text = String(items) + " File(s)"
                        entry.NumOfItems = items
                    }
                    
                    if items >= 30 {
                        cell.errorView.alpha = 0
                    }else {
                        cell.errorView.alpha = 1
                        
                    }
                }
            })
        }else {
            cell.errorView.alpha = 0
            cell.numberOfVideos.text = "1 file"
        }
        
        return cell
    }
    
    @objc func showError() {
        
        let view = self.view!
        
        view.addSubview(error)
        error.constraint(equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingLeft: 32, paddingRight: 32, height: 200)
        error.centre(centreY: view.centerYAnchor)
        error.layer.cornerRadius = 8
        error.backgroundColor = Constants.pink
        
        let xmark = UIImageView(image: UIImage(systemName: "xmark"))
        xmark.isUserInteractionEnabled = true
        xmark.tintColor = .white
        error.addSubview(xmark)
        xmark.constraint(equalToTop: error.topAnchor, equalToRight: error.trailingAnchor, paddingTop: 8, paddingRight: 8, width: 20, height: 20)
        xmark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeError)))
        
        let message = UILabel()
        message.text = "This dance folder has less than 30 videos"
        message.numberOfLines = 0
        message.textAlignment = .center
        error.addSubview(message)
        message.constraint(equalToLeft: error.leadingAnchor, equalToRight: error.trailingAnchor, paddingLeft: 16, paddingRight: 16)
        message.centre(centreY: error.centerYAnchor)
        
    }
    
    @objc func removeError() {
        
        error.removeProperly()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showLoader()
        
        uploadsUI?.moveUp.alpha = 1
        
        let entry = files[indexPath.row]
        let type = entry.type
        if type == FileType.file {
            
            //showLoader()
            
            if folder == "" {
                
                self.download(name: entry.name)
                file = entry.name
                print(entry.name)
            }else {
               
                self.download(name: folder + "/" + entry.name)
                print(folder + "/" + entry.name)
                //pathString = pathString + "/" + entry.name
            }
        }else {
            
            if folder == "" {
                
                viewModel?.readFolders(path: entry.name)
                folder = entry.name
                print(entry.name)
            }else {
               
                viewModel?.readFolders(path: folder + "/" + entry.name)
                folder = folder + "/" + entry.name
                print(folder + "/" + entry.name)
            }
            
        }
    }
    
}

extension UploadsViewController : errorTapped {
    
    func tapped() {
        showError()
    }
    
}
