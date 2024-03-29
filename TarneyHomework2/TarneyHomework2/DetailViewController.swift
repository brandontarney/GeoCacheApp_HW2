//
//  DetailViewController.swift
//  TarneyHomework2
//
//  Created by Brandon Tarney on 2/26/18.
//  Copyright © 2018 Brandon Tarney. All rights reserved.
//

import UIKit
import MapKit
import GeoCacheFramework

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var geoCacheTitle: UILabel!
    @IBOutlet weak var geoCacheSnap: UIImageView!
    @IBOutlet weak var geoCacheLat: UILabel!
    @IBOutlet weak var geoCacheLon: UILabel!
    @IBOutlet weak var geoCacheDetail: UILabel!
    @IBOutlet weak var geoCacheImage: UIImageView!
    @IBOutlet weak var geoCacheFoundDate: UILabel!
    @IBOutlet weak var geoCacheSwitch: UISwitch!
    
    var geoCacheItem:GeoCacheItem?
    var mapView: MKMapView?
    var pinView:MKPinAnnotationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Request Snapshot w/ Handler Closure
        self.requestSnapshotData(mapView: self.mapView!, completionHandler:
            {
                (mkMapSnapshot, error) in
                if let image = mkMapSnapshot?.image {
                    self.geoCacheSnap.image = image
                }
            } )
        
        geoCacheTitle.text = geoCacheItem!.title
        geoCacheLat.text = geoCacheItem!.coordinate.latitude.description
        geoCacheLon.text = geoCacheItem!.coordinate.longitude.description
        geoCacheDetail.text = geoCacheItem!.detail

        geoCacheImage.image = UIImage(named: geoCacheItem!.imagePath)
        
        //Found Switch Default State
        if geoCacheItem!.found == false {
            geoCacheSwitch.isOn = false;
            geoCacheFoundDate.text = "          "
        } else {
            self.geoCacheFoundDate.text = geoCacheItem!.foundDate
            geoCacheSwitch.isOn = true;
        }
    }
    
    //Helper Fcn
    func getGeoCacheFoundDateAsString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    

    //'FOUND' SWITCH HANDLER
    @IBAction func geoCacheFound(_ sender: UISwitch) {
        if sender.isOn {
            geoCacheItem!.found = true
            let formattedDate = getGeoCacheFoundDateAsString()
            geoCacheItem!.foundDate = formattedDate
            self.geoCacheFoundDate.text = formattedDate
            pinView!.pinTintColor = .green
        } else {
            geoCacheItem!.found = false
            geoCacheFoundDate.text = "        "
            pinView!.pinTintColor = .red
        }
    }
    

    //SNAPSHOT
    func requestSnapshotData(mapView: MKMapView, completionHandler: @escaping (MKMapSnapshot?, Error?) -> ())
    {
        let snapShotOptions = MKMapSnapshotOptions()

        let widthInMeters = 1000
        let heightInMeters = 1000
        snapShotOptions.region = MKCoordinateRegionMakeWithDistance(
                geoCacheItem!.coordinate,
                CLLocationDistance(widthInMeters),
                CLLocationDistance(heightInMeters))

        snapShotOptions.size = geoCacheSnap.frame.size
        snapShotOptions.scale = UIScreen.main.scale
 
        //Get SnapShot
        let snapshotter = MKMapSnapshotter(options: snapShotOptions)
        
        //Use snapshot
        snapshotter.start(completionHandler: completionHandler)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}

