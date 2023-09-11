//
//  User.swift
//  Atunda
//
//  Created by Mas'ud on 9/6/22.
//

import Foundation

class User : CustomClass, Codable {
    
    var userName : String = ""
    var email : String = ""
    var password : String = ""
    var compilations : [Compilation]? = nil
    var totalCompilation : Int? = 0
    var joinedOn: String = ""
    var id : String = ""
    var profileImage: String?
    
    func toDict() -> [String : Any] {
        
        var dict : [String:Any] = [:]
        dict["username"] = self.userName
        dict["email"] = self.email
        dict["password"] = self.password
        dict["compilations"] = self.compilations
        dict["totalCompilations"] = self.totalCompilation
        dict["joinedOn"] = self.joinedOn
        dict["id"] = self.id
        dict["profileImage"] = self.profileImage
        return dict
    }
    
    func fromDict(dict: [String: Any]) {
        
        userName = dict["username"] as! String
        email = dict["email"] as! String
        password = dict["password"] as! String
        compilations = dict["compilations"] as! [Compilation]?
        totalCompilation = dict["totalCompilation"] as? Int
        joinedOn = dict["joinedOn"] as! String
        id = dict["id"] as! String
        profileImage = dict["profileImage"] as? String
    }
}

struct TokenError : Codable {
    
    let error : String
    //let error_description : String
}

struct TokenBody : Codable {
    
    let access_token : String
    //let error_description : String
}
