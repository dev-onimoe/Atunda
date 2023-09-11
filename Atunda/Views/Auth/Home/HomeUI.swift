//
//  HomeUI.swift
//  Atunda
//
//  Created by Mas'ud on 9/7/22.
//

import Foundation
import UIKit

class HomeUI{
    
    var vc : HomeViewController?
    var homeImage = UIImageView()
    var folderImage = UIImageView()
    var setImage = UIImageView()
    var tabView = UIView()
    var modeView = UIView()
    var progressView = UIView()
    
    init(viewController: HomeViewController) {
        vc = viewController
        
    }
    
    func setup() {
        
        guard let view = vc?.view else {return}
        progressView = view
        view.initSetup()
        tabView = UIView()
        tabView.backgroundColor = Constants.darkPurpleTrans
        tabView.layer.cornerRadius = 12
        view.centreHorizontally(view: tabView, y: view.frame.size.height - 105.0, height: 75, width: view.frame.size.width - 75.0)
        
        let settingsView = UIView()
        settingsView.backgroundColor = .none
        tabView.addSubview(settingsView)
        settingsView.centre(centreY: tabView.centerYAnchor)
        settingsView.constraint(equalToLeft: tabView.leadingAnchor, paddingLeft: 24, width: 30, height: 30)
        //settingsView.shadowBorder()
        
        setImage = UIImageView(image: UIImage(named: "setting"))
        setImage.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        settingsView.addSubview(setImage)
        setImage.contentMode = .scaleAspectFill
        setImage.isUserInteractionEnabled = true
        setImage.tag = 0
        //setImage.shadowBorder()
        setImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTab)))
        
        /*let setButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        setButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        setButton.tintColor = .white
        settingsView.addSubview(setButton)*/
        
        
        let homeView = UIView()
        homeView.backgroundColor = .none
        tabView.addSubview(homeView)
        homeView.constraint(width: 30, height: 30)
        homeView.centre(centerX: tabView.centerXAnchor, centreY: tabView.centerYAnchor)
        
        homeImage = UIImageView(image: UIImage(named: "home"))
        homeImage.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        homeView.addSubview(homeImage)
        homeImage.contentMode = .scaleAspectFill
        homeImage.isUserInteractionEnabled = true
        homeImage.tag = 1
        homeImage.shadowBorder()
        homeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTab)))
        
        let uploads = UIView()
        uploads.backgroundColor = .none
        tabView.addSubview(uploads)
        uploads.centre(centreY: tabView.centerYAnchor)
        uploads.constraint(equalToRight: tabView.trailingAnchor, paddingRight: 24, width: 30, height: 30)
        
        folderImage = UIImageView(image: UIImage(named: "upload"))
        folderImage.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        uploads.addSubview(folderImage)
        folderImage.contentMode = .scaleAspectFill
        folderImage.tag = 2
        folderImage.isUserInteractionEnabled = true
        //folderImage.shadowBorder()
        folderImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTab)))
        
        let mode = ModeViewController()
        mode.homevc = self.vc!
        modeView.removeFromSuperview()
        modeView = mode.view
        vc?.view.insertSubview(modeView, at: 2)
        mode.didMove(toParent: vc!)
    }
    
    @objc func changeTab(_ sender: UITapGestureRecognizer) {
        
        guard let view = sender.view else {return}
        switch view.tag {
        case 0:
            let mode = ProfileViewController()
            mode.homevc = self.vc!
            modeView.removeFromSuperview()
            modeView = mode.view
            vc?.view.insertSubview(modeView, at: 2)
            mode.didMove(toParent: vc!)
            vc?.addChild(mode)
        case 1:
            let mode = ModeViewController()
            mode.homevc = self.vc!
            modeView.removeFromSuperview()
            modeView = mode.view
            vc?.view.insertSubview(modeView, at: 2)
            mode.didMove(toParent: vc!)
            vc?.addChild(mode)
        case 2:
            let mode = UploadsViewController()
            mode.homevc = self.vc!
            modeView.removeFromSuperview()
            modeView = mode.view
            vc?.view.insertSubview(modeView, at: 2)
            mode.didMove(toParent: vc!)
            vc?.addChild(mode)
        default:
            print(view.tag)
        }
        glowView(tag: view.tag)
    }
    
    func glowView(tag: Int) {
        
        switch tag {
        case 0:
            setImage.shadowBorder()
            removeGlow(view: homeImage)
            removeGlow(view: folderImage)
        case 1:
            homeImage.shadowBorder()
            removeGlow(view: setImage)
            removeGlow(view: folderImage)
        case 2:
            folderImage.shadowBorder()
            removeGlow(view: setImage)
            removeGlow(view: homeImage)
        default:
            print(tag)
        }
    }
    
    func removeGlow(view: UIView) {
        
        view.layer.shadowOpacity = 0
    }
}
