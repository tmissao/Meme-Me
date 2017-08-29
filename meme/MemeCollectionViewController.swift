//
//  MemeCollectionViewController.swift
//  meme
//
//  Created by Tiago Missão on 28/08/17.
//  Copyright © 2017 missao. All rights reserved.
//

import UIKit


/// MemeCollection 
class MemeCollectionViewController: UICollectionViewController {
  
  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  
  let cellIdentifier = "MemeCollectionViewCell"
  
  var memes: [Meme]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    memes = AppDelegate.shared.memes
    configureCollectionLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    memes = AppDelegate.shared.memes
    collectionView?.reloadData()
  }
  
  
  /// Reconfigures collection layout
  override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    configureCollectionLayout()
  }
  
  
  /// Configures Collection Layout Dimension and space between cells
  private func configureCollectionLayout() {
    let cells: CGFloat = view.frame.size.width > view.frame.size.height ? 5.0 : 3.0
    let space: CGFloat = 3.0
    let dimension = (view.frame.size.width - ((cells + 1) * space)) / cells
    
    flowLayout.minimumInteritemSpacing = space
    flowLayout.minimumLineSpacing = space
    flowLayout.itemSize = CGSize(width: dimension, height: dimension)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memes.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let meme = memes[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MemeCollectionViewCell
    cell.imgMeme.image = meme.memedImage
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let meme = memes[indexPath.row]
    let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
    
    detailViewController.meme = meme
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}
