//
//  UploadsUI.swift
//  Atunda
//
//  Created by Mas'ud on 9/14/22.
//

import Foundation
import UIKit

class UploadsUI{
    
    var vc : UploadsViewController?
    var homeImage = UIImageView()
    var folderImage = UIImageView()
    var setImage = UIImageView()
    var tabView = UIView()
    var progressView = UIView()
    var modeView = UIView()
    var notifications = UIImageView()
    let searchField = UITextField()
    let moveUp = UIImageView(image: UIImage(systemName: "arrow.up"))
    
    let tableView = UITableView()
    let noUploads = UILabel()
    
    init(viewController: UploadsViewController) {
        vc = viewController
        
    }
    
    func setup() {
        
        progressView.isUserInteractionEnabled = true
        guard let view = vc?.view else {return}
        view.initSetup()
        
        let text = UILabel()
        text.frame = CGRect(x: 32, y: 100, width: 250, height: 30)
        view.addSubview(text)
        //text.constraint(equalToTop: view.topAnchor, equalToLeft: view.leadingAnchor, paddingTop: 100, paddingLeft: 32)
        text.text = "Uploads"
        text.textColor = .white
        text.font = Constants.boldFont(size: 18)
        text.textAlignment = .left
        //print(text.frame)
        
        notifications = UIImageView(image: UIImage(named: "Notification"))
        notifications.frame.origin = CGPoint(x: view.frame.width - 48.0, y: 100)
        view.addSubview(notifications)
        notifications.isUserInteractionEnabled = true
        notifications.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProgress)))
        
        let mailIcon = UIImageView(image: UIImage(named: "search"))
        mailIcon.constraint(width: 60)
        
        searchField.borderStyle = .none
        searchField.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Email", targetString: "Email", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))//"Email"
        searchField.textColor = .white
        searchField.tintColor = .white
        searchField.font = Constants.regularFont(size: 12)
        
        let mailview = UIView()
        view.addSubview(mailview)
        mailview.constraint(equalToTop: text.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32, height: 55)
        mailview.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        mailview.alpha = 0
        mailview.layer.cornerRadius = 12
        
        let mailStack = UIStackView(arrangedSubviews: [searchField, mailIcon])
        mailStack.spacing = 10
        mailview.addSubview(mailStack)
        mailStack.constraint(equalToTop: mailview.topAnchor, equalToBottom: mailview.bottomAnchor, equalToLeft: mailview.leadingAnchor, equalToRight: mailview.trailingAnchor, paddingLeft: 16, paddingRight: 0)
        
        
        moveUp.tintColor = .white
        view.addSubview(moveUp)
        moveUp.constraint(equalToTop: mailStack.topAnchor, equalToRight: mailStack.trailingAnchor, paddingTop: 8, width: 20, height: 20)
        moveUp.contentMode = .scaleAspectFit
        moveUp.alpha = 0
        moveUp.clipsToBounds = true
        moveUp.layer.cornerRadius = 4
        moveUp.isUserInteractionEnabled = true
        //moveUp.backgroundColor = Constants.navyBlue
        
        //noUploads.frame = CGRect(x: 32, y: 100, width: 250, height: 30)
        noUploads.text = "You have no uploads here yet"
        noUploads.textColor = .white
        noUploads.font = Constants.regularFont(size: 15)
        noUploads.textAlignment = .center
        
        //print(view.frame)
        view.addSubview(tableView)
        tableView.constraint(equalToTop: moveUp.bottomAnchor, equalToBottom: view.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingTop: 8, paddingBottom: 120, paddingLeft: 16, paddingRight: 16 )
        tableView.register(UploadsTableViewCell.self, forCellReuseIdentifier: "uploadsCell")
        //tableView.tableFooterView = UIView()
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        //tableView.backgroundView
        tableView.delegate = vc
        tableView.dataSource = vc
        
    }
    
    @objc func showProgress() {
        
        let close = UIImageView(image: UIImage(systemName: "x.circle"))
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeProgress)))
        
        vc?.homevc!.view.showProgress(back: progressView, close: close)
    }
    
    @objc func removeProgress() {
        
        self.progressView.removeProperly()
    }
}
