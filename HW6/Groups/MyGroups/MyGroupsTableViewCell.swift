//
//  MyGroupsTableViewCell.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 16.12.2020.
//
import UIKit

class MyGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var GroupImage: UIImageView!
    @IBOutlet weak var GroupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with group: Group) {
        GroupName.text = "\(group.name)"
        GroupImage.kf.setImage(with: URL(string: group.photo))
    }

}
