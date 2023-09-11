//
//  Extensions.swift
//  Atunda
//
//  Created by Mas'ud on 9/5/22.
//

import Foundation
import UIKit
import SwiftyDropbox

extension UIView {
    
    func showLoader() {
        let loaderView = UIView()
        loaderView.tag = 1
        loaderView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(loaderView)
        loaderView.backgroundColor = Constants.navyBlue2
        
        let loader = UIActivityIndicatorView()
        loader.tintColor = Constants.darkPurple
        loader.color = Constants.darkPurple
        loaderView.addCordinateSubviewToCentre(view: loader, width: 30, height: 30)
        loader.startAnimating()
        
    }
    
    func removeLoader() {
        
        let views = self.subviews
        for v in views {
            
            if v.tag == 1 {
                v.removeFromSuperview()
            }
        }
        
    }
    
    func removeProperly() {
        
        for view in self.subviews {
            
            view.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
    func addCordinateSubviewToCentre(view : UIView, width : Double, height : Double) {
        
        view.frame = CGRect(x: (frame.width/2.0) - (width/2.0), y: (frame.height/2.0) - (height/2.0), width: width, height: width)
        addSubview(view)
        
    }
    
    func centreHorizontally(view : UIView, y : Double, height : Double, width: Double) {
        
        view.frame = CGRect(x: (frame.width/2.0) - (width/2.0), y: y, width: width, height: height)
        
        addSubview(view)
        
    }
    
    func centreVertically(view : UIView, x : Double, height : Double, width: Double) {
        
        view.frame = CGRect(x: x, y: (frame.height/2.0) - (height/2.0), width: width, height: height)
        
        addSubview(view)
        
    }
    
    func centerVertInSuperView(x: Double, height: Double) {
        
        frame.origin.y = (frame.height/2.0) - (height/2.0)
    }
    
    func constraint (equalToTop: NSLayoutYAxisAnchor? = nil,
                     equalToBottom: NSLayoutYAxisAnchor? = nil,
                     equalToLeft: NSLayoutXAxisAnchor? = nil,
                     equalToRight: NSLayoutXAxisAnchor? = nil,
                     paddingTop: CGFloat = 0,
                     paddingBottom: CGFloat = 0,
                     paddingLeft: CGFloat = 0,
                     paddingRight: CGFloat = 0,
                     width: CGFloat? = nil,
                     height: CGFloat? = nil
    ) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let equalToTop = equalToTop {
            
            topAnchor.constraint(equalTo: equalToTop, constant: paddingTop).isActive = true
        }
        
        if let equalTobottom = equalToBottom {
            
            bottomAnchor.constraint(equalTo: equalTobottom, constant: -paddingBottom).isActive = true
        }
        
        if let equalToLeft = equalToLeft {
            
            leadingAnchor.constraint(equalTo: equalToLeft, constant: paddingLeft).isActive = true
        }
        
        if let equalToRight = equalToRight {
            
            trailingAnchor.constraint(equalTo: equalToRight, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centre (centerX: NSLayoutXAxisAnchor? = nil, centreY: NSLayoutYAxisAnchor? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerx = centerX {
            
            centerXAnchor.constraint(equalTo: centerx).isActive = true
        }
        
        if let centery = centreY {
            
            centerYAnchor.constraint(equalTo: centery).isActive = true
        }
    }
    
    func showtoast(message2: String) {
        
        DispatchQueue.main.async {
            let toastView = UIView()
            toastView.alpha = 0
            self.addSubview(toastView)
            self.bringSubviewToFront(toastView)
            toastView.backgroundColor = .black
            toastView.constraint(equalToBottom: self.bottomAnchor, equalToLeft: self.leadingAnchor, equalToRight: self.trailingAnchor, paddingBottom: 60, paddingLeft: 30, paddingRight: 30)
            toastView.layer.cornerRadius = 10
            
            let message = UILabel()
            toastView.addSubview(message)
            message.text = message2
            message.textColor = .white
            message.font = UIFont(name: "Roboto-Regular", size: 13)
            message.textAlignment = .center
            message.numberOfLines = 0
            message.constraint(equalToTop: toastView.topAnchor, equalToBottom: toastView.bottomAnchor, equalToLeft: toastView.leadingAnchor, equalToRight: toastView.trailingAnchor, paddingTop: 15, paddingBottom: 15, paddingLeft: 5, paddingRight: 5, width: nil)
            
            
            UIView.animate(withDuration: 0.5, animations: {toastView.alpha = 1})
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                UIView.animate(withDuration: 0.2, animations: {toastView.alpha = 0})
            })
        }
    }
    
    func shadowBorder (){
        
        //layer.cornerRadius = 4
        layer.shadowColor = UIColor.white.cgColor//self.backgroundColor?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.75)
        layer.shadowRadius = 15
        layer.shadowOpacity = 1.0
    }
    
    func shadowBorderBlack (){
        
        //layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor//self.backgroundColor?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.75)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
                    clipsToBounds = true
                    layer.cornerRadius = radius
                    layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
                } else {
                    let path = UIBezierPath(
                        roundedRect: bounds,
                        byRoundingCorners: corners,
                        cornerRadii: CGSize(width: radius, height: radius)
                    )
                    let mask = CAShapeLayer()
                    mask.path = path.cgPath
                    layer.mask = mask
                }
    }
    
    func initSetup() {
        
        backgroundColor = .white
        let splash = UIImageView(image: UIImage(named: "Splash"))
        splash.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        addSubview(splash)
        
        var bigC = UIImageView()
        bigC = UIImageView(frame: CGRect(x: 47, y: -40, width: (2.45 * self.frame.width), height: (0.75 * self.frame.height)))
        bigC.image = UIImage(named: "Mask Group 6")
        bigC.contentMode = .scaleToFill
        bigC.alpha = 0.2
        addSubview(bigC)
    }
    
    
    func showProgress(back: UIView, close: UIImageView) {
        
        let height = frame.height/2
        
        //let back = UIView()
        /*for v in back.subviews {
            v.removeFromSuperview()
        }*/
        back.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        back.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(back)
        
        let view = UIView()
        view.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
        view.backgroundColor = Constants.pink
        view.frame = CGRect(x: 0, y: frame.height - height, width: frame.width, height: height)
        //back.addSubview(view)
        //view.constraint(equalToBottom: back.bottomAnchor, equalToLeft: back.leadingAnchor, equalToRight: back.trailingAnchor, height: height)
        back.addSubview(view)
        
        let title = UILabel()
        title.text = "Upload Progress"
        title.textColor = .white
        title.font = Constants.boldFont(size: 15)
        view.addSubview(title)
        title.constraint(equalToTop: view.topAnchor, paddingTop: 20)
        title.centre(centerX: view.centerXAnchor)
        
        //let close = UIImageView(image: UIImage(systemName: "x.circle"))
        close.tintColor = .white
        view.addSubview(close)
        close.constraint(equalToRight: view.trailingAnchor, paddingRight: 16, width: 20, height: 20)
        close.centre(centreY: title.centerYAnchor)
        close.isUserInteractionEnabled = true
        
        if !Constants.progresses.isEmpty {
            
            Constants.tableView.removeFromSuperview()
            Constants.tableView.backgroundColor = Constants.pink
            Constants.tableView.separatorStyle = .none
            Constants.tableView.frame = CGRect(x: 16, y: 52.0, width: back.frame.size.width - 32.0, height: view.frame.height - 70.0)
            view.addSubview(Constants.tableView)
            //Constants.tableView.constraint(equalToTop: title.bottomAnchor, equalToBottom: view.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingTop: 12, paddingBottom: 16, paddingLeft: 12, paddingRight: 12)
        }else {
            
            let noProgressLabel = UILabel()
            noProgressLabel.text = "You have no uploads yet"
            noProgressLabel.textColor = .white
            noProgressLabel.font = Constants.regularFont(size: 15)
            view.addSubview(noProgressLabel)
            noProgressLabel.centre(centerX: view.centerXAnchor, centreY: view.centerYAnchor)
            
        }
        
    }
    
    func showProgress2(back: UIView, close: UIImageView) {
        
        let height = frame.height/2
        
        //let back = UIView()
        /*for v in back.subviews {
            v.removeFromSuperview()
        }*/
        back.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        back.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(back)
        
        let view = UIView()
        view.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
        view.backgroundColor = Constants.pink
        view.frame = CGRect(x: 0, y: frame.height - height, width: frame.width, height: height)
        //back.addSubview(view)
        //view.constraint(equalToBottom: back.bottomAnchor, equalToLeft: back.leadingAnchor, equalToRight: back.trailingAnchor, height: height)
        back.addSubview(view)
        
        let title = UILabel()
        title.text = "Upload Progress"
        title.textColor = .white
        title.font = Constants.boldFont(size: 15)
        view.addSubview(title)
        title.constraint(equalToTop: view.topAnchor, paddingTop: 20)
        title.centre(centerX: view.centerXAnchor)
        
        //let close = UIImageView(image: UIImage(systemName: "x.circle"))
        close.tintColor = .white
        view.addSubview(close)
        close.constraint(equalToRight: view.trailingAnchor, paddingRight: 16, width: 20, height: 20)
        close.centre(centreY: title.centerYAnchor)
        close.isUserInteractionEnabled = true
        
        Constants.tableView.removeFromSuperview()
        Constants.tableView.backgroundColor = Constants.pink
        Constants.tableView.separatorStyle = .none
        Constants.tableView.frame = CGRect(x: 16, y: 52.0, width: back.frame.size.width - 32.0, height: view.frame.height - 70.0)
        view.addSubview(Constants.tableView)
        
    }
}

extension String {
    
    func removeSpecialChars() {
        
        self.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "~", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
    }
}

extension Files.Metadata {
    
    func getNumberOfItems(completion: @escaping (Int) -> Void) {
        
        DropBox.shared.readFolders(name: self.name, completion: {response in
            
            if response.check {
                if let names = response.object as? [Files.Metadata] {
                    
                    completion(names.count)
                }
                
            }
        })
        
    }
}

