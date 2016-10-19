//
//  ChatTableViewCell.swift
//  MiniChat
//
//  Created by Akkshay Khoslaa on 10/18/16.
//  Copyright © 2016 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    var profPicImageView: UIImageView!
    var usernameLabel: UILabel!
    var contentLabel: UILabel!
    var timeAgoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        profPicImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        profPicImageView.contentMode = .scaleAspectFill
        profPicImageView.layer.cornerRadius = profPicImageView.frame.width/2
        profPicImageView.clipsToBounds = true
        contentView.addSubview(profPicImageView)
        
        usernameLabel = UILabel(frame: CGRect(x: profPicImageView.frame.maxX + 10, y: 17, width: frame.width - profPicImageView.frame.width - 17, height: 15))
        usernameLabel.textColor = UIColor.gray
        usernameLabel.font = UIFont(name: "SFUIText-Medium", size: 15)
        contentView.addSubview(usernameLabel)
        
        contentLabel = UILabel(frame: CGRect(x: profPicImageView.frame.maxX + 10, y: usernameLabel.frame.maxY - 7, width: frame.width - profPicImageView.frame.width - 17, height: 40))
        contentLabel.textColor = UIColor.lightGray
        contentLabel.font = UIFont(name: "SFUIText-Regular", size: 13.5)
        contentView.addSubview(contentLabel)
        
        timeAgoLabel = UILabel(frame: CGRect(x: self.frame.width - 90, y: 10, width: 80, height: 15))
        timeAgoLabel.textColor = UIColor.lightGray
        timeAgoLabel.textAlignment = .right
        timeAgoLabel.font = UIFont(name: "SFUIText-Regular", size: 12)
        contentView.addSubview(timeAgoLabel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
