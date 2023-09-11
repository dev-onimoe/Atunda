//
//  SelectedCollectionViewCell.swift
//  Atunda
//
//  Created by Mas'ud on 9/22/22.
//

import UIKit
import AVFoundation

class SelectedCollectionViewCell: UICollectionViewCell {
   
    var player : AVPlayer?
    var playerLayer : AVPlayerLayer?
    var thumbnail = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let thumbnail = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        //view.frame = self.frame
        //thumbnail.backgroundColor = .red
        thumbnail.contentMode = .scaleAspectFit
        //self.addSubview(thumbnail)
        
        /*playerLayer.removeFromSuperlayer()
        //player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = backView.bounds
        playerLayer.videoGravity = .resizeAspectFill
         backView.layer.insertSublayer(playerLayer, at: 0)*/
        //backView.layer.addSublayer(playerLayer)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
