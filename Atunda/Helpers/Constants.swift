//
//  Constants.swift
//  Atunda
//
//  Created by Mas'ud on 9/5/22.
//

import Foundation
import UIKit

class Constants{
    
    static var progresses: [ProgressData] = [] {
        didSet {
            if !progresses.isEmpty {
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
            
            //print(progresses.first)
        }
    }
    static var currentUser : User? 
    
    static var loadView = UIView()
    static var base = UIView()
    
    static var tableView = UITableView()
    //tableView.register(CaptureTableViewCell.self, forCellReuseIdentifier: "capture")

    static let pink = UIColor(red: 204/255, green: 44/255, blue: 144/255, alpha: 1)
    static let navyBlue = UIColor(red: 34/255, green: 10/255, blue: 126/255, alpha: 1)
    static let navyBlue2 = UIColor(red: 34/255, green: 52/255, blue: 122/255, alpha: 0.5)
    static let lightBlue = UIColor(red: 24/255, green: 8/255, blue: 83/255, alpha: 1)
    static let transparentWhite = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
    static let transparentBlack = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
    static let lightPurple = UIColor(red: 57/255, green: 17/255, blue: 206/255, alpha: 1)
    static let darkPurple = UIColor(red: 14/255, green: 7/255, blue: 64/255, alpha: 1)
    static let darkPurpleTrans = UIColor(red: 14/255, green: 7/255, blue: 64/255, alpha: 0.5)
    static let greyTrans = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 0.5)
    
    static var DropboxToken = ""
    
    static let uploadUrl = "https://content.dropboxapi.com/2/files/upload"
    static let tokenUrl = "https://api.dropboxapi.com/oauth2/token"
    
   
    static func boldFont(size : CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size)!
    }
    
    static func regularFont(size : CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
    
    static var completion : (() -> Void) = {
        
    }
    
    
    static func showLoading(view: UIView) {
        
        //base = view
        loadView.backgroundColor = transparentBlack
        loadView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(loadView)
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.tintColor = .white
        indicator.color = .white
        indicator.startAnimating()
        loadView.addCordinateSubviewToCentre(view: indicator, width: 100, height: 100)
    }
    
    static func removeLoading() {
        
        loadView.removeFromSuperview()
        for views in loadView.subviews {
            views.removeFromSuperview()
        }
    }
    
    static func refresh() {
        
        progresses.removeAll()
        Constants.currentUser = nil
    }
    
    
}
