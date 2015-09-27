//
//  ViewController.swift
//  MemeMe
//
//  View Controller used to generate memes
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
    
    var newMeme: Meme!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 45)!,
        NSStrokeWidthAttributeName : -5
    ]
    
    /* Overridden functions */
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func shouldAutorotate() -> Bool {
        if (bottomText.editing || topText.editing) {
            return false
        }
        else {
            return super.shouldAutorotate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set defaults for top
        topText.text = "TOP"
        setDefaultsForTextViews(topText)
        //Set default bottom text
        bottomText.text = "BOTTOM"
        setDefaultsForTextViews(bottomText)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //If the imagePickerView is still nil, don't enable share
        if(imagePickerView.image == nil){
            shareButton.enabled = false
        }
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    /* IBActions */
    @IBAction func pickAnImage(sender: AnyObject) {
        getImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func takeACameraPhoto(sender: AnyObject) {
        getImage(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func shareImage(sender: AnyObject) {
        let image = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareController.completionWithItemsHandler = {
            activity, success, items, error in
            if success {
                self.save(image)
            }
        }
        presentViewController(shareController, animated: true, completion: nil)
    }
    @IBAction func clearTextAndImage(sender: AnyObject) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imagePickerView.image = nil
        shareButton.enabled = false
    }
    
    /* Image Selection */
    
    //launches the appropriate image source to get a picture
    func getImage(sourceType : UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.enabled = true
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* Text field delegates */
    
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
    
    /* Keyboard actions to slide ui up/down */
    
    func keyboardWillShow(notification: NSNotification) {
        if(bottomText.editing){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    /* Subscribe and Unsubscribe from notifications */
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /* Saving and Sharing Meme */
    
    func save(memeImage: UIImage) {
        newMeme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memeImage: memeImage)
    }
    
    //Generates a UIImage containing the image and text
    func generateMemedImage() -> UIImage {
        
        //Hide toolbars
        toggleToolbars(true)
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toggleToolbars(false)
        return memedImage
    }
    
    /* Misc UI */
    func toggleToolbars(shouldHide: Bool) {
        toolBar.hidden = shouldHide
        toolBarTop.hidden = shouldHide
    }
    
    func setDefaultsForTextViews(textView : UITextField) {
        textView.defaultTextAttributes = memeTextAttributes
        textView.textAlignment = .Center
        textView.delegate = self
    }
    
}

