//
//  HomeViewController.swift
//  Atunda
//
//  Created by Mas'ud on 9/7/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var homeUI: HomeUI?
    var vm : HomeViewModel?
    var timer : Timer?
    let cache = Cache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeUI = HomeUI(viewController: self)
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        homeUI?.setup()
        //Service.shared.getToken()
        //timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(rerunToken), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            
        })
    }
    
    @objc func rerunToken() {
        
        if !cache.exists(key: "appKey") {
            Service.shared.getToken()
        }
    }
    
    
}
