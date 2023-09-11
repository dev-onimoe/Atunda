//
//  Service.swift
//  Atunda
//
//  Created by Mas'ud on 9/6/22.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import SwiftyDropbox

class Service: NSObject {
    
    //var description: String
    
    
    static let shared = Service()
    var ref : DatabaseReference?
    let cache = Cache()
    
    //var data : Any?
    
    override init() {
        ref = Database.database().reference()
    }
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "session")
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func Write(path: String, value: Any, completion: @escaping (Response) -> Void) {
        
        //var paths : [String.SubSequence] = []
        
        /*if path.contains("/") {
            
            paths = path.split(separator: "/")
            //ref = Database.database().reference()
            for path in paths {
                
                ref = ref.child(String(path))
            }
            
        }else {
            ref = ref.child(String(path))
        }*/
        var ref = Database.database().reference()
        ref = ref.child(path)
        //print(path)
        ref.setValue(value, withCompletionBlock: {error, ref in
            
            if let err = error {
                completion(Response(check: false, description: err.localizedDescription))
            }else {
                completion(Response(check: true, description: "Success"))
            }
        })
    }
    
    func Read(path: String, completion: @escaping (DataSnapshot) -> Void) {
        
        /*var paths : [String.SubSequence] = []
        
        if path.contains("/") {
            
            paths = path.split(separator: "/")
            //ref = Database.database().reference()
            for path in paths {
                
                ref = ref.child(String(path))
            }
            
        }else {
            ref = ref.child(String(path))
        }*/
        var ref = Database.database().reference()
        ref = ref.child(path)
        
        ref.getData(completion: {error, snapshot in
            
            if let error = error {
                print(error)
            }else {
                print(snapshot)
                completion(snapshot)
            }
            
        })
    }
    
    func checkUsername(username : String, completion: @escaping (Response, String) -> Void) {
        
        var check = false
        var email = "Username not found"
        var id = ""
        
        Read(path: "Users", completion: {snapshot in
            
            if snapshot.hasChildren() {
                let children = snapshot.value as! [String : Any]
                let usr = children.map({dict -> User in
                    let user = User()
                    user.fromDict(dict: dict.value as! [String : Any])
                    return user
                })
                for user in usr {
                    if user.userName.lowercased() == username.lowercased() {
                        check = true
                        email = user.email
                        id = user.id
                    }
                }
            }
            if check {
                completion(Response(check: check, description: email), id)
            }else {
                email = "Could not retrieve your data, something went wrong"
                completion(Response(check: check, description: email), id)
            }
            
        })
    }
    
    func getUser(username : String, id: String, completion: @escaping (Response, User?) -> Void, login: Bool) {
        
        var ref = Database.database().reference()
        ref = ref.child("Users/" + id)
        self.ref = ref
        let handle = ref.observe(.value, with: {[weak self] snapshot in
            
            if snapshot.exists() {
                let user = snapshot.value as! [String: Any]
                let usr = User()
                usr.fromDict(dict: user)
                Constants.currentUser = usr
                self?.cache.cacheData(data: usr, key: "user")
                
                completion(Response(check: true, description: "Success"), usr)
            
            }else {
                
                completion(Response(check: false, description: "Failure"), nil)
                
                
            }
        })
        
        /*Read(path: "Users/" + id, completion: {snapshot in
            
            if snapshot.exists() {
                let user = snapshot.value as! [String: Any]
                let usr = User()
                usr.fromDict(dict: user)
                completion(Response(check: true, description: "Success"), usr)
            }else {
                completion(Response(check: false, description: "Failure"), nil)
            }
            
        })*/
    }
    
    func uploadProfileImage(data: Data,completion: @escaping (Response) -> Void) {
        
        let storage = Storage.storage()
        let ref = storage.reference().child("profilePicture/\(Constants.currentUser!.userName)/0.jpg")
        
        _ = ref.putData(data, metadata: nil, completion: { meta, error in
            
            if let error = error {
                
                completion(Response(check: false, description: error.localizedDescription))
                return
            }
            
            ref.downloadURL(completion: { [weak self] url, error in
                
                if let url = url {
                    print(url.absoluteString)
                    
                    self?.Write(path: "Users/\(Constants.currentUser!.id)/profileImage", value: url.absoluteString, completion: {response in
                        
                        if response.check {
                            
                            completion(Response(check: true, description: "Success"))
                        }else {
                            completion(Response(check: false, description: response.description))
                        }
                    })
                }
            })
        })
    }
    
    func download(completion: @escaping (Data) -> Void) {
        
        guard let url = Constants.currentUser?.profileImage else {return}
        
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = true
        config.waitsForConnectivity = true
        let sesh = URLSession(configuration: config)
        
        let uurl = URL(string: url)
        
        if let uurl = uurl {
            
            let url1 = URLRequest(url: uurl)
            
            let data = sesh.dataTask(with: url1) {data, _, error in
                
                if let error = error {print(error); return}else {
                    
                    guard let data3 = data else {print("No data was returned"); return}
                    completion(data3)
                }
            }
            data.resume()
            
        }
    }
    
    func getToken() {
        
        /*if self.cache.exists(key: "appKey") {
            let username = cache.retrieve(key: "appKey") as! String //"28vp20gyhglt7fc"
            let password = cache.retrieve(key: "appSecret") as! String //"e4meqm59ra2h8hy"
            let token = cache.retrieve(key: "refreshToken") as! String
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            tokenRequest(data: base64LoginString, token: token)
            
        }else {
            
            Read(path: "AppData", completion: {[weak self] snapshot in
                
                if snapshot.hasChildren() {
                    
                    let children = snapshot.value as! [String : String]
                    
                    let username = children["appKey"] //"28vp20gyhglt7fc"
                    let password = children["appSecret"] //"e4meqm59ra2h8hy"
                    self?.cache.cacheData(data: username, key: "appKey")
                    self?.cache.cacheData(data: password, key: "appSecret")
                    self?.cache.cacheData(data: children["refreshToken"], key: "refreshToken")
                    let loginString = String(format: "%@:%@", username!, password!)
                    let loginData = loginString.data(using: String.Encoding.utf8)!
                    let base64LoginString = loginData.base64EncodedString()
                    
                    self?.tokenRequest(data: base64LoginString, token: children["refreshToken"]!)
                    
                }
                
            })
            
            
        }*/
        
        Read(path: "AppData", completion: {[weak self] snapshot in
            
            if snapshot.hasChildren() {
                
                let children = snapshot.value as! [String : String]
                
                let username = children["appKey"] //"28vp20gyhglt7fc"
                let password = children["appSecret"] //"e4meqm59ra2h8hy"
                self?.cache.cacheData(data: username, key: "appKey")
                self?.cache.cacheData(data: password, key: "appSecret")
                self?.cache.cacheData(data: children["refreshToken"], key: "refreshToken")
                let loginString = String(format: "%@:%@", username!, password!)
                let loginData = loginString.data(using: String.Encoding.utf8)!
                let base64LoginString = loginData.base64EncodedString()
                
                self?.tokenRequest(data: base64LoginString, token: children["refreshToken"]!)
                
            }
            
        })
        
        
    }
    
    func tokenRequest(data: String, token: String) {
        
        // create the request
        let url = URL(string: Constants.tokenUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        let headers = ["Content-Type" : "application/x-www-form-urlencoded", "Authorization" : "Basic \(data)"]
        request.allHTTPHeaderFields = headers
       
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "grant_type", value: "refresh_token"), URLQueryItem(name: "refresh_token", value: token)]
        request.httpBody = components.query?.data(using: .utf8)
        
        let sesh = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            
            if error == nil {
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse)
                    if httpResponse.statusCode == 200 {
                        guard let data = data else {return}
                        do {
                            let jsonRes = try JSONDecoder().decode(TokenBody.self, from: data)
                            let token = jsonRes.access_token
                            Constants.DropboxToken = token
                            
                        } catch {
                            print(error)
                        }
                        
                    }else {
                        guard let data = data else {return}
                        do {
                            let jsonRes = try JSONDecoder().decode(TokenError.self, from: data)
                            
                            
                        } catch {
                            print(error)
                            print(String(httpResponse.statusCode)+": "+httpResponse.description)
                            
                        }
                        
                    }
                }
                
            }else {
                print(error!.localizedDescription)
                
            }
        }).resume()
    }
    
    func backgroundUpload(fileURL: URL, path: String) {
        
        let urlBuilder = URLComponents(string: Constants.uploadUrl)
        guard let url = urlBuilder?.url else { return }
        let beg = "/\(Constants.currentUser!.userName)/\(path)"
        
        //let dict : [String: Any] = ["autorename" : true, "path" : path]
        //let data = try? JSONSerialization.data(withJSONObject: dict)
        
        //guard let data = try? Data(contentsOf: fileURL) else {return}
        
        let data = "".data(using: .utf8)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer " + Constants.DropboxToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.setValue("{\"autorename\" : true, \"path\" : \(beg)}", forHTTPHeaderField: "Dropbox-API-Arg")
        request.httpBody = data
        
        _ = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            
            if error == nil {
                
                
                
            }else {
                let error = error!
                print(error.localizedDescription)
                
            }
        }).resume()
        
        /*let backgroundTask = urlSession.uploadTask(with: request, fromFile: fileURL)
        backgroundTask.resume()*/
    }
    
    func downloadProfileImage(completion: @escaping (Data) -> Void) {
        
        if let ref = self.ref {
            
            ref.removeAllObservers()
            let cache = Cache()
            getUser(username: Constants.currentUser!.userName, id: Constants.currentUser!.id, completion: {response, user in
                
                if response.check {
                    
                    if let url = Constants.currentUser?.profileImage {
                        
                        let config = URLSessionConfiguration.ephemeral
                        config.allowsCellularAccess = true
                        config.waitsForConnectivity = true
                        let sesh = URLSession(configuration: config)
                        
                        let uurl = URL(string: url)
                        
                        if let uurl = uurl {
                            
                            let url1 = URLRequest(url: uurl)
                            
                            let data = sesh.dataTask(with: url1) {data, _, error in
                                
                                if let error = error {print(error); return}else {
                                    
                                    guard let data3 = data else {print("No data was returned"); return}
                                    completion(data3)
                                }
                            }
                            data.resume()
                            
                        }
                    }
                }
                
            }, login: false)
        }
        
    }
}

extension Service: URLSessionDelegate, URLSessionTaskDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
                if let backgroundCompletionHandler = appDelegate.backgroundCompletionHandler {
                    backgroundCompletionHandler()
                } 
            }
            
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print(error)
        }else {
            print("Success")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
    }
}

class Response {
    
    var check : Bool
    var description : String
    var object: Any?
    
    init(check : Bool, description : String, object : Any? = nil) {
        self.check = check
        self.description = description
        self.object = object
    }
}
