//
//  TopRatedViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 16/11/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import SekenSDK
import SDWebImage

class TopRatedViewController: SekenViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var collectionview: UICollectionView!
    @IBOutlet var noElementLabe: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    struct TopRatedRoom
    {
        var imgRoom:String
        var name:String
        var price:String
        var favouraite:String
        var PropertyID:String
        init(name:String, imgRoom:String,price:String,favouraite:String,PropertyID:String)
        {
            self.name = name
            self.imgRoom = imgRoom
            self.price = price
            self.favouraite = favouraite
            self.PropertyID = PropertyID
        }
    }
    
    var Data:Array<  TopRatedRoom > = Array < TopRatedRoom >()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.reloadData()
         self.noElementLabe.isHidden = true;

        // Do any additional setup after loading the view.
    }
    
    func refreshCollectionView(hotelRooms:[HotelRoom])  {
      
 
        if hotelRooms.count == 0{
              self.noElementLabe.isHidden = false;
        }else{
            self.noElementLabe.isHidden = true;
            for var hotelRoomInstance:HotelRoom in hotelRooms {
                let add_it = TopRatedRoom(name: hotelRoomInstance.name, imgRoom: hotelRoomInstance.image, price: hotelRoomInstance.price, favouraite: hotelRoomInstance.favourite,PropertyID:hotelRoomInstance.propertyID)
                Data.append(add_it)
                
            }
            collectionview.reloadData()
     }
       
   }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedCell", for: indexPath as IndexPath) as! TopRatedCell
        
        
        let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        
        cell.layer.borderColor = bcolor.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        
        cell.backgroundColor=UIColor.white
        cell.lblName.text =  Data[indexPath.row].name
        cell.imgRoom.sd_setImage(with: URL(string: Data[indexPath.row].imgRoom), placeholderImage: UIImage(named: "riyadh"))
        cell.lblPrice.text = String(format: "ر.س%@/night.",Data[indexPath.row].price)
        cell.btnFavourate.tag = indexPath.row
        if Data[indexPath.row].favouraite == "0" {
              cell.btnFavourate.setImage(UIImage(named:"favourte"), for: .normal)
        }else{
             cell.btnFavourate.setImage(UIImage(named:"favourite_selected"), for: .normal)
        }
        cell.btnFavourate.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonTapped(sender : UIButton) {
        //Write button action here
        let buttonTag = sender.tag
        self.showActivityIndicator()
        DashboardAPI.sharedAPI.performFavoutaiteRoom(ProprtyID: Data[buttonTag].PropertyID, status: Data[buttonTag].favouraite, method: "POST", successHandler: {
            self.hideActivityIndicator()
            
            if self.Data[buttonTag].favouraite == "0" {
                let add_it = TopRatedRoom(name: self.Data[buttonTag].name, imgRoom: self.Data[buttonTag].imgRoom, price: self.Data[buttonTag].price, favouraite: "1",PropertyID:self.Data[buttonTag].PropertyID)
                self.Data[buttonTag] = add_it
                self.collectionview.reloadData()
            }else{
                let add_it = TopRatedRoom(name: self.Data[buttonTag].name, imgRoom: self.Data[buttonTag].imgRoom, price: self.Data[buttonTag].price, favouraite: "0",PropertyID:self.Data[buttonTag].PropertyID)
                self.Data[buttonTag] = add_it
                self.collectionview.reloadData()
            }
           
            
        }, failureHandler: { errorMessage in
            self.hideActivityIndicator()
            
        }, env: .dev)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Data.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 160  , height: 211)
        
    }

 

}
