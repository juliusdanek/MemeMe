//
//  detailVC.swift
//  MemeMe
//
//  Created by Julius Danek on 19.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import UIKit

class detailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var meme: Meme!
    //send the index number from the table to know which meme to delete in case of deletion
    var index: Int!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        imageView.image = meme.memedImage
        //hide tab bar
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //make it appear again when navigating away
        self.tabBarController?.tabBar.hidden = false
    }
    
    //MARK: Edit the image
    @IBAction func editImage(sender: UIBarButtonItem) {
        performSegueWithIdentifier("editSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //instantiate the nav controller
        let navControl: UINavigationController = segue.destinationViewController as! UINavigationController
        
        //instantiate the viewcontroller from the array of VCs that the navController holds
        let controller: MemeEditor = navControl.viewControllers[0] as! MemeEditor
        
        //give the editor the meme
        controller.editMeme = self.meme
    }
    
    //MARK: Delete Button
    @IBAction func deleteButton(sender: UIBarButtonItem) {
        var alertView = UIAlertController(title: "Delete Image", message: "Do you want to delete this image?", preferredStyle: UIAlertControllerStyle.Alert)
        
        //defining a closure as action handler
        let deleteImage = { (action: UIAlertAction!) -> Void in
                var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.memes.removeAtIndex(self.index)
                //pop back onto the root viewcontroller
                self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        //implement delete action and handler
        alertView.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: deleteImage))
        
        //implement cancel action
        alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
}
