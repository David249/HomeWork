//
//  AvailableGroupTableViewCell.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 16.12.2020.
//

import UIKit

class AvailableGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var NotInGroupLabel: UILabel!
    @IBOutlet weak var AvailableGroupImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with group: Group) {
        NotInGroupLabel.text = "\(group.name)"
        AvailableGroupImageView.kf.setImage(with: URL(string: group.photo))
    }

}
