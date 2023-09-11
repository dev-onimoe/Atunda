//
//  DropBox.swift
//  Atunda
//
//  Created by Mas'ud on 10/2/22.
//

import Foundation
import SwiftyDropbox

class DropBox {
    
    static let shared = DropBox()
    
    var client : DropboxClient?
    var current = 0
    var meta: Files.FileMetadata?
    var root = ""
    var currentTag = 0
    var uploadCount = 0
    var uuid = UUID()
    var checkUpload = false
    
    init() {
        client = DropboxClient(accessToken: Constants.DropboxToken)
        root = "Atunda/" + Constants.currentUser!.userName.lowercased()
    }
    
    func checkIfExists(rooted: String, name: String, completion: @escaping (Response) -> Void ) {
        
        let root2 = (rooted == "") ? "/Atunda" : "/Atunda/\(rooted)"
        
        client?.files.listFolder(path: root2).response(queue: .main, completionHandler: {[weak self] result, error in
            
            if error == nil {
                
                let res = result!.entries
                let f = Files.Metadata(name: name)
                var check = false
                for e in res {
                    if e.name == f.name {
                        check = true
                    }
                }
                if check == true {
                    completion(Response(check: true, description: rooted))
                }else {
                    
                    if result!.hasMore {
                        self?.client?.files.listFolderContinue(cursor: result!.cursor)
                    }else {
                        
                        if rooted == "" {
                            completion(Response(check: false, description: "root"))
                        }else {
                            completion(Response(check: false, description: "Folder does not exist"))
                        }
     
                    }
                }
                
            }else {
                
                completion(Response(check: false, description: error!.description))
            }
        })
    }
    
    func createFolder(name: String, base: Bool, completion: @escaping (Response) -> Void ) {
        root = "Atunda/" + Constants.currentUser!.userName.lowercased()
        
        let folder = base ? "/\(root)" : "/\(root)/\(name)"
        
        client?.files.createFolderV2(path: folder).response(queue: .main, completionHandler: {result, error in
            
            if let error = error {
                
                completion(Response(check: false, description: error.description))
            }else {
                if base {
                    completion(Response(check: true, description: "root"))
                }else {
                    completion(Response(check: true, description: result!.description))
                }
                
            }
        })
    }
    
    func readFolders(name: String, completion: @escaping (Response) -> Void) {

        let description = (name == "") ? "folder" : "file"
        root = "Atunda/" + Constants.currentUser!.userName.lowercased()
        let path = (name == "") ? "/\(root)" : "/\(root)/\(name)"
        
        
        let token = Constants.DropboxToken
       
        client?.files.listFolder(path: path).response(queue: .main, completionHandler: {[weak self] folderResult, error in
            
            if let error = error {
                
                var desc = ""
                switch error as CallError {
                case .routeError(_, _, let errorSummary, _):
                    //print("RouteError[\(requestId)]:" + "\n" + userMessage + "\n" + errorSummary)
                    //let m = userMessage ?? ""
                    desc = errorSummary!
                    
                default:
                    desc = error.description
                }
                
                completion(Response(check: false, description: desc))
            }else {
                
                guard let result = folderResult else {
                    completion(Response(check: false, description: "Something went wrong", object: []))
                    return
                    
                }
                
                let entries = result.entries
                var ets : [FileMetaData] = []
                
                for entry in entries {
                    
                    if let entry = entry as? Files.FolderMetadata {
                        
                        let file = FileMetaData(name: entry.name, type: FileType.folder)
                        ets.append(file)
                    }else if let entry = entry as? Files.FileMetadata {
                        let file = FileMetaData(name: entry.name, size: Int(entry.size), type: FileType.file)
                        ets.append(file)
                    }
                }
                
                if folderResult!.hasMore {
                    self?.client?.files.listFolderContinue(cursor: folderResult!.cursor)
                }else {
                    
                    completion(Response(check: true, description: description, object: ets))
                }
                
                //let names = entries.map({$0.name})
                
            }
        })
    }
    
    func download(path: String, destinationUrl: URL, completion: @escaping (Response) -> Void) {
        
        root = "Atunda/" + Constants.currentUser!.userName.lowercased()
        
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return destinationUrl
        }
        
        client?.files.download(path: "/\(root)/\(path)", overwrite: true, destination: destination)
            .response { response, error in
                if let response = response {
                    print(response)
                    var desc = downloadType.Video.rawValue
                    if path.contains("txt") {
                        desc = downloadType.Text.rawValue
                    }else if path.contains("mov") {
                        desc = downloadType.Mov.rawValue
                    }
                    completion(Response(check: true, description: desc, object: destinationUrl))
                } else if let error = error {
                    print(error)
                    completion(Response(check: false, description: error.description))
                }
            }
        
    }
    
    func upload(path: String, file: URL?, track: Bool, fileData: Data?, completion: @escaping (Response, ProgressData?) -> Void ) {
        
        
        var fl = Data()
        
        if let url = file {
            do {
                fl = try Data(contentsOf: url)
            } catch  {
                print(error.localizedDescription)
            }
        }else {
            if fileData != nil {
                fl = fileData!
            }
            
        }
        
        root = "Atunda/" + Constants.currentUser!.userName.lowercased()
        
        
        let request = client?.files.upload(path: "/\(root)/\(path)", mode: .overwrite, autorename: false, clientModified: nil, mute: true, input: fl).response(queue: .main, completionHandler: { input, error in
            print(path)
            
            if let error = error {
                var desc = ""
                
                switch error as CallError {
                case .routeError(let boxed, let userMessage, let errorSummary, let requestId):
                    //print("RouteError[\(requestId)]:" + "\n" + userMessage + "\n" + errorSummary)
                    //let m = userMessage ?? ""
                    desc = "RouteError[\(requestId)]:" + "\n" + userMessage! + "\n" + errorSummary!
                    
                default:
                    desc = error.description
                }
                
                completion(Response(check: false, description: desc), nil)
                //self!.meta = input!
            }else {
                
                completion(Response(check: true, description: "Completed"), nil)
            }
        })
        
        if track {
            
            request!.progress({ progressData in
                
                progressData.resume()
                
                
                var prgs = Constants.progresses + []
                var check = false
                
                for p in Constants.progresses {
                    if p.hash == progressData.hashValue {
                        let index = p.index
                        prgs.remove(at: p.index)
                        let n = ProgressData(fractionCompleted: progressData.fractionCompleted, hash: progressData.hashValue, index: prgs.count, url: URL(string: "file:///" + path), videoNumber: 1)
                        prgs.insert(n, at: index)
                        check = true
                    }
                }
                
                if !check {
                    prgs.append(ProgressData(fractionCompleted: progressData.fractionCompleted, hash: progressData.hashValue, index: prgs.count, url: URL(string: "file:///" + path), videoNumber: 1))
                }
                Constants.progresses = prgs
                print(progressData.fractionCompleted)
                
                //completion(Response(check: true, description: "upload is in progress"), ProgressData(fractionCompleted: progressData.fractionCompleted, hash: progressData.hashValue, index: prgs.count))
                
                
            })
        }
    }
    
    func batchUpload(path: String, files: [URL], track: Bool, completion: @escaping (Response, ProgressData?) -> Void ) {
        
        root = "Atunda/" + Constants.currentUser!.userName.lowercased()
        
        let datas = files.map({file -> Data in
            if (try? Data(contentsOf: file)) == nil {
                return try! Data(contentsOf: file)
            }else {
                return Data()
            }
            
        })
        
        var filesCommitInfo = [URL : Files.CommitInfo]()
        var count = 0
        for file in files {
            //let fileUrl: URL! = URL(string: "file://\(filePath)")
            let name = path + String(count)
            let uploadToPath = "/\(file.lastPathComponent)"
            filesCommitInfo[file] = Files.CommitInfo(path: "/\(root)/\(path)\(uploadToPath)", mode: Files.WriteMode.overwrite)
            count += 1
        }
        
        if !checkUpload {
            
            Constants.progresses.append((ProgressData(fractionCompleted: 0.0, hash: uuid.hashValue, index: Constants.progresses.count, url: URL(string: "file:///" + path), videoNumber: files.count)))
            
            
            let request = client?.files.batchUploadFiles(fileUrlsToCommitInfo: filesCommitInfo, progressBlock: { progress in
                print("Progress: \(progress)")
            }, responseBlock: {[weak self] fileUrlsToBatchResultEntries, finishBatchRequestError, fileUrlsToRequestErrors in
                if let fileUrlsToBatchResultEntries = fileUrlsToBatchResultEntries {
                    for (clientSideFileUrl, resultEntry) in fileUrlsToBatchResultEntries {
                        switch resultEntry {
                        case .success(let metadata):
                            self?.uploadCount += 1
                            
                            let dropboxFilePath = metadata.pathDisplay!
                            print("File successfully uploaded from \(clientSideFileUrl.absoluteString) on local machine to \(dropboxFilePath) in Dropbox.")
                            
                            let fileCount = files.count
                            let fraction = Double(self!.uploadCount) / Double(fileCount)
                            var prgs = Constants.progresses + []
                            var check = false
                            
                            for p in Constants.progresses {
                                if p.hash == self!.uuid.hashValue {
                                    let index = p.index
                                    prgs.remove(at: p.index)
                                    let n = ProgressData(fractionCompleted: fraction, hash: self!.uuid.hashValue, index: prgs.count, url: URL(string: "file:///" + path), videoNumber: files.count)
                                    prgs.insert(n, at: index)
                                    check = true
                                }
                            }
                            
                            
                            if self?.uploadCount == fileCount {
                                completion(Response(check: true, description: "Completed"), nil)
                            }
                            Constants.progresses = prgs
                            //print(progressData.fractionCompleted)
                        case .failure(let error):
                            // This particular file was not uploaded successfully, although the other
                            // files may have been uploaded successfully. Perhaps implement some retry
                            // logic here based on `uploadError`
                            completion(Response(check: false, description: error.description), nil)
                            print("Error: \(error)")
                        }
                    }
                } else if let finishBatchRequestError = finishBatchRequestError {
                    print("Either bug in SDK code, or transient error on Dropbox server: \(finishBatchRequestError)")
                } else if fileUrlsToRequestErrors.count > 0 {
                    print("Other additional errors (e.g. file doesn't exist client-side, etc.).")
                    print("\(fileUrlsToRequestErrors)")
                }
            })
            
            checkUpload = true
        }
        
    }
    
}

struct ProgressData{
    
    var fractionCompleted: Double
    var hash: Int
    var index: Int
    var url: URL?
    var videoNumber : Int
}

enum downloadType : String{
    
    case Text = ".txt"
    case Video = ".mp4"
    case Mov = ".mov"
}
