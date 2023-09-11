//
//  CaptureUI.swift
//  Atunda
//
//  Created by Mas'ud on 9/15/22.
//

import Foundation
import AVFoundation
import UIKit
import FirebaseDatabase
import WebKit
import SwiftyDropbox

class CaptureUI {
    
    var viewModel : CaptureViewModel?
    
    var keyHeight = 0.0
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var notifications = UIImageView()
    var play = UIImageView()
    var field = UITextField()
    var danceView = UIView()
    var captureSession: AVCaptureSession!
    var videoOutput: AVCaptureMovieFileOutput?
    var videoInput: AVCaptureDeviceInput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice?
    var session: AVCaptureDevice.DiscoverySession?
    let timerLabel = UILabel()
    var captureDeviceVideoFound: Bool = false
    var captureDeviceAudioFound:Bool = false
    var create = false
    var tableView : UITableView?
    
    var smallVideo: UIView?
    var largeVideo: UIView?
    let loadView2 = UIView()
    var webViewUnderlay = UIView()
    var descriptionField : UITextField?
    var tagField : UITextField?
    var link: URL?
    var savedCurrentVideo = ""
    var fView = UIView()
    var progressView = UIView()
    let thumbnail = UIImageView()
    
    var timer: Timer?
    var isRecording = false
    var isPlaying = false
    
    var tags = ""
    var description = ""
    
    var dancePath = ""
    var donePressed = 0
    
    var rec = UIImageView()
    
    var vc : CaptureViewController?
    
    init(vc: CaptureViewController) {
        self.vc = vc
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        viewModel = CaptureViewModel()
        
    }
    
    func setupObservers() {
        
        tableView = UITableView()
        Constants.tableView.delegate = vc
        Constants.tableView.dataSource = vc
        Constants.tableView.backgroundColor = Constants.pink
        Constants.tableView.register(CaptureTableViewCell.self, forCellReuseIdentifier: "capture")
        
        viewModel?.checkObserver.bind(completion: { [weak self] response in
            if let response = response {
                
                if response.check {
            
                    if response.description == "" {
                        self!.viewModel?.checkExist(rooted: "/\(Constants.currentUser!.userName.lowercased())", folder: self!.dancePath.lowercased())
                    }else {
                        let pth = self!.link!.path.split(separator: "/")
                        self?.viewModel?.upload(path: "\(self!.dancePath.lowercased())/\(pth.last!.lowercased())", file: self!.link!, fileData: nil, track: true)
                        self?.putUploadIndicator()
                        Constants.removeLoading()
                    }
                }else {
                    
                    //self?.vc?.view.showtoast(message2: response.description)
                    if response.description == "Folder does not exist" {
                        self?.viewModel?.createFolder(danceTitle: self!.dancePath.lowercased(), base: false)
                        
                    }else if response.description == "root" {
                        
                        self?.viewModel?.createFolder(danceTitle: self!.dancePath.lowercased(), base: true)
                    }else {
                        self?.vc?.view.showtoast(message2: response.description)
                        Constants.removeLoading()
                        print(response.description)
                    }
                }
            }
        })
        
        viewModel?.createObserver.bind(completion: { [weak self] response in
            
            if let response = response {
                
                if response.check {
                    
                    if response.description == "root" {
                        self?.viewModel?.createFolder(danceTitle: self!.dancePath.lowercased(), base: false)
                    }else {
                        let pth = self!.link!.path.split(separator: "/")
                        self?.create = true
                        self?.viewModel?.upload(path: "\(self!.dancePath.lowercased())/\(pth.last!.lowercased())", file: self!.link!, fileData: nil, track: true)
                        self?.putUploadIndicator()
                        Constants.removeLoading()
                    }
              
                }else {
                    self?.vc?.view.showtoast(message2: response.description)
                    Constants.removeLoading()
                }
            }
        })
        
        viewModel?.uploadObserver.bind(completion: { [weak self] response in
            
            if let response = response {
                
                if !response.check && response.description != "Completed"{
                    
                    //self?.vc?.view.showProgress(vc: self!.vc!, back: self!.progressView)
                    print(response.description)
                    Constants.removeLoading()
                    
                }else {
                    //self?.vc?.view.showtoast(message2: response.description)
                    print(response.description)
                    self?.putTags()
                    Constants.removeLoading()
                
                }
                
            }
        })
    }
    
    func putUploadIndicator() {
        
        showProgress()
        
        let text = UILabel()
        text.textColor = .white
        text.font = Constants.regularFont(size: 12)
        text.text = "Video is uploading..."
        self.largeVideo!.addSubview(text)
        text.centre(centerX: self.largeVideo!.centerXAnchor, centreY: self.largeVideo!.centerYAnchor)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute:  {
            text.removeFromSuperview()
        })
    }
    
    @objc func showProgress() {
        
        let close = UIImageView(image: UIImage(systemName: "x.circle"))
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeProgress)))
        
        vc?.view.showProgress2(back: progressView, close: close)
    }
    
    @objc func removeProgress() {
        
        self.progressView.removeProperly()
    }
    
    func putTags() {
        
        if create {
            
            create = false
            
            let tagsData = tags.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            let descData = description.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            self.viewModel?.upload(path: "\(self.dancePath.lowercased())/Tags.txt", file: nil, fileData: tagsData, track: false)
            self.viewModel?.upload(path: "\(self.dancePath.lowercased())/Description.txt", file: nil, fileData: descData, track: false)
            
            /*DropboxClient(accessToken: Constants.DropboxToken).files.upload(path: "/\(self.dancePath.lowercased())/Tags.txt", autorename: false, clientModified: nil, mute: true, input: tagsData).response(queue: .main, completionHandler: { [self] input, error in
                
                if error != nil {
                    
                    print(error)
                    
                }else {
                    
                    print("Tags upload complete")
                    DropboxClient(accessToken: Constants.DropboxToken).files.upload(path: "/\(self.dancePath.lowercased())/Description.txt", mode: .overwrite, autorename: false, clientModified: nil, mute: true, input: descData).response(queue: .main, completionHandler: { input, error in
                        
                        if error != nil {
                            
                            print(error?.description)
                            
                        }else {
                            
                            print("Description upload complete")
                            //let pth = self!.link!.path.split(separator: "/")
                            
                        }
                    })
                }
            })*/
            
            
        }
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            
            let asset = AVAsset(url: path)
            //print(p.path  + "\n" + path)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let cgImage = try generator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func setup() {
        
        setupObservers()
        
        guard let view = vc?.view else {return}
        
        view.backgroundColor = .white
        
        let pic = UIImageView(image: UIImage(named: "Group 4"))
        view.addSubview(pic)
        pic.constraint(equalToTop: view.topAnchor, equalToLeft: view.leadingAnchor, paddingTop: 100, paddingLeft: 16, width: 30, height: 30)
        pic.contentMode = .scaleToFill
        pic.isUserInteractionEnabled = true
        pic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        
        notifications = UIImageView(image: UIImage(named: "circleBack"))
        notifications.tintColor = Constants.darkPurple
        view.addSubview(notifications)
        notifications.constraint(equalToRight: view.trailingAnchor, paddingRight: 16, width: 30, height: 30)
        notifications.centre(centreY: pic.centerYAnchor)
        notifications.isUserInteractionEnabled = true
        notifications.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchCamera)))
        
        
        let bigview = UIView()
        bigview.backgroundColor = .none
        view.addSubview(bigview)
        bigview.constraint(equalToBottom: view.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingBottom: 70, paddingLeft: 32, paddingRight: 32, height: 80)
        
        let midview = UIView()
        bigview.addSubview(midview)
        midview.constraint(width: 70, height: 70)
        midview.centre(centerX: bigview.centerXAnchor, centreY: bigview.centerYAnchor)
        midview.layer.cornerRadius = 35
        midview.backgroundColor = Constants.transparentBlack
        //midview.layer.cornerRadius = 12
        
        
        fView = UIView()
        bigview.addSubview(fView)
        fView.constraint(equalToLeft: view.leadingAnchor, equalToRight: bigview.centerXAnchor, paddingLeft: 32, height: 45)
        fView.centre(centreY: midview.centerYAnchor)
        fView.backgroundColor = Constants.transparentBlack
        fView.layer.cornerRadius = 12
        
        fView.addSubview(self.thumbnail)
        thumbnail.constraint(equalToLeft: self.fView.leadingAnchor, paddingLeft: 32, width: 30, height: 30)
        thumbnail.centre(centreY: self.fView.centerYAnchor)
        thumbnail.isUserInteractionEnabled = true
        thumbnail.tag = 0
        thumbnail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.loadLargeVideo)))
        
        /*let skeleton = UIImageView(image: UIImage(named: "skeleton"))
        fView.addSubview(skeleton)
        skeleton.constraint(equalToLeft: fView.leadingAnchor, paddingLeft: 32, width: 30, height: 30)
        skeleton.centre(centreY: fView.centerYAnchor)
        skeleton.isUserInteractionEnabled = true
        skeleton.tag = 0
        skeleton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showWebView)))*/
        
        let lView = UIView()
        bigview.addSubview(lView)
        lView.constraint(equalToLeft: bigview.centerXAnchor, equalToRight: view.trailingAnchor, paddingRight: 32, height: 45)
        lView.centre(centreY: midview.centerYAnchor)
        lView.backgroundColor = Constants.transparentBlack
        lView.layer.cornerRadius = 12
        
        let brightness = UIImageView(image: UIImage(named: "brightness"))
        lView.addSubview(brightness)
        brightness.constraint(equalToRight: lView.trailingAnchor, paddingRight: 32, width: 30, height: 30)
        brightness.centre(centreY: lView.centerYAnchor)
        
        /*let record = UIView()
         record.backgroundColor = .black
         midview.addSubview(record)
         record.constraint(width: 60, height: 60)
         record.layer.cornerRadius = 30
         record.centre(centerX: midview.centerXAnchor, centreY: midview.centerYAnchor)*/
        
        rec = UIImageView(image: UIImage(named: "record"))
        bigview.addSubview(rec)
        rec.constraint(width: 60, height: 60)
        rec.centre(centerX: midview.centerXAnchor, centreY: midview.centerYAnchor)
        rec.isUserInteractionEnabled = true
        rec.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getDancePath)))
        
    }
    
    @objc func switchCamera() {
        
        captureSession?.beginConfiguration()
        //let currentInput = captureSession?.inputs.first as? AVCaptureDeviceInput
        //captureSession?.removeInput(videoInput!)
        for inputs in captureSession!.inputs {
            captureSession?.removeInput(inputs)
        }
        captureDevice = videoInput?.device.position == .back ? getCamera(with: .front) : getCamera(with: .back)
        do {
            try captureDevice?.lockForConfiguration()
            captureDevice?.isFocusModeSupported(.continuousAutoFocus)
            captureDevice?.unlockForConfiguration()
        } catch  {
            print(error.localizedDescription)
        }
        videoInput = try? AVCaptureDeviceInput(device: captureDevice!)
        captureSession?.addInput(videoInput!)
        let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
        let audioInput = try? AVCaptureDeviceInput(device: audioDevice!)
        
        if captureSession.canAddInput(videoInput!) && captureSession.canAddOutput(videoOutput!) && captureSession.canAddInput(audioInput!) {
            captureSession.addInput(videoInput!)
            captureSession.addOutput(videoOutput!)
            captureSession.addInput(audioInput!)
            setupLivePreview()
        }
        captureSession?.commitConfiguration()
        startSession()
    }
    
    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = (session?.devices.compactMap{$0})
        
        return devices!.filter {
            $0.position == position
        }.first
    }
    
    @objc func showTimer() {
        
        //isRecording = true
        if isRecording {
            timerLabel.text = "00:00:00"
            timerLabel.alpha = 1
            timerLabel.textColor = .white
            timerLabel.font = Constants.regularFont(size: 14)
            vc?.view.addSubview(timerLabel)
            timerLabel.constraint(equalToBottom: rec.topAnchor, paddingBottom: 12)
            timerLabel.centre(centerX: rec.centerXAnchor)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(labelUpdate), userInfo: nil, repeats: true)
            //isRecording = true
            
        }else {
            
            timer!.invalidate()
        }
    }
    
    @objc func labelUpdate() {
        
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss"
        var date = format.date(from: timerLabel.text!)
        let calendar = Calendar.current
        date = calendar.date(byAdding: .second, value: 1, to: date!)
        DispatchQueue.main.async {
            self.timerLabel.text = format.string(from: date!)
        }
        
    }
    
    func initSessions() {
        
        captureSession = AVCaptureSession()
        //captureSession.sessionPreset = .medium
        session = AVCaptureDevice.DiscoverySession.init(deviceTypes:[.builtInWideAngleCamera, .builtInMicrophone], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        captureDevice = session?.devices.compactMap{$0}.filter {
            $0.position == AVCaptureDevice.Position.back
        }.first
        do {
            try captureDevice?.lockForConfiguration()
            captureDevice?.isFocusModeSupported(.continuousAutoFocus)
            captureDevice?.unlockForConfiguration()
        } catch  {
            print(error.localizedDescription)
        }
        captureDeviceVideoFound = true
        startSession()
    }
    
    func startSession() {
        
        if captureDevice == nil {
            let devices = (session?.devices.compactMap{$0})
            for device in devices! {
                
                if (device.hasMediaType(AVMediaType.video)) {
                    
                    captureDevice = device as? AVCaptureDevice //initialize video
                    if captureDevice != nil {
                        print("Capture device found")
                        captureDeviceVideoFound = true;
                    }
                    
                }
            }
        }
        
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice!)
            self.videoOutput = AVCaptureMovieFileOutput()
            //print(self.videoOutput?.outputFileURL)
            let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            if captureSession.canAddInput(videoInput!) && captureSession.canAddOutput(videoOutput!) && captureSession.canAddInput(audioInput) {
                captureSession.addInput(videoInput!)
                captureSession.addOutput(videoOutput!)
                captureSession.addInput(audioInput)
                setupLivePreview()
            }
            //Step 9
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            
            if(self.captureDeviceVideoFound){
                
                self.captureSession.startRunning()
            }else {
                print("video input not found")
            }
            //Step 13
        }
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = (UIScreen.main.bounds)
        }
        
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        vc?.view.layer.insertSublayer(videoPreviewLayer, at: 0)
        
        //Step12
    }
    
    @objc func goBack() {
        
        vc?.dismiss(animated: true)
    }
    
    func recordVideo(path: String, completion: @escaping (URL?, Error?) -> Void) {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            let err = NSError(domain: "No capture session", code: 0, userInfo: nil)
            completion(nil, err)
            return
        }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyy_hh:mm_a"
        let file = df.string(from: date)
        let fileUrl = paths[0].appendingPathComponent( file + ".mp4")
        try? FileManager.default.removeItem(at: fileUrl)
        videoOutput!.startRecording(to: fileUrl, recordingDelegate: vc!)
        print(fileUrl)
        savedCurrentVideo = file + ".mp4"
        isRecording = true
        showTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.timer?.invalidate()
            guard let captureSession = self.captureSession, captureSession.isRunning else {
                let err = NSError(domain: "No capture session", code: 0, userInfo: nil)
                completion(nil, err)
                return
            }
            self.videoOutput!.stopRecording()
            completion(self.videoOutput!.outputFileURL, nil)
        })
        //self.videoRecordCompletionBlock = completion
    }
    
    @objc func getDancePath() {
        
        getDance()
        
    }
    
    @objc func recc() {
        
        if donePressed == 0 {
            
            dancePath = field.text ?? ""
            let dir = contentsOfDirectoryAtPath(path: "Documents")
            
            if !dir!.contains(dancePath.lowercased()) {
                //add description
                field.frame.origin.y = 16
                
                let info = UILabel()
                info.text = "This is a new dance style, please input the tags and description."
                info.textColor = .white
                info.font = Constants.boldFont(size: 8)
                danceView.addSubview(info)
                info.numberOfLines = 0
                info.constraint(equalToTop: field.bottomAnchor, equalToLeft: field.leadingAnchor, equalToRight: field.trailingAnchor, paddingTop: 12, paddingLeft: 0, paddingRight: 16)
                
                tagField = UITextField()
                tagField!.delegate = vc!
                tagField!.borderStyle = .none
                tagField!.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Tags", targetString: "Tags", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))
                //tagField!.layer.cornerRadius = 12
                tagField!.textColor = .white
                //tagField!.font = Constants.regularFont(size: 12)
                
                let tagsView = UIView()
                danceView.addSubview(tagsView)
                tagsView.constraint(equalToTop: info.bottomAnchor, equalToLeft: danceView.leadingAnchor, equalToRight: danceView.trailingAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16, height: 50)
                tagsView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
                tagsView.layer.cornerRadius = 12
                
                tagsView.addSubview(tagField!)
                tagField!.constraint(equalToTop: tagsView.topAnchor, equalToBottom: tagsView.bottomAnchor, equalToLeft: tagsView.leadingAnchor, equalToRight: tagsView.trailingAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8, height: 0)
                
                descriptionField = UITextField()
                descriptionField!.delegate = vc!
                descriptionField!.borderStyle = .none
                descriptionField!.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Description", targetString: "Description", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))//"Username"
                descriptionField!.textColor = .white
                //descriptionField!.layer.cornerRadius = 12
                //descriptionField!.font = Constants.regularFont(size: 12)
                
                let descView = UIView()
                danceView.addSubview(descView)
                descView.constraint(equalToTop: tagsView.bottomAnchor, equalToLeft: danceView.leadingAnchor, equalToRight: danceView.trailingAnchor, paddingTop: 12, paddingBottom: 12, paddingLeft: 16, paddingRight: 16, height: 100)
                descView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
                descView.layer.cornerRadius = 12
                
                descView.addSubview(descriptionField!)
                descriptionField!.constraint(equalToTop: descView.topAnchor, equalToBottom: descView.bottomAnchor, equalToLeft: descView.leadingAnchor, equalToRight: descView.trailingAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8, height: 0)
                
                danceView.frame.size.height = 350
            } else {
                
                if let tagField = tagField {
                    if tags == "" && description == "" {
                        tags = tagField.text ?? "tags"
                        description = descriptionField!.text ?? "description"
                    }
                    
                    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                    let logsPath = documentsPath.appendingPathComponent(dancePath.lowercased())
                    //print(logsPath!)
                    
                    do{
                        let file = "Tags"
                        let path = logsPath?.appendingPathComponent(file + ".txt")
                        try tags.write(toFile: path!.path, atomically: true, encoding: .utf8)
                        
                        let file2 = "Description"
                        let path2 = logsPath?.appendingPathComponent(file2 + ".txt")
                        try description.write(toFile: path2!.path, atomically: true, encoding: .utf8)
                        
                    }catch let error as NSError{
                        print("Unable to save file",error)
                    }
                }
                
                danceView.removeProperly()
                
                recordVideo(path: dancePath, completion: { [weak self] url, error in
                    
                    self?.timerLabel.alpha = 0
                    
                    if let err = error {
                        
                        print(err.localizedDescription)
                    }else if url != nil {
                        
                    self?.link = url!
                    
                    //rec.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getDancePath)))
                        
                        //self?.loadLargeVideo()
                    }else {
                        print("url is empty")
                    }
                })
            }
            donePressed = 1
            
        }else {
            
            if tagField != nil {
                
                if tagField?.text != "" && descriptionField?.text != "" {
                    
                    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                    let logsPath = documentsPath.appendingPathComponent(dancePath.lowercased())
                    
                    do{
                        let dir = contentsOfDirectoryAtPath(path: "Documents")
                        if !dir!.contains(dancePath.lowercased()) {
                            try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
                        }
                        
                        danceView.removeProperly()
                        
                        recordVideo(path: dancePath, completion: { [weak self] url, error in
                            
                            self?.timerLabel.alpha = 0
                            
                            if let err = error {
                                
                                print(err.localizedDescription)
                            }else if url != nil {
                                
                            self?.link = url!
                            
                            //rec.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getDancePath)))
                                
                                //self?.loadLargeVideo()
                            }else {
                                print("url is empty")
                            }
                        })
                        
                        donePressed = 0
                        
                        
                    }catch let error as NSError{
                        print("Unable to create directory and save files",error)
                    }
                    
                }else {
                    
                    vc?.view.showtoast(message2: "Please input tags and description")
                }
                
            }
            
        }
        
        
    }
    
    func getDance() {
        
        guard let view = vc?.view else {return}
        //view.addSubview(danceView)
        view.centreVertically(view: danceView, x: 16, height: 250, width: view.frame.width - 32.0)
        //danceView.constraint(equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingLeft: 16, paddingRight: 16, height: 250)
        danceView.layer.cornerRadius = 12
        danceView.backgroundColor = Constants.darkPurple
        //danceView.centre(centreY: view.centerYAnchor)
        
        field = UITextField()
        danceView.addSubview(field)
        field.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Dance title", targetString: "Dance title", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))
        //field.constraint(equalToLeft: danceView.leadingAnchor, equalToRight: danceView.trailingAnchor, paddingLeft: 16, paddingRight: 16, height: 50)
        danceView.centreVertically(view: field, x: 16, height: 50, width: danceView.frame.width - 32.0)
        field.tintColor = .white
        field.borderStyle = .roundedRect
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.white.cgColor
        field.delegate = vc!
        field.textColor = .white
        //field.font = Constants.regularFont(size: 12)
        field.backgroundColor = Constants.darkPurple
        
        //field.centre(centreY: danceView.centerYAnchor)
        
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        danceView.addSubview(btn)
        btn.backgroundColor = Constants.lightPurple
        btn.layer.cornerRadius = 8
        btn.constraint(equalToBottom: danceView.bottomAnchor, paddingBottom: 16, width: 80, height: 50)
        btn.centre(centerX: danceView.centerXAnchor)
        //btn.isEnabled = false
        btn.isUserInteractionEnabled = true
        btn.addTarget(self, action: #selector(recc), for: .touchUpInside)
        
    }
    
    @objc func loadLargeVideo() {
        
        guard let view = vc?.view else {return}
        self.largeVideo = UIView()
        largeVideo!.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(self.largeVideo!)
        //self.largeVideo.constraint(equalToTop: view.topAnchor, equalToBottom: view.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor)
        self.largeVideo!.backgroundColor = .white
        self.largeVideo!.isUserInteractionEnabled = true
        self.largeVideo!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pausePlay)))
        
        let greyView1 = UIView()
        self.largeVideo!.addSubview(greyView1)
        greyView1.layer.cornerRadius = 4
        greyView1.backgroundColor = Constants.greyTrans
        greyView1.constraint(equalToTop: self.largeVideo!.topAnchor, equalToLeft: self.largeVideo!.leadingAnchor, paddingTop: 70, paddingLeft: 16)
        
        let upload = UIButton()
        self.largeVideo!.addSubview(upload)
        upload.constraint(equalToTop: greyView1.topAnchor, equalToBottom: greyView1.bottomAnchor, equalToLeft: greyView1.leadingAnchor, equalToRight: greyView1.trailingAnchor, paddingTop: 2, paddingLeft: 2, width: 30, height: 30)
        upload.setImage(UIImage(systemName: "square.and.arrow.up.fill"), for: .normal)
        upload.tintColor = .white
        //upload.setTitleColor(Constants.darkPurple, for: .normal)
        //upload.titleLabel?.font = Constants.boldFont(size: 14)
        upload.addTarget(self, action: #selector(self.uploadFunc), for: .touchUpInside)
        
        let greyView2 = UIView()
        self.largeVideo!.addSubview(greyView2)
        greyView2.layer.cornerRadius = 4
        greyView2.backgroundColor = Constants.greyTrans
        greyView2.constraint(equalToTop: greyView1.bottomAnchor, equalToLeft: self.largeVideo!.leadingAnchor, paddingTop: 16, paddingLeft: 16)
        
        let save = UIButton()
        self.largeVideo!.addSubview(save)
        save.constraint(equalToTop: greyView2.topAnchor, equalToBottom: greyView2.bottomAnchor, equalToLeft: greyView2.leadingAnchor, equalToRight: greyView2.trailingAnchor, paddingTop: 2, paddingLeft: 2, width: 30, height: 30)
        save.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        save.tintColor = .white
        //upload.setTitleColor(Constants.darkPurple, for: .normal)
        //upload.titleLabel?.font = Constants.boldFont(size: 14)
        save.addTarget(self, action: #selector(self.saveVideo), for: .touchUpInside)
        
        let greyView3 = UIView()
        self.largeVideo!.addSubview(greyView3)
        greyView3.layer.cornerRadius = 4
        greyView3.backgroundColor = Constants.greyTrans
        greyView3.constraint(equalToTop: self.largeVideo!.topAnchor, equalToRight: self.largeVideo!.trailingAnchor, paddingTop: 70, paddingRight: 16)
        
        let close = UIButton()
        self.largeVideo!.addSubview(close)
        close.constraint(equalToTop: greyView3.topAnchor, equalToBottom: greyView3.bottomAnchor, equalToLeft: greyView3.leadingAnchor, equalToRight: greyView3.trailingAnchor, paddingTop: 2, paddingLeft: 2, width: 30, height: 30)
        close.setImage(UIImage(systemName: "xmark.square.fill"), for: .normal)
        close.tintColor = .white
        //close.setTitleColor(Constants.darkPurple, for: .normal)
        //close.titleLabel?.font = Constants.boldFont(size: 14)
        close.addTarget(self, action: #selector(self.closeFunc), for: .touchUpInside)
        
        
        self.plugVideo(view: self.largeVideo!, url: link!)
        
        play = UIImageView(image: UIImage(systemName: "pause"))
        play.tintColor = Constants.pink
        play.alpha = 0
        self.largeVideo!.addSubview(play)
        play.constraint(width: 80, height: 80)
        play.centre(centerX: self.largeVideo?.centerXAnchor, centreY: self.largeVideo?.centerYAnchor)
        play.isUserInteractionEnabled = true
        play.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pausePlay)))
    }
    
    func plugVideo(view: UIView, url: URL) {
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.frame = view.bounds
        playerLayer!.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(playerLayer!, at: 0)
        //view.layer.addSublayer(playerLayer)
        
        player!.play()
        isPlaying = true
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            self.player?.seek(to: .zero)
            self.player?.play()
        }
        
    }
    
    @objc func uploadFunc() {
        
        saveVideo()
        
        viewModel?.checkExist(rooted: "", folder: Constants.currentUser!.userName.lowercased())
        Constants.showLoading(view: self.largeVideo!)
    }
    
    @objc func saveVideo() {
        
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent(dancePath.lowercased())
        //print(logsPath!)
        
        do{
            let dir = contentsOfDirectoryAtPath(path: "Documents")
            if !dir!.contains(dancePath.lowercased()) {
                try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
            }
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "dd-MM-yyy_hh:mm_a"
            let file = df.string(from: date)
            let path = logsPath?.appendingPathComponent(file + ".mp4")
            //print(path)
            let videoData = try Data(contentsOf: link!)
            try videoData.write(to: path!, options: .atomic)
            //print(path!)
            
            //CustomPhotoAlbum.sharedInstance.save(url: link!)
            
        }catch let error as NSError{
            print("Unable to create directory and save file",error)
        }
        
        /*if let link = link {
         
         do{
         
         let date = Date()
         let df = DateFormatter()
         df.dateFormat = "dd-MM-yyy hh:mm a"
         let file = df.string(from: date)
         if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
         
         print(dir)
         let fileURL = dir.appendingPathComponent(file).appendingPathExtension("mp4")
         let videoData = try Data(contentsOf: link)
         try videoData.write(to: fileURL, options: .atomic)
         }
         
         }catch{
         print("cant write…")
         }
         }else {
         print("no url")
         }*/
    }
    
    @objc func closeFunc() {
        
        largeVideo!.removeProperly()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }
    
    @objc func pausePlay() {
        
        if let player = player {
            if isPlaying {
                self.play.image = UIImage(systemName: "play.fill")
                self.play.alpha = 1
                player.pause()
                isPlaying = false
            }else {
                self.play.image = UIImage(systemName: "pause")
                self.play.alpha = 0
                player.play()
                isPlaying = true
            }
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
            if !ul.last!.contains("mp4") {
                folders.append(ul.last!)
            }
            
        }
        return folders //paths.map { aContent in (path as NSString).appendingPathComponent(aContent)}
    }
    
    /*let searchPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
     
     let allContents = contentsOfDirectoryAtPath(searchPath)*/
    
    func webView(url: String) {
        
        guard let view = vc!.view else {return}
        view.addSubview(webViewUnderlay)
        
        webViewUnderlay.backgroundColor = .white
        
        //webViewUnderlay.alpha = 0
        
        //UIManipulation.shadowBorder(view: inputView2)
        
        webViewUnderlay.constraint(equalToTop: view.topAnchor, equalToBottom: view.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor)
        
        UIView.animate(withDuration: 0.2, animations: {self.webViewUnderlay.alpha = 1})
        
        
        
        
        let web : WKWebView = {
            
            let config = WKWebViewConfiguration()
            
            if #available(iOS 13.0, *) {
                
                let prefs = WKWebpagePreferences()
                config.defaultWebpagePreferences = prefs
                
                if #available(iOS 14.0, *) {
                    prefs.allowsContentJavaScript = true
                } else {
                    // Fallback on earlier versions
                    
                }
            }
            
            let webView = WKWebView(frame: .zero, configuration: config)
            return webView
            
        }()
        
        web.navigationDelegate = self.vc!
        
        
        
        webViewUnderlay.addSubview(web)
        web.constraint(equalToTop: webViewUnderlay.topAnchor, equalToBottom: webViewUnderlay.bottomAnchor, equalToLeft: webViewUnderlay.leadingAnchor, equalToRight: webViewUnderlay.trailingAnchor, paddingTop: 12)
        
        let backImage = UIImageView(image: UIImage(named: "Group 4"))
        webViewUnderlay.addSubview(backImage)
        backImage.constraint(equalToTop: webViewUnderlay.topAnchor, equalToLeft: webViewUnderlay.leadingAnchor, paddingTop: 80, paddingLeft: 24)
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissWebView)))
        
        webViewUnderlay.addSubview(loadView2)
        loadView2.alpha = 0
        loadView2.constraint(height: 70)
        loadView2.centre(centerX: webViewUnderlay.centerXAnchor, centreY: webViewUnderlay.centerYAnchor)
        loadView2.backgroundColor = .white
        UIView.animate(withDuration: 0.3, animations: {self.loadView2.alpha = 1})
        loadView2.shadowBorderBlack()
        
        let arrow = UIImageView()
        
        if #available(iOS 13.0, *) {
            arrow.image = UIImage(systemName: "arrow.clockwise")
        }
        
        loadView2.addSubview(arrow)
        arrow.constraint(equalToLeft: loadView2.leadingAnchor, paddingLeft: 16, width: 40, height: 40)
        arrow.centre(centreY: loadView2.centerYAnchor)
        arrow.tintColor = .darkGray
        
        let loading = UILabel()
        loadView2.addSubview(loading)
        loading.constraint(equalToLeft: arrow.trailingAnchor, equalToRight: loadView2.trailingAnchor, paddingLeft: 16, paddingRight: 16)
        loading.centre(centreY: arrow.centerYAnchor)
        loading.font = UIFont(name: "Roboto-Regular", size: 14)
        loading.text = "Loading..."
        loading.textColor = .darkGray
        
        let url2 = URL(string: url)
        web.load(URLRequest(url: url2!))
        
        
    }
    
    @objc func dismissWebView() {
        
        UIView.animate(withDuration: 0.2, animations: {self.webViewUnderlay.alpha = 0}, completion: {_ in
            self.webViewUnderlay.removeProperly()        })
    }
    
    @objc func showWebView(_ sender: UITapGestureRecognizer) {
        
        let tag = sender.view?.tag
        
        if tag == 0 {
            
            webView(url: "https://research.dwi.ufl.edu/projects/atunda/")
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if keyHeight == 0.0 {
                keyHeight = keyboardSize.height
            }
            danceView.frame.origin.y = vc!.view.frame.height - (keyHeight + danceView.frame.height)
            
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        danceView.frame.origin.y = (vc!.view.frame.height/2.0) - (danceView.frame.height/2.0)
        
    }
}

