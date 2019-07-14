//
//  MyTableViewCell.swift
//  Photo Share
//
//  Created by maurice on 7/11/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

	@IBOutlet weak var myImageView: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
