//
//  TopRatedViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 16/11/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var collectionview: UICollectionView!
    struct TopRatedRoom
    {
        var imgRoom:UIImage
        var name:String
        var price:String
        init(name:String, imgRoom:UIImage,price:String)
        {
            self.name = name
            self.imgRoom = imgRoom
            self.price = price
        }
    }
    
    var Data:Array<  TopRatedRoom > = Array < TopRatedRoom >()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.reloadData()

        // Do any additional setup after loading the view.
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedCell", for: indexPath as IndexPath) as! TopRatedCell
        
        
        let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        
        cell.layer.borderColor = bcolor.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        
        cell.backgroundColor=UIColor.white
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 160  , height: 211)
        
    }

 

}
