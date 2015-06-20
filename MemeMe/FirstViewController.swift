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
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        if memes.count != 0 {
            tableView.hidden = false
            labelText.hidden = true
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TableViewCell") as! UITableViewCell
        cell.textLabel?.text = memes[indexPath.row].topText
        cell.imageView?.image = memes[indexPath.row].memedImage
        //separator insets to zero in order to have line stretch across full view
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc: detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailVC") as! detailVC
        
        vc.meme = memes[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

