//
//  UploadsTableViewCell.swift
//  Atunda
//
//  Created by Mas'ud on 11/29/22.
//

import UIKit

class UploadsTableViewCell: UITableViewCell {
    
    
    let title = UILabel()
    let numberOfVideos = UILabel()
    let size = UILabel()
    let lilView = UIView()
    let errorView = UIImageView()
    
    var delegate : errorTapped?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        errorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(error(_:))))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .none
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = Constants.navyBlue2
        view.layer.cornerRadius = 12
        addSubview(view)
        view.constraint(equalToTop: topAnchor, equalToBottom: bottomAnchor, equalToLeft: leadingAnchor, equalToRight: trailingAnchor, paddingBottom: 12, paddingLeft: 12, paddingRight: 12)
        
        
        view.addSubview(title)
        title.constraint(equalToTop: view.topAnchor, equalToLeft: view.leadingAnchor, paddingTop: 32, paddingLeft: 16)
        title.text = "Title"
        title.font = Constants.boldFont(size: 20)
        title.textColor = .white
        
        view.addSubview(errorView)
        errorView.alpha = 0
        errorView.constraint(equalToRight: view.trailingAnchor, paddingRight: 16, width: 20, height: 20)
        errorView.centre(centreY: title.centerYAnchor)
        errorView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        errorView.tintColor = Constants.pink
        errorView.isUserInteractionEnabled = true
        errorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(error)))
        
        
        view.addSubview(numberOfVideos)
        numberOfVideos.constraint(equalToTop: title.bottomAnchor, equalToBottom: view.bottomAnchor, equalToLeft: title.leadingAnchor, paddingTop: 25, paddingBottom: 16)
        numberOfVideos.text = "30 videos"
        numberOfVideos.font = Constants.regularFont(size: 15)
        numberOfVideos.textColor = .white
        
        
        view.addSubview(size)
        size.constraint(equalToLeft: numberOfVideos.trailingAnchor, paddingLeft: 16)
        size.centre(centreY: numberOfVideos.centerYAnchor)
        size.text = "500mb"
        size.font = Constants.boldFont(size: 14)
        size.textColor = .white
        
        
        view.addSubview(lilView)
        lilView.backgroundColor = .white
        lilView.layer.cornerRadius = 6
        lilView.constraint(equalToRight: view.trailingAnchor, paddingRight: 16)
        lilView.centre(centreY: numberOfVideos.centerYAnchor)
        lilView.isUserInteractionEnabled = true
        
        let arrow = UIImageView(image: UIImage(systemName: "arrow.right"))
        lilView.addSubview(arrow)
        arrow.constraint(equalToTop: lilView.topAnchor, equalToBottom: lilView.bottomAnchor, equalToLeft: lilView.leadingAnchor, equalToRight: lilView.trailingAnchor, paddingTop: 4, paddingBottom: 4,paddingLeft: 4, paddingRight: 4)
        arrow.tintColor = Constants.navyBlue
        
    }
    
    @objc func error(_ gesture: UITapGestureRecognizer) {
        
        delegate?.tapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol errorTapped {
        
    func tapped()
}
