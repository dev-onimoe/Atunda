//
//  SettingsViewController.swift
//  Atunda
//
//  Created by Mas'ud on 9/15/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var settingsUI: SettingsUI?

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .white
        settingsUI = SettingsUI(vc: self)
        settingsUI?.setup()
        // Do any additional setup after loading the view.
    }
    

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.progresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "capture", for: indexPath) as! CaptureTableViewCell
        
        return cell
    }
    
}

