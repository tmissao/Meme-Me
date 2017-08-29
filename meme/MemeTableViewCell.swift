//
//  MemeTableViewCell.swift
//  meme
//
//  Created by Tiago Missão on 28/08/17.
//  Copyright © 2017 missao. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

  @IBOutlet weak var imgMeme: UIImageView!
  @IBOutlet weak var textMeme: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
