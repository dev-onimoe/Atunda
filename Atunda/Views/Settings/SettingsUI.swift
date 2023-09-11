//
//  SettingsUI.swift
//  Atunda
//
//  Created by Mas'ud on 9/15/22.
//

import Foundation
import UIKit

class SettingsUI {
    
    var vc: SettingsViewController?
    var notifications = UIImageView()
    var progressView = UIView()
    
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    
    func setup() {
        
        Constants.tableView.delegate = vc
        Constants.tableView.register(CaptureTableViewCell.self, forCellReuseIdentifier: "capture")
        
        guard let view = vc?.view else {return}
        view.initSetup()
        
        let backImage = UIImageView(image: UIImage(named: "Group 4"))
        backImage.frame = CGRect(x: 32, y: 103, width: 25, height: 25)
        view.addSubview(backImage)
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        
        let text = UILabel()
        text.frame = CGRect(x: 76, y: 100, width: 250, height: 30)
        view.addSubview(text)
        //text.constraint(equalToTop: view.topAnchor, equalToLeft: view.leadingAnchor, paddingTop: 100, paddingLeft: 32)
        text.text = "Settings"
        text.textColor = .white
        text.font = Constants.boldFont(size: 18)
        text.textAlignment = .left
        //print(text.frame)
        
        notifications = UIImageView(image: UIImage(named: "Notification"))
        notifications.frame.origin = CGPoint(x: view.frame.width - 48.0, y: 100)
        notifications.isUserInteractionEnabled = true
        notifications.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProgress)))
        view.addSubview(notifications)
        
        let pass_ic = UIImageView(image: UIImage(named: "Password"))
        pass_ic.constraint(width: 20, height: 20)
        pass_ic.contentMode = .scaleToFill
        
        let passwordText = UILabel()
        passwordText.text = "Change password"
        passwordText.textColor = .white
        passwordText.font = Constants.regularFont(size: 14)
        passwordText.textAlignment = .left
        
        let passStack = UIStackView(arrangedSubviews: [pass_ic, passwordText])
        passStack.spacing = 12
        passStack.tag = 0
        
        let acout_ic = UIImageView(image: UIImage(named: "Info"))
        acout_ic.constraint(width: 20, height: 20)
        acout_ic.contentMode = .scaleToFill
        
        let aboutText = UILabel()
        aboutText.text = "About"
        aboutText.textColor = .white
        aboutText.font = Constants.regularFont(size: 14)
        aboutText.textAlignment = .left
        
        let aboutStack = UIStackView(arrangedSubviews: [acout_ic, aboutText])
        aboutStack.spacing = 12
        aboutStack.tag = 1
        
        let firstview = UIView()
        firstview.backgroundColor = .white
        firstview.constraint(height: 1.5)
        
        let help_ic = UIImageView(image: UIImage(named: "question"))
        help_ic.constraint(width: 20, height: 20)
        help_ic.contentMode = .scaleToFill
        
        let help_text = UILabel()
        //settingsText = UILabel()
        help_text.text = "Help"
        help_text.textColor = .white
        help_text.font = Constants.regularFont(size: 14)
        help_text.textAlignment = .left
        
        let help_stack = UIStackView(arrangedSubviews: [help_ic, help_text])
        help_stack.spacing = 12
        help_stack.isUserInteractionEnabled = true
        help_stack.tag = 2
        help_stack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigate)))
        
        let secondview = UIView()
        secondview.backgroundColor = .white
        secondview.constraint(height: 1.5)
        
        let logout_ic = UIImageView(image: UIImage(named: "logout"))
        logout_ic.constraint(width: 25, height: 20)
        logout_ic.contentMode = .scaleToFill
        
        let logout_text = UILabel()
        //deleteAccountText = UILabel()
        logout_text.text = "Logout"
        logout_text.textColor = .white
        logout_text.font = Constants.regularFont(size: 14)
        logout_text.textAlignment = .left
        
        let logout_stack = UIStackView(arrangedSubviews: [logout_ic, logout_text])
        logout_stack.spacing = 12
        logout_stack.isUserInteractionEnabled = true
        logout_stack.tag = 3
        logout_stack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigate)))
        
        let vStack = UIStackView(arrangedSubviews: [passStack, firstview, aboutStack, help_stack, secondview, logout_stack])
        view.addSubview(vStack)
        vStack.constraint(equalToTop: text.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingTop: 100, paddingLeft: 32, paddingRight: 32)
        vStack.axis = .vertical
        vStack.spacing = 32
        
    }
    
    @objc func showProgress() {
        let close = UIImageView(image: UIImage(systemName: "x.circle"))
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeProgress)))
        
        self.vc?.view.showProgress(back: self.progressView, close: close)
    }
    
    @objc func removeProgress() {
        
        self.progressView.removeFromSuperview()
    }
                                             
    @objc func goBack() {
        vc?.dismiss(animated: true)
    }
    
    @objc func navigate(_ sender: UITapGestureRecognizer) {
        
        let tag = sender.view?.tag
        switch tag {
        case 0:
            print(tag)
        case 1:
            print(tag)
        case 2:
            print(tag)
        case 3:
            
            let alert = UIAlertController(title: "Logout", message: "Are you sure ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
                alert.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {_ in
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                self.vc?.present(vc, animated: true)
                //Constants.currentUser = nil
                Cache().defaults.removeObject(forKey: "user")
            }))
            self.vc?.present(alert, animated: true)
        default:
            print(tag)
        }
    }
}
