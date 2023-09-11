//
//  LoginUI.swift
//  Atunda
//
//  Created by Mas'ud on 9/5/22.
//

import Foundation
import UIKit

class LoginUI{
    
    var baseView = UIView()
    //var emailField = UITextField()
    var userNameField = UITextField()
    var passWordField = UITextField()
    //var confirmPasswordField = UITextField()
    var bigC = UIImageView()
    var logoView = UIView()
    var logoImage = UIImageView()
    var createLabel = UILabel()
    var welcomeLabel = UILabel()
    var signUpLabel = UILabel()
    var controller : UIViewController?
    let square1 = UIImageView(image: UIImage(systemName: "square"))
    var viewModel: AuthViewModel
    
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .none
        view.frame = CGRect(x: 0, y: createLabel.frame.size.height + createLabel.frame.origin.y + 12, width: baseView.frame.width, height: (baseView.frame.size.height - (logoView.frame.size.height + 50)) - 78.0)
        view.contentSize = CGSize(width: self.baseView.frame.width, height: self.baseView.frame.height)
        view.autoresizingMask = .flexibleHeight
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.bounces = true
        return view
    }()
    
    lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.frame = CGRect(x: 0, y: 0, width: self.baseView.frame.width, height: self.baseView.frame.height)
        return view
    }()
    
    init(view : UIView, controller: UIViewController, viewModel: AuthViewModel) {
        self.baseView = view
        self.controller = controller
        self.viewModel = viewModel
    }
    
    func setup() {
        
        let splash = UIImageView(image: UIImage(named: "Get Started"))
        splash.frame = CGRect(x: 0, y: 0, width: baseView.frame.width, height: baseView.frame.height)
        baseView.addSubview(splash)
        
        bigC = UIImageView(frame: CGRect(x: 47, y: -40, width: (2.45 * baseView.frame.width), height: (0.75 * baseView.frame.height)))
        bigC.image = UIImage(named: "Mask Group 6")
        bigC.contentMode = .scaleToFill
        bigC.alpha = 0.2
        baseView.addSubview(bigC)
        
        logoView = UIView(frame: CGRect(x: 0, y: 0, width: baseView.frame.width, height: 273))
        logoView.backgroundColor = .none
        baseView.addSubview(logoView)
        logoImage = UIImageView(image: UIImage(named: "Mask Group 5"))
        logoImage.contentMode = .scaleAspectFill
        logoView.addCordinateSubviewToCentre(view: logoImage, width: 100.0, height: 100.0)
        logoView.isUserInteractionEnabled = true
        
        let backImage = UIImageView(image: UIImage(named: "Group 4"))
        logoView.addSubview(backImage)
        backImage.constraint(equalToLeft: logoView.leadingAnchor, paddingLeft: 24)
        backImage.centre(centreY: logoImage.topAnchor)
        backImage.alpha = 0
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        
        welcomeLabel = UILabel(frame: CGRect(x: 0, y: logoView.frame.size.height - 50, width: baseView.frame.width, height: 50))
        welcomeLabel.numberOfLines = 0
        //welcomeLabel.text = "Welcome to Atunda"
        welcomeLabel.textColor = UIColor.white
        //welcomeLabel.font = Constants.regularFont(size: 22.0)
        welcomeLabel.attributedText = Manipulations.changeCharFontType(fullString: "Welcome to Atunda", targetString: "Atunda", font: Constants.boldFont(size: 22))
        baseView.addSubview(welcomeLabel)
        welcomeLabel.textAlignment = .center
        //welcomeLabel.constraint(equalToTop: logoView.bottomAnchor, equalToLeft: baseView.leadingAnchor, equalToRight: baseView.trailingAnchor, paddingTop: -40, paddingLeft: 20, paddingRight: 20)
        
        createLabel = UILabel(frame: CGRect(x: 0, y: logoView.frame.size.height, width: baseView.frame.width, height: 20))
        createLabel.text = "Sign in to continue"
        createLabel.textColor = UIColor.white
        createLabel.font = Constants.regularFont(size: 12.0)
        baseView.addSubview(createLabel)
        createLabel.textAlignment = .center
        createLabel.alpha = 0.5
        
        //createLabel.constraint(equalToTop: welcomeLabel.bottomAnchor, equalToLeft: baseView.leadingAnchor, equalToRight: baseView.trailingAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20)
        
        baseView.addSubview(scrollView)
        //scrollView.constraint(equalToTop: createLabel.bottomAnchor, equalToLeft: baseView.leadingAnchor, equalToRight: baseView.trailingAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        scrollView.addSubview(containerView)
        
        let nameIcon = UIImageView(image: UIImage(systemName: "person.fill"))
        nameIcon.tintColor = .white
        nameIcon.constraint(width: 10, height: 10)
        
        userNameField.borderStyle = .none
        userNameField.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Username", targetString: "Username", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))//"Username"
        userNameField.textColor = .white
        userNameField.font = Constants.regularFont(size: 12)
        //userNameField.delegate = controller
        userNameField.text = "Moehell"
        
        let userNameView = UIView()
        //userNameView.alpha = 0.5
        userNameView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        userNameView.layer.cornerRadius = 12
        
        let userNameStack = UIStackView(arrangedSubviews: [nameIcon, userNameField])
        userNameStack.spacing = 10
        userNameView.addSubview(userNameStack)
        userNameStack.constraint(equalToTop: userNameView.topAnchor, equalToBottom: userNameView.bottomAnchor, equalToLeft: userNameView.leadingAnchor, equalToRight: userNameView.trailingAnchor, paddingTop: 24, paddingBottom: 24, paddingLeft: 16, paddingRight: 8)
        
        let passwordIcon = UIImageView(image: UIImage(named: "Password"))
        passwordIcon.constraint(width: 10, height: 10)
        
        passWordField.borderStyle = .none
        passWordField.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Password", targetString: "Password", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))
        passWordField.textColor = .white
        passWordField.font = Constants.regularFont(size: 12)
        passWordField.isSecureTextEntry = true
        passWordField.text = "Tunechi2013"
        
        let passwordView = UIView()
        //passwordView.alpha = 0.5
        passwordView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        passwordView.layer.cornerRadius = 12
        
        let passwordStack = UIStackView(arrangedSubviews: [passwordIcon, passWordField])
        passwordStack.spacing = 10
        passwordView.addSubview(passwordStack)
        passwordStack.constraint(equalToTop: passwordView.topAnchor, equalToBottom: passwordView.bottomAnchor, equalToLeft: passwordView.leadingAnchor, equalToRight: passwordView.trailingAnchor, paddingTop: 24, paddingBottom: 24, paddingLeft: 16, paddingRight: 8)
        
        let midStack = UIStackView(arrangedSubviews: [userNameView, passwordView])
        containerView.addSubview(midStack)
        midStack.axis = .vertical
        midStack.backgroundColor = .none
        midStack.constraint(equalToTop: containerView.topAnchor, equalToLeft: containerView.leadingAnchor, equalToRight: containerView.trailingAnchor, paddingTop: 150, paddingLeft: 24, paddingRight: 24)
        midStack.spacing = 16
        
        
        square1.tintColor = .white
        square1.constraint(width: 25, height: 28)
        square1.isUserInteractionEnabled = true
        
        let rememberMe = UILabel()
        rememberMe.textColor = .white
        rememberMe.font = Constants.regularFont(size: 11)
        rememberMe.text = "Remember me"
        
        let rememberMeStack = UIStackView(arrangedSubviews: [square1, rememberMe])
        rememberMeStack.spacing = 5
        rememberMeStack.axis = .horizontal
        containerView.addSubview(rememberMeStack)
        rememberMeStack.constraint(equalToTop: midStack.bottomAnchor, equalToLeft: containerView.leadingAnchor, paddingTop: 12, paddingLeft: 24)
        
        let forgotPassword = UILabel()
        containerView.addSubview(forgotPassword)
        forgotPassword.constraint(equalToRight: containerView.trailingAnchor, paddingRight: 24)
        forgotPassword.centre(centreY: rememberMeStack.centerYAnchor)
        forgotPassword.textColor = Constants.pink
        forgotPassword.text = "Forgot password"
        forgotPassword.font = Constants.boldFont(size: 11)
        forgotPassword.textAlignment = .left
        forgotPassword.isUserInteractionEnabled = true
        forgotPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToForgotPass)))
        
        let login = UIButton()
        login.setTitle("Login", for: .normal)
        login.titleLabel?.font = Constants.boldFont(size: 12)
        login.backgroundColor = Constants.pink
        login.titleLabel?.textColor = UIColor.white
        login.layer.cornerRadius = 8
        login.isUserInteractionEnabled = true
        login.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        containerView.centreHorizontally(view: login, y: scrollView.frame.size.height - 60.0, height: 50, width: containerView.frame.size.width - 48.0)
        
        let haveAccountLabel = UILabel()
        haveAccountLabel.textColor = .white
        haveAccountLabel.font = Constants.regularFont(size: 14)
        haveAccountLabel.text = "Don't have an account yet?"
        haveAccountLabel.textAlignment = .right
        
        signUpLabel.textColor = Constants.pink
        signUpLabel.text = " Register"
        signUpLabel.font = Constants.boldFont(size: 14)
        signUpLabel.textAlignment = .left
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSignup)))
        
        let haveAccountStack = UIStackView(arrangedSubviews: [haveAccountLabel, signUpLabel])
        haveAccountStack.axis = .horizontal
        haveAccountStack.spacing = 0
        haveAccountStack.alignment = .center
        baseView.centreHorizontally(view: haveAccountStack, y: scrollView.frame.size.height + scrollView.frame.origin.y, height: 30, width: 250)
        
        
    }
    
    @objc func loginAction() {
        
        if userNameField.text == "" || passWordField.text == "" {
            
            baseView.showtoast(message2: "Please fill out all fields")
        }else {
            
            Constants.showLoading(view: baseView)
            viewModel.Login(username: userNameField.text!, password: passWordField.text!)
        }
    }
    
    @objc func goBack() {
        controller?.dismiss(animated: true)
    }
    
    @objc func goToSignup() {
        let vc = SignupViewController()
        vc.modalPresentationStyle = .fullScreen
        controller?.present(vc, animated: true)
    }
    
    @objc func goToForgotPass() {
        //
    }
}
