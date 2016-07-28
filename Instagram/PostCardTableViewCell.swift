//
//  PostCardTableViewCell.swift
//  Instagram
//
//  Created by Chun Tai on 2016/7/28.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class PostCardTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
