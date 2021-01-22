//
//  FrendsTableViewCell.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 05.11.2020.
//
import UIKit
import Kingfisher

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendImageView: AvatarImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    public func configure(with user: User) {
        friendNameLabel.text = "\(user.first_name) \(user.last_name)"
        friendImageView.kf.setImage(with: URL(string: user.avatar))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    


}
