//
//  CaptureTableViewCell.swift
//  Atunda
//
//  Created by Mas'ud on 10/3/22.
//

import UIKit

class CaptureTableViewCell: UITableViewCell {
    
    var title = UILabel()
    var videoNumber = UILabel()
    var fileSize = UILabel()
    var progress = UILabel()
    var bar2 = UIView()
    var bar = UIView()
    
    
    override func layoutSubviews() {
          super.layoutSubviews()
          //set the values for top,left,bottom,right margins
          let margins = UIEdgeInsets(top: 5, left: 0, bottom: 20, right: 0)
          contentView.frame = contentView.frame.inset(by: margins)
          //contentView.layer.cornerRadius = 8
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Constants.pink
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        addSubview(view)
        view.constraint(equalToTop: topAnchor, equalToBottom: bottomAnchor, equalToLeft: leadingAnchor, equalToRight: trailingAnchor, paddingBottom: 12, paddingLeft: 12, paddingRight: 12, height: 100)
        
        //let title = UILabel()
        title.text = "Title"
        title.textColor = Constants.darkPurple
        title.font = Constants.boldFont(size: 32)
        view.addSubview(title)
        title.constraint(equalToLeft: view.leadingAnchor, paddingLeft: 16, width: 100)
        title.centre(centreY: view.centerYAnchor)
        
        //let videoNumber = UILabel()
        videoNumber.text = "0 videos"
        videoNumber.textColor = Constants.darkPurple
        videoNumber.font = Constants.regularFont(size: 14)
        view.addSubview(videoNumber)
        videoNumber.constraint(equalToTop: view.topAnchor, equalToLeft: title.trailingAnchor, paddingTop: 32, paddingLeft: 16)
        
        //let fileSize = UILabel()
        fileSize.text = "0gb"
        fileSize.textColor = Constants.darkPurple
        fileSize.font = Constants.boldFont(size: 13)
        view.addSubview(fileSize)
        fileSize.constraint(equalToLeft: videoNumber.trailingAnchor, paddingLeft: 14)
        fileSize.centre(centreY: videoNumber.centerYAnchor)
        
        //let progress = UILabel()
        progress.text = "0%"
        progress.textColor = Constants.darkPurple
        progress.font = Constants.regularFont(size: 13)
        view.addSubview(progress)
        progress.constraint(equalToTop: videoNumber.bottomAnchor, equalToRight: view.trailingAnchor, paddingTop: 4, paddingRight: 16)
        
        
        //let bar = UIView()
        view.addSubview(bar)
        bar.constraint(equalToLeft: videoNumber.leadingAnchor, equalToRight: progress.leadingAnchor, paddingRight: 8, height: 5)
        bar.centre(centreY: progress.centerYAnchor)
        bar.backgroundColor = .lightGray
        bar.layoutIfNeeded()
        
        //let bar2 = UIView()
        bar2.frame = CGRect(x: 0, y: 0, width: 0, height: 5)
        bar.addSubview(bar2)
        bar2.backgroundColor = Constants.darkPurple
    
    }
    
    func moveBar(fraction: Double) {
        
        bar2.frame.size.width = fraction * bar.frame.width
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
