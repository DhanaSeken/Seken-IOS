//
//  ContryCodeModalVC.swift
//  Seken
//
//  Created by Seken InfoSys on 17/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import MICountryPicker

protocol ContryCodeModalVCDelegate: class{
    func sendCountryImag(img:UIImage,countryCode:String)
}

class ContryCodeModalVC: SekenViewController,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblCountryList: UITableView!
    var otherCountryCodeList:[CountryCode] = []
    var topCountryCodeList:[CountryCode] = []
    var filteredotherCountryCodeList:[CountryCode] = []
    var filteredtopCountryCodeList:[CountryCode] = []
    weak var delegate: ContryCodeModalVCDelegate?
     let searchController = UISearchController(searchResultsController: nil)
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tblCountryList?.tableHeaderView = searchController.searchBar
        // self.tblCountryList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.getArrayList()
        
    }
    
    
    func getArrayList()  {
        let resourceBundle = Bundle(for: MICountryPicker.classForCoder())
        // guard let path = resourceBundle.path(forResource: "CallingCodes", ofType: "plist") else { return [] }
        
        guard let path = resourceBundle.path(forResource: "CallingCodes", ofType: "plist") else {
            return
        }
        if let array = NSArray(contentsOfFile: path) as? [[String: String]] {
            
            for var dict:[String:String] in array {
                let countryCode = CountryCode(code: dict["code"]!, name: dict["name"]!, dialCode: dict["dial_code"]!)
                
                otherCountryCodeList.append(countryCode)
            }
            
            
            
            // otherCountryCodeList = [array]
            print("\(otherCountryCodeList)")
        }
        
         let resourceBundle1 = Bundle(for: MICountryPicker.classForCoder())
        guard let path1 = resourceBundle1.path(forResource: "TopCallingCodes", ofType: "plist") else {
            return
        }
        
       
        if let array1 = NSArray(contentsOfFile: path1) as? [[String: String]] {
            
            for var dict:[String:String] in array1 {
                let countryCode = CountryCode(code: dict["code"]!, name: dict["name"]!, dialCode: dict["dial_code"]!)
                
                topCountryCodeList.append(countryCode)
            }
             print("\(topCountryCodeList)")
        }
        filteredtopCountryCodeList = topCountryCodeList
        filteredotherCountryCodeList = otherCountryCodeList
        
         self.tblCountryList.reloadData()
    }
    
    // MARK: - Private instance methods
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredtopCountryCodeList = topCountryCodeList
            filteredotherCountryCodeList = otherCountryCodeList
        } else {
            
            
            filteredtopCountryCodeList = topCountryCodeList.filter({( countryCode : CountryCode) -> Bool in

                return countryCode.name.lowercased().contains(searchController.searchBar.text!.lowercased())
            })

            filteredotherCountryCodeList = otherCountryCodeList.filter({( countryCode : CountryCode) -> Bool in

               return countryCode.name.lowercased().contains(searchController.searchBar.text!.lowercased())
            })
           
        }
        
        self.tblCountryList.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filteredtopCountryCodeList.count
        }else {
            return filteredotherCountryCodeList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCodeCell
        cell.lblCountryName?.text = ""
        cell.lblDialCode?.text = ""
        cell.imgCountry!.image = UIImage.init(named: "")
        if indexPath.section == 0 {
            cell.lblCountryName?.attributedText = self.getFinalString(name: self.filteredtopCountryCodeList[indexPath.row].name, dialCode: self.filteredtopCountryCodeList[indexPath.row].dialCode)
            //cell.lblDialCode?.text = self.filteredtopCountryCodeList[indexPath.row].dialCode
            let bundle = "assets.bundle/"
            cell.imgCountry!.image = UIImage(named: bundle + self.filteredtopCountryCodeList[indexPath.row].code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
        }else {
            cell.lblCountryName?.attributedText = self.getFinalString(name: self.filteredotherCountryCodeList[indexPath.row].name, dialCode: self.filteredotherCountryCodeList[indexPath.row].dialCode)
           // cell.lblDialCode?.text = self.filteredotherCountryCodeList[indexPath.row].dialCode
            let bundle = "assets.bundle/"
            cell.imgCountry!.image = UIImage(named: bundle + self.filteredotherCountryCodeList[indexPath.row].code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
        }
      
        
        return cell
    }
    
    
    func getFinalString(name:String,dialCode:String) -> NSMutableAttributedString {
        
        let nameColor = UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1.0)
         let codeColor = UIColor(red: 94/255, green: 149/255, blue: 194/255, alpha: 1.0)
        
        let yourAttributes = [NSAttributedStringKey.foregroundColor: nameColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        let yourOtherAttributes = [NSAttributedStringKey.foregroundColor: codeColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        
        let partOne = NSMutableAttributedString(string: name, attributes: yourAttributes)
         let partThree = NSMutableAttributedString(string: " (", attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: dialCode, attributes: yourOtherAttributes)
        let partFour = NSMutableAttributedString(string: " )", attributes: yourAttributes)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partThree)
        combination.append(partTwo)
        combination.append(partFour)
        return combination
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Top Countries"
        }else {
             return "Other Countries"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
        var imgName: UIImage
        var dialCode:String
        if indexPath.section == 0 {
            let bundle = "assets.bundle/"
            imgName = UIImage(named: bundle + self.filteredtopCountryCodeList[indexPath.row].code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)!
            dialCode = self.filteredtopCountryCodeList[indexPath.row].dialCode
        }else {
            let bundle = "assets.bundle/"
            imgName = UIImage(named: bundle + self.filteredotherCountryCodeList[indexPath.row].code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)!
             dialCode = self.filteredotherCountryCodeList[indexPath.row].dialCode
        }
        self.dismiss(animated: true, completion: {
                    self.delegate?.sendCountryImag(img: imgName, countryCode: dialCode)

            })
        
    
    }
    
    @IBAction func cancelButtonTouchupInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
    



