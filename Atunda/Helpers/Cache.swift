//
//  Cache.swift
//  Atunda
//
//  Created by Mas'ud on 9/14/22.
//

import Foundation

class CustomClass {}

class Cache {
    
    let defaults = UserDefaults.standard
    
    func cacheData<T:Encodable>(data: T, key: String) {
        //let t = T.self
        
        if data is CustomClass {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(data)
                defaults.set(data, forKey: key)
            } catch  {
                print(error.localizedDescription)
            }
        }else {
            defaults.set(data, forKey: key)
        }
        
       
    }
    
    func retrieveData<Object>(key: String, castTo type: Object.Type) -> Object? where Object: Decodable {
        var obj : Object? = nil
        guard let data = defaults.object(forKey: key)else { print("no data for key provided")
            return nil}
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(type, from: data as! Data)
                obj = object
            } catch {
                print(error.localizedDescription)
        }
        return obj
    }
    
    func retrieve(key: String) -> Any? {
        
        return defaults.object(forKey: key)
    }
    
    /*func retrieveData<Object: Decodable>(type: Object.Type, key: String) -> Object? {
        
        var obj : Object? = nil
        var ac : AnyClass = User.self
        if ac is User.Type {
            let decoder = JSONDecoder()
            do {
                let data = defaults.object(forKey: key)
                let obj2 = try decoder.decode(User.self, from: data as! Data)
                defaults.set(data, forKey: key)
            } catch  {
                print(error.localizedDescription)
            }
            
        }else {
            
            obj = defaults.object(forKey: key) as? Object
        }
        
        return obj
    }*/
    
    func exists(key: String) -> Bool {
        
        if defaults.object(forKey: key) != nil {
            return true
        }else {
            return false
        }
    }
}
