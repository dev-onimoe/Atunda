//
//  LoginViewController.swift
//  Atunda
//
//  Created by Mas'ud on 9/5/22.
//

import UIKit

class SignupViewController: UIViewController {
    
    var signupUi : SignupUI?
    var viewModel : AuthViewModel?
    
    var check1 = false
    var check2 = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        viewModel = AuthViewModel()
        signupUi = SignupUI(view: self.view, controller: self, viewModel: viewModel!)
        signupUi!.setup()
        setupObservers()
        // Do any additional setup after loading the view.
        gestureRecognizers()
    }
    
    func gestureRecognizers() {
        
        signupUi?.square1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeCheckMark)))
        signupUi?.square2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeCheckMark2)))
    }
    
    func setupObservers() {
        
        viewModel?.signupDone.bind(completion: {[weak self] response in
            
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
    
    @objc func changeCheckMark() {
        
        if check1 {
            signupUi?.square1.image = UIImage(systemName: "square")
            check1 = false
        }else {
            signupUi?.square1.image = UIImage(systemName: "checkmark.square")
            check1 = true
        }
    }
    
    @objc func changeCheckMark2() {
        
        if check2 {
            signupUi?.square2.image = UIImage(systemName: "square")
            check2 = false
        }else {
            signupUi?.square2.image = UIImage(systemName: "checkmark.square")
            check2 = true
        }
    }
    
}

extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
