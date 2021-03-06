//
//  SearchLocationViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 15/11/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import Eureka
import SekenSDK
import SDWebImage
import GooglePlaces
import CoreLocation

class SearchLocationViewController: SekenViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    var recentSearches:[Locality] = []
    var topCities:[Locality] = []
    var locManager: CLLocationManager!
    var lat = ""
    var lng = ""
    var city = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
           UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 65/255, green: 154/255, blue: 198/255, alpha: 1.0)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshTableView()
    }
    
    func refreshTableView() {
        self.showActivityIndicator()
        DashboardAPI.sharedAPI.performGetTopLocalities(method: "POST", successHandler: { toplocalities in
              self.hideActivityIndicator()
            self.topCities = toplocalities.localities
            self.recentSearches = toplocalities.recent
            self.tableview.reloadData()
        }, failureHandler: { errormessage in
             self.hideActivityIndicator()
            self.tableview.reloadData()
        }, env: .dev)
       
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section ){
        case 0:
            return 1
        case 1:
            return recentSearches.count
        case 2:
            return topCities.count
        
        default:
             return 4
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LocationCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        if indexPath.section == 0 {
         
            cell.lblName.text = "Near me"
            cell.imgFlag.image = UIImage(named: "location")
           
        }
        if indexPath.section == 1 {
            let locality = recentSearches[indexPath.row]
            cell.lblName.text = locality.name
            cell.imgFlag.sd_setImage(with: URL(string: locality.imagURL), placeholderImage: UIImage(named: "riyadh"))
        }
        if indexPath.section == 2 {
            let locality = topCities[indexPath.row]
            cell.lblName.text = locality.name
           cell.imgFlag.sd_setImage(with: URL(string: locality.imagURL), placeholderImage: UIImage(named: "riyadh"))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if(section == 0){
        return 0.0
    }else{
        return 55.0
    }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 55.0;//Choose your custom row height
    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String?
    {
        var title = ""
        switch(section)
        {
        case 0:
            title = ""
            break
        case 1:
            title = "Recent Searches"
            break
        case 2:
            title = "Top Cities"
            break
        default :
            title = ""
            break
        }
        return title
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       self.navigateSearchResultVC()
    }

    @IBAction func searchButtonTouchupInside(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            
            break
        }
    }
    
    func navigateSearchResultVC()  {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchResultVC") as! SearchResultVC
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
}


extension SearchLocationViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
  
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        var lat = place.coordinate.latitude
        var lon = place.coordinate.longitude
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        self.navigateSearchResultVC()
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber: break
                    //street_number = field.name
                case kGMSPlaceTypeRoute: break
                   // route = field.name
                case kGMSPlaceTypeNeighborhood: break
                   // neighborhood = field.name
                case kGMSPlaceTypeLocality: break
                   // locality = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1: break
                   // administrative_area_level_1 = field.name
                case kGMSPlaceTypeCountry: break
                   // country = field.name
                case kGMSPlaceTypePostalCode: break
                    //postal_code = field.name
                case kGMSPlaceTypePostalCodeSuffix: break
                    //postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        
        // Call custom function to populate the address form.
    
        
        // Close the autocomplete widget.
        self.dismiss(animated: true, completion: nil)
    }
    
}
