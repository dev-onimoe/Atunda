//
//  ViewController.swift
//  Atunda
//
//  Created by Mas'ud on 9/5/22.
//

import UIKit

class SplashViewController: UIViewController {
    
    var image = UIImageView()
    var logoImage = UIImageView()
    var logoView = UIView()
    var stack = UIStackView()
    var stack2 = UIStackView()
    var stackBack = UIView()
    var bigC = UIImageView()
    
    let cache = Cache()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addLogo()
        self.addOtherViews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            // animate logo
            if !self.cache.exists(key: "user") {
                UIView.animate(withDuration: 2, animations: {
                    //self.logoView.frame.size.height = self.image.frame.origin.y
                    
                    self.logoImage.frame.size.height = 120
                    self.logoImage.frame.size.width = 120
                    self.logoImage.frame.origin.x = (self.view.frame.width/2) - (self.logoImage.frame.width/2)
                    self.logoImage.frame.origin.y = (self.logoView.frame.height/2.0) - (self.logoImage.frame.height/2.0)
                
                }, completion: {[weak self] done in
                    UIView.animate(withDuration: 2, animations: {
                        
                        self?.image.image = UIImage(named: "Get Started")
                        self?.stack.alpha = 1
                        self?.stack2.alpha = 1
                        self?.bigC.alpha = 0.2
                        
                    })
                })
            }else {
                let vc = HomeViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        })
    }
    
    func addLogo() {
        
        image = UIImageView(image: UIImage(named: "Splash"))
        image.alpha = 1
        image.contentMode = .scaleAspectFit
        view.addSubview(image)
        image.constraint(equalToTop: view.topAnchor, equalToBottom: view.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor)
        //image.centre(centreY: view.centerYAnchor)
        //view.addCordinateSubviewToCentre(view: image, width: 220.0, height: 420.0)
        
        //logoView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        logoView.backgroundColor = .none
        //view.addSubview(logoView)
        //logoView.constraint(equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, height: 240)
        //logoView.centre(centreY: view.centerYAnchor)
        view.centreHorizontally(view: logoView, y: (view.frame.height/2.0) - (240/2.0), height: 240, width: view.frame.width)
        logoImage = UIImageView(image: UIImage(named: "Mask Group -1"))
        //logoView.addSubview(logoImage)
        //logoImage.constraint(width: 220, height: 220)
        //logoImage.centre(centerX: logoView.centerXAnchor, centreY: logoView.centerYAnchor)
        logoView.addCordinateSubviewToCentre(view: logoImage, width: 220.0, height: 220.0)
    }
    
    func addOtherViews() {
        
        bigC = UIImageView(frame: CGRect(x: 47, y: -40, width: (2.45 * view.frame.width), height: (0.75 * view.frame.height)))
        bigC.image = UIImage(named: "Mask Group 6")
        bigC.contentMode = .scaleToFill
        bigC.alpha = 0
        view.addSubview(bigC)
        
        /*image = UIImageView(image: UIImage(named: "Character-dancing"))
        image.alpha = 0
        image.contentMode = .scaleToFill
        view.addSubview(image)
        image.constraint(equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingLeft: 20, paddingRight: 20, height: 350)
        image.centre(centreY: view.centerYAnchor)
        //view.addCordinateSubviewToCentre(view: image, width: 220.0, height: 420.0)*/
        
        let hiLabel = UILabel()
        hiLabel.text = "Hi"
        hiLabel.textColor = UIColor.white
        hiLabel.font = Constants.regularFont(size: 16.0)
        
        let boldLabel = UILabel()
        boldLabel.text = "there!!"
        boldLabel.textColor = UIColor.white
        boldLabel.font = Constants.boldFont(size: 16.0)
        
        stackBack.backgroundColor = .none
        view.addSubview(stackBack)
        stackBack.constraint(equalToTop: logoView.bottomAnchor, equalToBottom: view.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor)
        
        stack = UIStackView(arrangedSubviews: [hiLabel, boldLabel])
        stack.alpha = 0
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        stackBack.addSubview(stack)
        stack.constraint(equalToLeft: stackBack.leadingAnchor, paddingLeft: 20)
        stack.centre(centreY: stackBack.centerYAnchor)
        //view.addToSides(view: stack, height: 50, topview: image, padTop: 40)
        
        let signup = UIButton()
        signup.setTitle("Sign Up", for: .normal)
        signup.titleLabel?.font = Constants.boldFont(size: 12)
        signup.backgroundColor = Constants.navyBlue
        signup.titleLabel?.textColor = UIColor.white
        signup.layer.cornerRadius = 8
        signup.isUserInteractionEnabled = true
        signup.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        
        let login = UIButton()
        login.setTitle("Login", for: .normal)
        login.titleLabel?.font = Constants.boldFont(size: 12)
        login.backgroundColor = Constants.pink
        login.titleLabel?.textColor = UIColor.white
        login.layer.cornerRadius = 8
        login.isUserInteractionEnabled = true
        login.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        stack2 = UIStackView(arrangedSubviews: [signup, login])
        stack2.alpha = 0
        stack2.axis = .horizontal
        stack2.spacing = 5
        //stack2.distribution = .fill
        stack2.spacing = 5
        stackBack.addSubview(stack2)
        stack2.constraint(equalToTop: stack.bottomAnchor, equalToLeft: stackBack.leadingAnchor, equalToRight: stackBack.trailingAnchor, paddingTop: 18, paddingLeft: 20, paddingRight: 20, height: 55)
        //view.addToSides(view: stack2, height: 20, topview: stack, padTop: 16)
        signup.constraint(width: 250)
        
    }
    
    @objc func signupAction() {
        
        let vc = SignupViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func loginAction() {
        
        //print("login")
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

}


