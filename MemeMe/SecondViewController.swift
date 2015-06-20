//
//  SecondViewController.swift
//  MemeMe
//
//  Created by Julius Danek on 18.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        collectionView.reloadData()
        if memes.count != 0 {
            collectionView.hidden = false
            labelText.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Collection view methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: MemeCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! MemeCell
        cell.imageView.image = memes[indexPath.row].memedImage
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let vc: detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailVC") as! detailVC
        
        vc.meme = memes[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }


}

