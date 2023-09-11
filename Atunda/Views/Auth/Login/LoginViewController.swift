//
//  LoginViewController.swift
//  Atunda
//
//  Created by Mas'ud on 9/6/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginUI : LoginUI?
    var viewModel : AuthViewModel?
    
    var check = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        viewModel = AuthViewModel()
        loginUI = LoginUI(view: self.view, controller: self, viewModel: viewModel!)
        loginUI!.setup()
        setupObservers()
        // Do any additional setup after loading the view.
        
        gestureRecognizers()
        setup()
        
        Constants.refresh()
    }
    
    func setup() {
        
        loginUI!.userNameField.delegate = self
        loginUI!.passWordField.delegate = self
    }
    
    func gestureRecognizers() {
        
        loginUI?.square1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeCheckMark)))
    }
    
    @objc func changeCheckMark() {
        
        if check {
            loginUI?.square1.image = UIImage(systemName: "square")
            check = false
        }else {
            loginUI?.square1.image = UIImage(systemName: "checkmark.square")
            check = true
        }
    }
    
    func setupObservers() {
        
        viewModel?.signinDone.bind(completion: {[weak self] response in
            
            Constants.removeLoading()
            if let resp = response {
                
                if resp.check {
                    let vc = HomeViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }else {
                    print(resp.description)
                    self?.view.showtoast(message2: resp.description)
                }
            }
        })
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
