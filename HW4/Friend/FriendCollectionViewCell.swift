//
//  FriendCollectionViewCell.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 16.12.2020.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    var friends = Friends()
    

    @IBOutlet weak var friendImageView: UIImageView!
    
    @IBOutlet weak var friendNameLabel: UILabel!
    
}
