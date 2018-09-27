//
//  MapViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 19.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class MapViewController: UIViewController, GMSMapViewDelegate {
    let defaults = UserDefaults.standard
    
    var documents = [classDocuments]()
    
    @IBOutlet weak var map: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        if let savedDocs = defaults.object(forKey: "documents") as? Data {
            documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
        }
        
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
            else {
                NSLog("Unable to find style.json")
            }
        }
        catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: 55.752023, longitude: 37.617499, zoom: 7.0)
        self.map.animate(to: camera)

        for i in documents {
            setMarkers(address: i.address, id: i.id)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let inf = infoMapView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))

        if let element = documents.first(where: {$0.id == marker.title!}) {
            inf.document = element
            inf.addInfoTable()
        }

        inf.isUserInteractionEnabled = true
        return inf
    }

    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        return nil
    }
    
    func setMarkers(address: String, id: String) {
        let queue = DispatchQueue.init(label: "myQueue", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        queue.async {
            let localSearchRequest = MKLocalSearch.Request()
            localSearchRequest.naturalLanguageQuery = address
            
            let localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.start { (localSearchResponse, error) -> Void in
                if localSearchResponse == nil {
                }
                else {
                    DispatchQueue.main.async {
                        let marker = GMSMarker()
                        let coordinates = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
                        
                        marker.position = coordinates
                        marker.icon = GMSMarker.markerImage(with: UIColor(red:0.00, green:0.59, blue:1.00, alpha:1.0))
                    
                        //marker.iconView = self.markerImage
                        marker.tracksInfoWindowChanges = true
                        marker.title = id
                        marker.map = self.map
                    }
                }
            }
        }
    }

    func addInfoOnWindow(_ view: UIView, number: String, date: String, object: String, owner: String) {
        var number: UILabel {
            let temp = UILabel()
            temp.frame = CGRect(x: 15, y: 20, width: 110, height: 25)
            temp.font = UIFont.preferredFont(forTextStyle: .caption1)
            temp.text = "№ \(number)"
            temp.textColor = .white
            temp.textAlignment = .center
            temp.clipsToBounds = true
            temp.layer.cornerRadius = 10
            temp.backgroundColor = UIColor(red:0.00, green:0.59, blue:1.00, alpha:0.31)
            return temp
        }
        view.addSubview(number)
        
        var date: UILabel {
            let temp = UILabel()
            temp.frame = CGRect(x: 155, y: 20, width: 110, height: 25)
            temp.font = UIFont.preferredFont(forTextStyle: .caption1)
            temp.text = "от \(date)"
            temp.textColor = .white
            temp.textAlignment = .center
            temp.clipsToBounds = true
            temp.layer.cornerRadius = 10
            temp.backgroundColor = UIColor(red:0.00, green:0.59, blue:1.00, alpha:0.31)
            return temp
        }
        view.addSubview(date)
        
        var line1: UIImageView {
            let temp = UIImageView()
            temp.frame = CGRect(x: 10, y: 56, width: 260, height: 1)
            temp.backgroundColor = UIColor(white: 0.9, alpha: 1)
            return temp
        }
        view.addSubview(line1)
        
        var line2: UIImageView {
            let temp = UIImageView()
            temp.frame = CGRect(x: 10, y: 112, width: 260, height: 1)
            temp.backgroundColor = UIColor(white: 0.9, alpha: 1)
            return temp
        }
        view.addSubview(line2)
        
        var oTitle: UILabel {
            let temp = UILabel()
            temp.frame = CGRect(x: 10, y: 61, width: 130, height: 15)
            temp.font = UIFont.italicSystemFont(ofSize: 15)
            temp.text = "Объект:"
            temp.textColor = .lightGray
            return temp
        }
        view.addSubview(oTitle)
        
        var ownTitle: UILabel {
            let temp = UILabel()
            temp.frame = CGRect(x: 10, y: 117, width: 130, height: 15)
            temp.font = UIFont.italicSystemFont(ofSize: 15)
            temp.text = "Арендодатель:"
            temp.textColor = .lightGray
            return temp
        }
        view.addSubview(ownTitle)
        
        var object: UILabel {
            let temp = UILabel()
            temp.frame = CGRect(x: 140, y: 61, width: 130, height: 46)
            temp.font = UIFont.init(name: "Helvetica", size: 15)
            temp.adjustsFontSizeToFitWidth = true
            temp.numberOfLines = 0
            temp.minimumScaleFactor = 0.5
            temp.text = object
            temp.textAlignment = .right
            temp.textColor = .darkGray
            return temp
        }
        view.addSubview(object)
        
        var owner: UILabel {
            let temp = UILabel()
            temp.frame = CGRect(x: 140, y: 119, width: 130, height: 46)
            temp.font = UIFont.init(name: "Helvetica", size: 15)
            temp.adjustsFontSizeToFitWidth = true
            temp.numberOfLines = 0
            temp.minimumScaleFactor = 0.5
            temp.text = owner
            temp.textAlignment = .right
            temp.textColor = .darkGray
            return temp
        }
        view.addSubview(owner)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
