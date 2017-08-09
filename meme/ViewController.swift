//
//  ViewController.swift
//  meme
//
//  Created by Tiago Missão on 07/08/17.
//  Copyright © 2017 missao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var imgMeme: UIImageView!
  @IBOutlet weak var container: UIView!
  @IBOutlet weak var textTop: UITextField!
  @IBOutlet weak var textBottom: UITextField!
  @IBOutlet weak var btnCamera: UIBarButtonItem!
  @IBOutlet weak var btnShare: UIBarButtonItem!
  @IBOutlet weak var btnCancel: UIBarButtonItem!
  
  private let defaultTopText = "TOP"
  private let defaultBottomText = "BOTTOM"
  private let fontSize: CGFloat = 40
  private let strokeWidth: CGFloat = -3
  private let fontName = "HelveticaNeue-CondensedBlack"
  
  var activeTextField: UITextField?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    subscribeToKeyboardNotifications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    unsubscribeFromKeyboardNotification()
  }
  
  
  /// Configures UI initial state
  private func configureUI() {
    configureTextField(textTop)
    configureTextField(textBottom)
    reset()
  }
  
  
  /// Defines textfield's text attributes
  ///
  /// - Parameter textfield: textfield that will be configured
  private func configureTextField(_ textfield: UITextField) {
    textfield.delegate = self
    textfield.defaultTextAttributes = getTextStyle()

  }
  
  
  /// Presents an UIImagePickerController, setting the current viewcontroller as its delegate
  ///
  /// - Parameter type: source type of the UIImagePickerController
  private func presentUIImagePickerController(type: UIImagePickerControllerSourceType) {
    let picker = UIImagePickerController()
    picker.sourceType = type
    picker.delegate = self
    
    present(picker, animated: true, completion: nil)
  }
  
  /// Enables user to take a photo using his camera
  private func getImageFromCamera() {
    presentUIImagePickerController(type: .camera)
  }
  
  
  /// Enables user to get an image from his photo library
  private func getImageFromLibrary() {
    presentUIImagePickerController(type: .photoLibrary)
  }
 
  
  /// Checks if the Share button should be enabled
  fileprivate func shouldEnableShareButton() {
    let enabled = imgMeme.image != nil
    btnShare.isEnabled = enabled
  }
  
  
  /// Checks if the Cancel button should be enabled
  fileprivate func shouldEnableCancelButton() {
    let enabled = imgMeme.image != nil || textBottom.text != defaultTopText || textTop.text != defaultBottomText
    btnCancel.isEnabled = enabled
  }
  
  /// Shares built meme
  private func shareMeme() {
    let meme = buildMemeImage()
    let activityView = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
    present(activityView, animated: true) {
      self.saveMeme(meme: meme)
    }
  }
  
  
  /// Saves Meme
  private func saveMeme(meme: UIImage) {
    let _ = Meme(topText: textTop.text!, bottomText: textBottom.text!, originalImage: imgMeme.image!, memedImage: meme)
  }

  
  /// Builds the meme image
  ///
  /// - Returns: meme image
  private func buildMemeImage() -> UIImage {
    UIGraphicsBeginImageContext(container.frame.size)
    container.drawHierarchy(in: container.frame, afterScreenUpdates: true)
    let meme = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return meme
  }
  
  /// Resets viewcontroller components to their original state
  private func reset() {
    textTop.text = defaultTopText
    textBottom.text = defaultBottomText
    imgMeme.image = nil
    btnShare.isEnabled = false
    btnCancel.isEnabled = false
    btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
  }
  
  
  /// Obtains Textfield's text style
  ///
  /// - Returns: Dictionary representing textfield's style
  private func getTextStyle() -> [String:Any] {
    return [
      NSFontAttributeName: UIFont(name: fontName, size: fontSize)!,
      NSStrokeWidthAttributeName: strokeWidth,
      NSParagraphStyleAttributeName: getParagraphStyle(),
      NSStrokeColorAttributeName : UIColor.black,
      NSForegroundColorAttributeName: UIColor.white,
    ]
  }
  
  
  /// Obtains TextField's paragraph style
  ///
  /// - Returns: NSMutableParagraphStyle with center alignment
  private func getParagraphStyle() -> NSMutableParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center

    return paragraphStyle
  }
  
  
  /// Handles Keyboard WillShow Notification, moving view's frame up
  ///
  /// - Parameter notification: system notification
  @objc private func keyboardWillShow(notification: NSNotification) {
    guard self.view.frame.origin.y == 0 else {return}

    let keyboardSize = getKeyboardHeight(notification: notification)
    var aRect = self.view.frame
    aRect.size.height -= keyboardSize
    
    if let textField = activeTextField, !aRect.contains(textField.frame.origin) {
      self.view.frame.origin.y -= keyboardSize
    }
  }
  
  
  /// Handles Keyboard WillHide Notification, moving view's frame down
  ///
  /// - Parameter notification: system notification
  @objc private func keyboardWillHide(notification: NSNotification) {
    guard self.view.frame.origin.y != 0 else {return}
    self.view.frame.origin.y += getKeyboardHeight(notification: notification)
  }
  
  
  /// Obtains Keyboard Height information from notification
  ///
  /// - Parameter notification: system notification
  /// - Returns: Keyboard's height
  private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.cgRectValue.height
  }
  
  
  /// Subscribe for Keyboard WillShow and WillHide notifications
  func subscribeToKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                           name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                           name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
  }
  
  
  /// Unsubscribe from Keyboard WillShow and WillHide notification
  func unsubscribeFromKeyboardNotification() {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }

  // MARK: UIActions
  
  @IBAction func resetView(_ sender: Any) {
    reset()
  }

  @IBAction func getImageFromCamera(_ sender: Any) {
    getImageFromCamera()
  }
  
  @IBAction func getImageFromLibrary(_ sender: Any) {
    getImageFromLibrary()
  }
  
  @IBAction func share(_ sender: Any) {
    shareMeme()
  }
}


// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
  
  private func dismiss(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(picker)
  }
  
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
    imgMeme.image = image
    shouldEnableShareButton()
    shouldEnableCancelButton()
    dismiss(picker)
  }
}


// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {}


// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
  
  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    activeTextField = textField
    return true
  }

  public func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.text = ""
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    shouldEnableCancelButton()
    activeTextField = nil
  }
}

