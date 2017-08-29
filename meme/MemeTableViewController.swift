//
//  MemeTableViewController.swift
//  meme
//
//  Created by Tiago Missão on 28/08/17.
//  Copyright © 2017 missao. All rights reserved.
//

import UIKit


/// Meme Table View
class MemeTableViewController: UIViewController {
  
  @IBOutlet weak var tableMeme: UITableView!
  fileprivate var memes: [Meme]!
  fileprivate let cellIdentifier = "memeTableCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    memes = AppDelegate.shared.memes
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    memes = AppDelegate.shared.memes
    tableMeme.reloadData()
  }
}


// MARK: - UITableViewDelegate
extension MemeTableViewController: UITableViewDelegate {

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let meme = memes[indexPath.row]
    let viewController = storyboard?.instantiateViewController(withIdentifier: MemeDetailViewController.viewControllerIdentifier) as! MemeDetailViewController
    
    viewController.meme = meme
    navigationController?.pushViewController(viewController, animated: true)
  }
}


// MARK: - UITableViewDataSource
extension MemeTableViewController: UITableViewDataSource {

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memes.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let meme = memes[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MemeTableViewCell
    
    cell.imgMeme.image = meme.memedImage
    cell.textMeme.text = "\(meme.topText) \(meme.bottomText)"
    return cell
  }

}
