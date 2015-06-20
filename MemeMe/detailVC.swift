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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        imageView.image = meme.memedImage
    }
    
    @IBAction func editImage(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("editSegue", sender: sender)
        
//        let editVC: MemeEditor = self.storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as! MemeEditor
//        
//        editVC.editMeme = meme
//        
//        self.navigationController?.presentViewController(editVC, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navControl: UINavigationController = segue.destinationViewController as! UINavigationController
        
        let controller: MemeEditor = navControl.viewControllers[0] as! MemeEditor
        
        controller.editMeme = self.meme
        println("success")
    }
    
    
    
}
