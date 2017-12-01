//
//  PlacesViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 15/11/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import SekenSDK
import SDWebImage

class PlacesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet var collectionview: UICollectionView!
     @IBOutlet var lblTitle: UILabel!
     @IBOutlet weak var noElementLabel: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
     
    
    struct Place
    {
        var flag:String
        var name:String
        var lat:String
        var long:String
        init(name:String, flag:String,long:String,lat:String)
        {
            self.name = name
            self.flag = flag
            self.long = long
            self.lat = lat
            
        }
    }
    
    var Data:Array<  Place > = Array < Place >()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noElementLabel.isHidden = true;
        collectionview.reloadData()

        // Do any additional setup after loading the view.
    }
    
   func refreshCollectionView(localities:[Locality])  {
    
    if localities.count == 0{
        self.noElementLabel.isHidden = false;
    }else{
        self.noElementLabel.isHidden = true;
        for var locality:Locality in localities {
            let add_it = Place(name: locality.name, flag: locality.imagURL, long: locality.lat, lat: locality.long)
            Data.append(add_it)
            
        }
        collectionview.reloadData()
    }
    
        
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath as IndexPath) as! PlaceCell
        
        
        let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        
        cell.layer.borderColor = bcolor.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        
        cell.backgroundColor=UIColor.white
        cell.imgFlag.sd_setImage(with: URL(string: Data[indexPath.row].flag), placeholderImage: UIImage(named: "riyadh"))
        cell.lblName.text =  Data[indexPath.row].name


        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Data.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 94  , height: 112)
        
    }
    

    

}
