//
//  FirstViewController.swift
//  MemeMe
//
//  Created by Julius Danek on 18.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    var memes: [Meme]!
    //date formatter
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //setting date format
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        //important to make sure that tableData refreshes after something has been added to the memes array
        tableView.reloadData()
        if memes.count == 0 {
            tableView.hidden = true
            labelText.hidden = false
            editButton.enabled = false
        } else {
            tableView.hidden = false
            labelText.hidden = true
            editButton.enabled = true
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TableViewCell") as! UITableViewCell
        cell.textLabel?.text = memes[indexPath.row].topText
        cell.imageView?.image = memes[indexPath.row].memedImage
        cell.detailTextLabel?.text = "Date created: \(dateFormatter.stringFromDate(memes[indexPath.row].dateCreated))"
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(70.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc: detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailVC") as! detailVC
        
        vc.meme = memes[indexPath.row]
        vc.index = indexPath.row
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: Edit view
    
    //tell table that it can edit all rows
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //edit button and start edit mode
    @IBAction func editTable(sender: UIBarButtonItem) {
        if self.tableView.editing {
            self.tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
        } else {
            self.tableView.setEditing(true, animated: true)
            editButton.title = "Done"
        }
    }
    
    //make sure that when leaving the view, the editing mode is exited
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.tableView.setEditing(false, animated: true)
        editButton.title = "Edit"
    }
    
    //delete from memes.count
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            memes.removeAtIndex(indexPath.row)
            //update the table and animate the deletion of the cell
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.endUpdates()
        }
        //if there are no more memes, end editing mode and disable the button and go back to default view
        if memes.count == 0 {
            self.tableView.setEditing(false, animated: false)
            editButton.title = "Edit"
            editButton.enabled = false
            self.tableView.hidden = true
            labelText.hidden = false
        }
    }
    
    
}

