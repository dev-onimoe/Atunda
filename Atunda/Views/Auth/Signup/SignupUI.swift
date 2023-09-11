//
//  LoginUI.swift
//  Atunda
//
//  Created by Mas'ud on 9/5/22.
//

import Foundation
import UIKit

class SignupUI{
    
    var baseView = UIView()
    var emailField = UITextField()
    var userNameField = UITextField()
    var passWordField = UITextField()
    var confirmPasswordField = UITextField()
    var bigC = UIImageView()
    var logoView = UIView()
    var logoImage = UIImageView()
    var createLabel = UILabel()
    var welcomeLabel = UILabel()
    var signUpLabel = UILabel()
    var controller : SignupViewController?
    var viewModel : AuthViewModel?
    var loadView = UIView()
    
    let square1 = UIImageView(image: UIImage(systemName: "square"))
    let square2 = UIImageView(image: UIImage(systemName: "square"))
    
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
        if self.baseView.frame.height > 700 {
            view.frame = CGRect(x: 0, y: 0, width: self.baseView.frame.width, height: self.baseView.frame.height/2)
        }else {
            view.frame = CGRect(x: 0, y: 0, width: self.baseView.frame.width, height: self.baseView.frame.height)
        }
        
        return view
    }()
    
    init(view : UIView, controller : SignupViewController, viewModel: AuthViewModel) {
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
        
        let backImage = UIImageView(image: UIImage(named: "Group 4"))
        logoView.addSubview(backImage)
        backImage.alpha = 0
        backImage.constraint(equalToLeft: logoView.leadingAnchor, paddingLeft: 24)
        backImage.centre(centreY: logoImage.topAnchor)
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
        createLabel.text = "Create an account"
        createLabel.textColor = UIColor.white
        createLabel.font = Constants.regularFont(size: 12.0)
        baseView.addSubview(createLabel)
        createLabel.textAlignment = .center
        createLabel.alpha = 0.5
        
        //createLabel.constraint(equalToTop: welcomeLabel.bottomAnchor, equalToLeft: baseView.leadingAnchor, equalToRight: baseView.trailingAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20)
        
        baseView.addSubview(scrollView)
        //scrollView.constraint(equalToTop: createLabel.bottomAnchor, equalToLeft: baseView.leadingAnchor, equalToRight: baseView.trailingAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        scrollView.addSubview(containerView)
        
        
        let mailIcon = UIImageView(image: UIImage(named: "mail"))
        mailIcon.constraint(width: 10, height: 10)
        
        emailField.borderStyle = .none
        emailField.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Email", targetString: "Email", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))//"Email"
        emailField.textColor = .white
        emailField.tintColor = .white
        emailField.font = Constants.regularFont(size: 12)
        
        let mailview = UIView()
        mailview.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        //mailview.alpha = 0.5
        mailview.layer.cornerRadius = 12
        
        let mailStack = UIStackView(arrangedSubviews: [mailIcon, emailField])
        mailStack.spacing = 10
        mailview.addSubview(mailStack)
        mailStack.constraint(equalToTop: mailview.topAnchor, equalToBottom: mailview.bottomAnchor, equalToLeft: mailview.leadingAnchor, equalToRight: mailview.trailingAnchor, paddingTop: 24, paddingBottom: 24, paddingLeft: 16, paddingRight: 8)
        
        let nameIcon = UIImageView(image: UIImage(systemName: "person.fill"))
        nameIcon.tintColor = .white
        nameIcon.constraint(width: 10, height: 10)
        
        userNameField.borderStyle = .none
        userNameField.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Username", targetString: "Username", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))//"Username"
        userNameField.textColor = .white
        userNameField.font = Constants.regularFont(size: 12)
        
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
        
        let passwordView = UIView()
        //passwordView.alpha = 0.5
        passwordView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        passwordView.layer.cornerRadius = 12
        
        let passwordStack = UIStackView(arrangedSubviews: [passwordIcon, passWordField])
        passwordStack.spacing = 10
        passwordView.addSubview(passwordStack)
        passwordStack.constraint(equalToTop: passwordView.topAnchor, equalToBottom: passwordView.bottomAnchor, equalToLeft: passwordView.leadingAnchor, equalToRight: passwordView.trailingAnchor, paddingTop: 24, paddingBottom: 24, paddingLeft: 16, paddingRight: 8)
        
        let confirmIcon = UIImageView(image: UIImage(named: "Password"))
        confirmIcon.constraint(width: 10, height: 10)
        
        confirmPasswordField.borderStyle = .none
        confirmPasswordField.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Confirm Password", targetString: "Confirm Password", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))
        confirmPasswordField.textColor = .white
        confirmPasswordField.font = Constants.regularFont(size: 12)
        confirmPasswordField.isSecureTextEntry = true
        
        let confirmView = UIView()
        //confirmView.alpha = 0.5
        confirmView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        confirmView.layer.cornerRadius = 12
        
        let confirmStack = UIStackView(arrangedSubviews: [confirmIcon, confirmPasswordField])
        confirmStack.spacing = 10
        confirmView.addSubview(confirmStack)
        confirmStack.constraint(equalToTop: confirmView.topAnchor, equalToBottom: confirmView.bottomAnchor, equalToLeft: confirmView.leadingAnchor, equalToRight: confirmView.trailingAnchor, paddingTop: 24, paddingBottom: 24, paddingLeft: 16, paddingRight: 8)
        
        let midStack = UIStackView(arrangedSubviews: [mailview, userNameView, passwordView, confirmView])
        containerView.addSubview(midStack)
        midStack.axis = .vertical
        midStack.backgroundColor = .none
        midStack.constraint(equalToTop: containerView.topAnchor, equalToLeft: containerView.leadingAnchor, equalToRight: containerView.trailingAnchor, paddingTop: 10, paddingLeft: 24, paddingRight: 24)
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
        rememberMeStack.constraint(equalToTop: midStack.bottomAnchor, equalToLeft: containerView.leadingAnchor, paddingTop: 8, paddingLeft: 24)
        
        
        //let square2 = UIImageView(image: UIImage(systemName: "square"))
        square2.tintColor = .white
        square2.constraint(width: 25)
        square2.isUserInteractionEnabled = true
        
        let termsText = UILabel()
        termsText.textColor = .white
        termsText.font = Constants.regularFont(size: 11)
        termsText.numberOfLines = 0
        termsText.text = "To signup you have to agree to the termsand conditions & privacy policy of Atunda"
        
        let termsStack = UIStackView(arrangedSubviews: [square2, termsText])
        termsStack.spacing = 5
        termsStack.axis = .horizontal
        containerView.addSubview(termsStack)
        termsStack.constraint(equalToTop: rememberMeStack.bottomAnchor, equalToLeft: containerView.leadingAnchor, equalToRight: containerView.trailingAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        
        let signup = UIButton()
        signup.setTitle("Sign Up", for: .normal)
        signup.titleLabel?.font = Constants.boldFont(size: 12)
        signup.backgroundColor = Constants.navyBlue
        signup.titleLabel?.textColor = UIColor.white
        signup.layer.cornerRadius = 8
        signup.isUserInteractionEnabled = true
        signup.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        containerView.centreHorizontally(view: signup, y: containerView.frame.size.height - 20.0, height: 50, width: containerView.frame.size.width - 48.0)
        
        let haveAccountLabel = UILabel()
        haveAccountLabel.textColor = .white
        haveAccountLabel.font = Constants.regularFont(size: 14)
        haveAccountLabel.text = "Already have an account?"
        haveAccountLabel.textAlignment = .right
        
        signUpLabel.textColor = Constants.pink
        signUpLabel.text = " Sign in"
        signUpLabel.font = Constants.boldFont(size: 14)
        signUpLabel.textAlignment = .left
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToLogin)))
        
        let haveAccountStack = UIStackView(arrangedSubviews: [haveAccountLabel, signUpLabel])
        haveAccountStack.axis = .horizontal
        haveAccountStack.spacing = 0
        haveAccountStack.alignment = .center
        baseView.centreHorizontally(view: haveAccountStack, y: scrollView.frame.size.height + scrollView.frame.origin.y, height: 30, width: 250)
        
        
    }
    
    @objc func signupAction() {
        
        if self.controller!.check2 {
            if emailField.text == "" || userNameField.text == "" || passWordField.text == "" || confirmPasswordField.text == "" {
                
                baseView.showtoast(message2: "Please fill out all fields")
            }else if !isValidEmail(emailField.text!) {
                baseView.showtoast(message2: "Email is invalid")
            }else if passWordField.text! != confirmPasswordField.text! {
                baseView.showtoast(message2: "Passwords don't match")
            } else {
                
                Constants.showLoading(view: baseView)
                viewModel?.Signup(username: userNameField.text!, password: passWordField.text!, email: emailField.text!.lowercased())
            }
        }else {
            baseView.showtoast(message2: "You have to accept the terms and conditions before signing up.")
        }
    }
    
    @objc func goBack() {
        controller?.dismiss(animated: true)
    }
    
    @objc func goToLogin() {
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        controller?.present(vc, animated: true)
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
