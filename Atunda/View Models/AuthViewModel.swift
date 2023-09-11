//
//  AuthViewModel.swift
//  Atunda
//
//  Created by Mas'ud on 9/6/22.
//

import Foundation
import FirebaseAuth

class AuthViewModel{
    
    let auth = Auth.auth()
    let cache = Cache()
    
    var usersPublished : Observable<Any?> = Observable(nil)
    var signinDone : Observable<Response?> = Observable(nil)
    var signupDone : Observable<Response?> = Observable(nil)
    
    func Signup(username: String, password : String, email: String) {
        
        Service.shared.checkUsername(username: username, completion: {[weak self] response, id in
            
            if response.check {
                self?.signupDone.value = Response(check: false, description: "Username already exists")
            }else {
                
                self?.auth.createUser(withEmail: email, password: password, completion: {[weak self] result, error in
                    
                    if let err = error {
                        print(response.description)
                        self?.signupDone.value = Response(check: false, description: err.localizedDescription)
                        
                    }else {
                        let date = Date()
                        let format = DateFormatter()
                        format.dateFormat = "MMMM dd, yyyy hh:mm a"
                        let user = User()
                        user.email = email
                        user.password = password
                        user.userName = username
                        user.id = (result?.user.uid)!
                        user.joinedOn = format.string(from: date)
                        user.totalCompilation = 0
                        
                        //print()
                        Service.shared.Write(path: "Users/" + user.id, value: user.toDict(), completion: {[weak self] response in
                            
                            
                            Constants.currentUser = user
                            self?.cache.cacheData(data: user, key: "user")
                            self?.signupDone.value = Response(check: true, description: "Success")
                            
                        })
                    }
                })
            }
        })
    }
    
    func Login(username: String, password : String) {
        
        Service.shared.checkUsername(username: username, completion: {[weak self] response, id in
            
            if response.check {
                
                Service.shared.getUser(username: username, id: id, completion: {[weak self] response, user in
                    
                    if let usr = user {
                        if password == usr.password {
                            self?.auth.signIn(withEmail: usr.email, password: password, completion: {[weak self] result, error in
                                
                                self?.signinDone.value = Response(check: true, description: "Success")
                                self?.cache.cacheData(data: usr, key: "user")
                            })
                        }else {
                            self?.signinDone.value = Response(check: false, description: "Incorrect password")
                        }
                    }else {
                        self?.signinDone.value = Response(check: false, description: "User does not exist")
                    }
                }, login: true)
                
                
            }else {
                
                self?.signinDone.value = Response(check: false, description: response.description)
                
            }
        })
    }
    
    
}
