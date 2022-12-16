import UIKit
import CoreLocation
import MapKit
import SnapKit

class ViewController: UIViewController, CLLocationManagerDelegate
{
    //우선 MapKit 사용법 익히기 : 지도를 띄우고 현재 위치를 보여주고 이동하는 route를 보여주기
    //to do : empty
    //doing : empty
    //done : 지도 띄우기, 현재 위치 보여주기, 이동 route 지도에 그리기, 현재 위치로 zoom
    let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    var previousCoordinate: CLLocationCoordinate2D?
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        // desiredAccuracy는 위치의 정확도를 설정함.
        // 높으면 배터리 많이 닳음.
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        return manager
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.snp.makeConstraints{ view in
            view.width.height.centerY.centerX.equalToSuperview()
        }
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //        let location = locations.last
        guard let location = locations.last
        else {return}
        
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        if let previousCoordinate = self.previousCoordinate {
            var points: [CLLocationCoordinate2D] = []
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            let point2: CLLocationCoordinate2D
            = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            points.append(point1)
            points.append(point2)
            let lineDraw = MKPolyline(coordinates: points, count:points.count)
            self.mapView.addOverlay(lineDraw)
        }
        
        self.mapView.setRegion(region, animated: true)
        
        
        
        self.previousCoordinate = location.coordinate
        //        self.locationManager.startUpdatingLocation()
        //        self.locationManager.stopUpdatingLocation()
        
    }
    
    func getLocationUsagePermission() {
        //location4
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription, terminator: "")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //location5
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    
}
extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline
        else {
            print("can't draw polyline")
            return MKOverlayRenderer()
        }
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .orange
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0
        
        return renderer
    }
}

