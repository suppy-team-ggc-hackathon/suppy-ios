//
//  DetailsViewController.swift
//  Suppy
//
//  Created by Daniel Montano on 06.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topBarView: UIView!
    
    var supplyChainItem: SupplyChainItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        topBarView.backgroundColor = Constants.blueColor
        
        
        tableView.delegate = self
        
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 13.0, longitude: 53.0)
        
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }

    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let supplyChainItem = self.supplyChainItem {
            return supplyChainItem.prev_tx_ids.count + 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var co2cell = CO2Cell.instantiateFromNib()!
        var supplyChainCell = SupplyChainCell.instantiateFromNib()!
        
        if (indexPath.row == 0 ){
            
            if let item = self.supplyChainItem {
                co2cell.polutionLabel.text = "\(item.co2)"
            }else{
                print("Item not defined!")
            }
            
            
            return co2cell
        }else{
            
            if let item = self.supplyChainItem {
                
                let prevTx = item.prev_tx_ids[indexPath.row]
                
                BlockchainManager.sharedInstance.fetchOriginAndLocation(id: prevTx, cb: {(json: JSON?, error: Error?) in
                    
                    if let json = json {
                        
                        let imgURL = json["result"]["product_data"]["img"].string
                        let titleData = json["result"]["product_data"]["title"].string
                        let descData = json["result"]["originAddress"].string
                        
                        supplyChainCell.loadImage(url: imgURL!)
                        supplyChainCell.descLabel.text = descData!
                        supplyChainCell.titleLabel.text = titleData!
                    }
                    
                })
            }else {
                
                // ALERT ERROR
            }
            
            
            return supplyChainCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == 0){
           return 120
        }else{
            return 80.0
        }
        
    }
    
}


