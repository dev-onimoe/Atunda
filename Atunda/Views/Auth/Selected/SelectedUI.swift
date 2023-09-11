//
//  Selected.swift
//  Atunda
//
//  Created by Mas'ud on 9/22/22.
//

import Foundation
import UIKit

class SelectedUI {
    
    var vc: SelectedViewController?
    var collectionView : UICollectionView?
    var title: UITextField
    var description: UITextField
    var tags: UITextField
    var urls: [URL] = []
    var currentIndex = 0
    let dotsView = UIView()
    
    let upload = UIButton()
    let delete = UIButton()
    
    init(vc: SelectedViewController) {
        self.vc = vc
        title = UITextField()
        //collectionView = UICollectionView(frame: .zero)
        description = UITextField()
        tags = UITextField()
    }
    
    func collectionViewSetup() {
        
        collectionView!.delegate = vc!
        collectionView!.dataSource = vc!
        collectionView!.isPagingEnabled = true
        collectionView!.register(SelectedCollectionViewCell.self, forCellWithReuseIdentifier: "selectedCell")
        

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: vc!.view.frame.width, height: vc!.view.frame.height / 2)
        layout.scrollDirection = .horizontal
        
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3

        collectionView!.collectionViewLayout = layout
    }
    
    func setup() {
        
        guard let view = vc!.view else {return}
        
        view.initSetup()
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: vc!.view.frame.width, height: vc!.view.frame.height / 2), collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewSetup()
        view.addSubview(collectionView!)
        
        //let dotsView = UIView()
        /*dotsView.backgroundColor = Constants.greyTrans
        view.addSubview(dotsView)
        dotsView.constraint(equalToBottom: collectionView!.bottomAnchor, paddingBottom: 16, width: 18 * CGFloat(urls.count), height: 20)
        dotsView.layer.cornerRadius = 10
        dotsView.centre(centerX: collectionView?.centerXAnchor)*/
        
        
        
        title.borderStyle = .none
        //title.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        //view.addSubview(title)
        //title.constraint(equalToTop: collectionView!.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16, height: 50)
        //title.layer.cornerRadius = 12
        title.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Title", targetString: "Title", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))//"Email"
        title.textColor = .white
        title.tintColor = .white
        title.font = Constants.regularFont(size: 12)
        
        let titleView = UIView()
        view.addSubview(titleView)
        titleView.constraint(equalToTop: collectionView!.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16, height: 50)
        titleView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        //mailview.alpha = 0.5
        titleView.layer.cornerRadius = 12
        
        titleView.addSubview(title)
        title.constraint(equalToTop: titleView.topAnchor, equalToBottom: titleView.bottomAnchor, equalToLeft: titleView.leadingAnchor, equalToRight: titleView.trailingAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8, height: 0)
        
        let backImage = UIImageView(image: UIImage(named: "Group 4"))
        backImage.frame = CGRect(x: 32, y: 103, width: 25, height: 25)
        view.addSubview(backImage)
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        
        
        upload.setTitle("Upload", for: .normal)
        upload.titleLabel?.font = Constants.boldFont(size: 12)
        upload.backgroundColor = Constants.navyBlue
        upload.titleLabel?.textColor = UIColor.white
        upload.layer.cornerRadius = 8
        upload.isUserInteractionEnabled = true
        //upload.addTarget(self, action: #selector(uploadAction), for: .touchUpInside)
        
        //let delete = UIButton()
        delete.setTitle("Delete", for: .normal)
        delete.titleLabel?.font = Constants.boldFont(size: 12)
        delete.backgroundColor = Constants.pink
        delete.titleLabel?.textColor = UIColor.white
        delete.layer.cornerRadius = 8
        delete.isUserInteractionEnabled = true
        //delete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        let stack2 = UIStackView(arrangedSubviews: [upload])
        stack2.axis = .horizontal
        stack2.spacing = 5
        //stack2.distribution = .fill
        stack2.spacing = 5
        view.addSubview(stack2)
        stack2.constraint(equalToBottom: view.bottomAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingBottom: 70, paddingLeft: 16, paddingRight: 16, height: 55)
        //view.addToSides(view: stack2, height: 20, topview: stack, padTop: 16)
        upload.constraint(width: 250)
        
        tags.borderStyle = .none
        //tags.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        //view.addSubview(tags)
        //tags.constraint(equalToBottom: stack2.topAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 50)
        tags.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Tags", targetString: "Tags", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))
        tags.layer.cornerRadius = 12
        tags.textColor = .white
        tags.font = Constants.regularFont(size: 12)
        //tags.isSecureTextEntry = true
        
        let tagsView = UIView()
        view.addSubview(tagsView)
        tagsView.constraint(equalToBottom: stack2.topAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height: 50)
        tagsView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        //mailview.alpha = 0.5
        tagsView.layer.cornerRadius = 12
        
        tagsView.addSubview(tags)
        tags.constraint(equalToTop: tagsView.topAnchor, equalToBottom: tagsView.bottomAnchor, equalToLeft: tagsView.leadingAnchor, equalToRight: tagsView.trailingAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8, height: 0)
        
        description.borderStyle = .none
        //description.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        //view.addSubview(description)
        //description.safeAreaInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        //description.constraint(equalToTop: title.bottomAnchor, equalToBottom: tags.topAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingTop: 12, paddingBottom: 12, paddingLeft: 16, paddingRight: 16)
        description.attributedPlaceholder = Manipulations.changeCharColor(fullString: "Description", targetString: "Description", color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5))//"Username"
        description.textColor = .white
        description.layer.cornerRadius = 12
        description.font = Constants.regularFont(size: 12)
        
        let descView = UIView()
        view.addSubview(descView)
        descView.constraint(equalToTop: title.bottomAnchor, equalToBottom: tags.topAnchor, equalToLeft: view.leadingAnchor, equalToRight: view.trailingAnchor, paddingTop: 12, paddingBottom: 12, paddingLeft: 16, paddingRight: 16)
        descView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        //mailview.alpha = 0.5
        descView.layer.cornerRadius = 12
        
        descView.addSubview(description)
        description.constraint(equalToTop: descView.topAnchor, equalToBottom: descView.bottomAnchor, equalToLeft: descView.leadingAnchor, equalToRight: descView.trailingAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8, height: 0)
    }
    
    
    
    @objc func goBack() {
        vc?.dismiss(animated: true)
    }
}
