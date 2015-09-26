//
//  ViewController.swift
//  MemeMe
//
//  Created by Christopher Luc on 9/20/15.
//  Copyright © 2015 Christopher Luc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var toolBarTop: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 45)!,
        NSStrokeWidthAttributeName : -5
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        topText.defaultTextAttributes = memeTextAttributes;
        topText.textAlignment = .Center
        topText.text = "TOP"
        topText.delegate = self
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .Center
        bottomText.text = "BOTTOM"
        bottomText.delegate = self
        if(imagePickerView.image == nil){
            shareButton.enabled = false
        }
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        getImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func takeACameraPhoto(sender: AnyObject) {
        getImage(UIImagePickerControllerSourceType.Camera)
    }
    
    func getImage(sourceType : UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            self.shareButton.enabled = true
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareImage(sender: AnyObject) {
        let image = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(shareController, animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == topText && textField.text == "" {
            textField.text = "TOP"
        }
        else if textField == bottomText && textField.text == "" {
            textField.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if(bottomText.editing){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(bottomText.editing) {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func save() {
        //Create the meme
        let newMeme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memeImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        toolBar.hidden = true
        toolBarTop.hidden = true
        
        // TODO: Hide toolbar and navbar
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolBar.hidden = false
        toolBarTop.hidden = false
        return memedImage
    }
    
}

