//
//  MemeEditor.swift
//  MemeMe
//
//  Created by Julius Danek on 18.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import UIKit

class MemeEditor: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //instantiating imagePickerController
    let imagePicker = UIImagePickerController()
    
    //having a meme in case you edit from detail view
    var editMeme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        topField.delegate = self
        bottomField.delegate = self
        //defining text here so edits do not get lost when loading image
        if let editedMeme = editMeme {
            self.topField.text = editedMeme.topText
            self.bottomField.text = editedMeme.bottomText
            self.imageDisplay.image = editedMeme.image
        } else {
            self.topField.text = "TOP"
            self.bottomField.text = "BOTTOM"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //Check wehther sourcetype camera is available. If not, disable the button.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        self.bottomField.defaultTextAttributes = memeTextAttributes
        self.bottomField.textAlignment = .Center
        self.topField.defaultTextAttributes = memeTextAttributes
        self.topField.textAlignment = .Center
        self.subscribeToKeyboardNotifications()
        if imageDisplay.image == nil {
            actionButton.enabled = false
        } else {
            actionButton.enabled = true
        }
    }
    
    //unsubscribing from notifications. Very important, otherwise notificiations get sent double when imagePicker returns to view
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //dismiss viewController through cancel button
    @IBAction func dismissView(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Text Field Code
    
    //Editing of field begins, replace text if TOP or BOTTOM
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topField && topField.text == "TOP" {
            topField.text = ""
        } else if textField == bottomField && bottomField.text == "BOTTOM" {
            bottomField.text = ""
        }
    }
    
    //checking whether textfield is empty after editing has ended. If yes, replace with default text.
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == topField && topField.text == "" {
            topField.text = "TOP"
        } else if textField == bottomField && bottomField.text == "" {
            bottomField.text = "BOTTOM"
        }
    }
    
    //Resign firstResponder (keyboard) in event that enter is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Keyboard hider
    
    //subscribe to notifications when keyboard hides or shows
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        println("showing Keyboard")
        if bottomField.isFirstResponder() {
            println("origin y is \(self.view.frame.origin.y)")
            println("keyBoardHeight is \(getKeyboardHeight(notification))")
            self.view.frame.origin.y -=  getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        println("hiding Keyboard")
        if bottomField.isFirstResponder() {
            println(self.view.frame.origin.y)
            println(getKeyboardHeight(notification))
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //MARK: Image Code
    //TODO: Check whether editing function actually makes sense or not.
    
    //check whether image has been picked.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //if image has been edited, display edited image.
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageDisplay.image = pickedImage
        //else: display original image (in case of camera roll)
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageDisplay.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    //function to pick image based on source type, shows viewcontroller for imagepicker
    func chooseImage(sourceType: UIImagePickerControllerSourceType, editing: Bool) {
        imagePicker.allowsEditing = editing
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //implementation for pic from library
    @IBAction func imageFromRoll(sender: UIBarButtonItem) {
        chooseImage(.PhotoLibrary, editing: true)
    }
    
    //implementation for pic from camera
    @IBAction func imageFromCamera(sender: UIBarButtonItem) {
        chooseImage(.Camera, editing: false)
    }
    
    //MARK: Save Meme
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        toolBar.hidden = true
        self.navigationController?.navigationBar.hidden = true
        
        // Render view to an image
        var frameSize = self.view.frame.size
        UIGraphicsBeginImageContext(frameSize)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        toolBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        var meme = Meme(bottomText: bottomField.text, topText: topField.text, image: imageDisplay.image!, memedImage: memedImage)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func shareAction(sender: UIBarButtonItem) {
        var generatedMeme = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [generatedMeme], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
        //completition handler, saves meme to meme roll.
        activityController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            if ok {
                //TODO: Make sure that memes are not saved twice or more. Either by dismissing viewcontroller completely or by checking in array.
                println("completed \(s) \(ok) \(items) \(err)")
                self.save(generatedMeme)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
}