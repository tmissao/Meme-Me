//
//  structs.swift
//  meme
//
//  Created by Tiago Missão on 08/08/17.
//  Copyright © 2017 missao. All rights reserved.
//

import UIKit
import Foundation

struct Meme {
  
  let topText: String
  
  let bottomText: String
  
  let originalImage: UIImage
  
  let memedImage: UIImage
  
  init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
    self.topText = topText
    self.bottomText = bottomText
    self.originalImage = originalImage
    self.memedImage = memedImage
  }
}
