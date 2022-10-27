//
//  FeedCell.swift
//  Deneme
//
//  Created by melih ispir on 11.10.2022.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var feedTextView: UILabel!
    
    @IBOutlet weak var feedImage: UIImageView!
    
    @IBOutlet weak var feedText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
