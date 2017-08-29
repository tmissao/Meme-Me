//
//  MemeDetailViewController.swift
//  meme
//
//  Created by Tiago Missão on 29/08/17.
//  Copyright © 2017 missao. All rights reserved.
//

import UIKit


/// Show Meme Detail
class MemeDetailViewController: UIViewController {
  
  @IBOutlet weak var imgMeme: UIImageView!
  
  static let viewControllerIdentifier = "MemeDetailViewController"
  
  var meme: Meme!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    imgMeme.image = meme.memedImage
  }
  
}
