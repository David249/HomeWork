//
//  FriendCollectionViewCell.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 16.12.2020.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
//    var friends = Friends()
    
    @IBOutlet weak var friendImageView: UIImageView!
    
    public func configure(with photo: Photo) {
        friendImageView.kf.setImage(with: URL(string: photo.url))
    }
    
}
