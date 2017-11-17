//
//  PlacesViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 15/11/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet var collectionview: UICollectionView!
    struct Place
    {
        var flag:UIImage
        var name:String
        init(name:String, flag:UIImage)
        {
            self.name = name
            self.flag = flag
        }
    }
    
    var Data:Array<  Place > = Array < Place >()

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        collectionview.reloadData()

        // Do any additional setup after loading the view.
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath as IndexPath) as! PlaceCell
        
        
        let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        
        cell.layer.borderColor = bcolor.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        
        cell.backgroundColor=UIColor.white
        
        
//        cell.imgFlage.image =  Data[indexPath.row].flag
//        cell.lblName.text = Data[indexPath.row].name

        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 94  , height: 112)
        
    }
    

    

}
