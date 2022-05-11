//
//  MapViewController.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/06.
//

import UIKit
import MapKit


class MapViewController: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    //서울시청
    let defaultLocation = CLLocationCoordinate2D(latitude: 37.5664238444257, longitude: 126.9779353372967)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewConfig()
        navigationConfig()
        addDefaultAnnotation()
    }
    
    func mapViewConfig() {
        locationManager.delegate = self
        mapView.delegate = self
        
        //지역설정
        let location = CLLocationCoordinate2D(latitude: 37.566352778, longitude: 126.977952778)
        setMapViewRegion(center: location)
    }
    
    func setMapViewRegion(center: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func navigationConfig() {
        title = "MY Location"
            
        let rightFilterBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didTapFilterBarButtonItem))
        navigationItem.rightBarButtonItem = rightFilterBarButtonItem
    }
    
    func addDefaultAnnotation() {
        mapView.addAnnotations(TheaterEnum.all.theaterAnnotation())
    }
    
    @objc func didTapFilterBarButtonItem() {
        
        let filterActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for theater in TheaterEnum.allCases {
            filterActionSheet.addAction(UIAlertAction(title: theater.rawValue, style: .default, handler: { _ in
                self.filterActionItemClicked(theaterEnum: theater)
            }))
        }
        
        filterActionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil ))
        present(filterActionSheet, animated: true, completion: nil)
    }
    
    func filterActionItemClicked(theaterEnum: TheaterEnum) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(theaterEnum.theaterAnnotation())
        locationManager.startUpdatingLocation()
    }
    
}


// MARK : - LocationManager Delegate Add
extension MapViewController: CLLocationManagerDelegate {

    func checkUserLocationServicesAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus // ios 14이상에만 사용 가능.
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus() // ios 14미만에서 사용
        }
        
        //iOS 위치 서비스 확인
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("iOS 위치 서비스를 켜주세요")
        }
    }

    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest//정확한 위치를 얻을 때 반경을 몇으로 할지 설정하는 것. Best로 하면 자동으로 해준다.
            locationManager.requestWhenInUseAuthorization() //앱을 사용하는 동안에 대한 위치 권한 요청
            locationManager.startUpdatingLocation() //권한 획득후 위치를 업데이트하라는 함수
        case .restricted, .denied:
            let okAction = UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                self.setMapViewRegion(center: self.defaultLocation)
            })
            let settingAction = UIAlertAction(title: "설정", style: .default, handler: { _ in
                self.openSettingScene()
            })
            self.presentAlert(title: "위치정보 권한 없음", message: "현재 위치가 표시되지 않습니다.", alertActions: okAction, settingAction)
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation() //앱을 사용하는 동안에 대한 위치 권한 요청 => didUpdateLocations 함수 실행!
        case .authorizedAlways:
            print("Always")
        @unknown default:
            print("DEFAULT")
        }
        
        if #available(iOS 14.0, *) {
            //정확도 체크 : 정확도가 감소가 되어 있는 경우. 1시간에 4번밖에 호출을 못함, 미리 알림이 동작을 안할 수 있다. 대신 배터리는 오래 쓸 수 있다. 워치8 부터 위치 페어링기능이 동작하지 않는다
            let accurancyState = locationManager.accuracyAuthorization
            
            switch accurancyState {
            case .fullAccuracy:
                print("FULL")
            case .reducedAccuracy:
                print("REDUCE")
            @unknown default :
                print("DEFAULT")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
            
            //핀 찍쟈
            let annotaion = MKPointAnnotation()
            annotaion.title = "CURRENT LOCATION"
            annotaion.coordinate = coordinate
            mapView.addAnnotation(annotaion)
            
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
                 
            
            mapView.setRegion(region, animated: true)
            
            //10. 매우 중요!! 업데이트를 멈춰주어야한다.(자동으로 계속 되고 있다)
            //비슷한 반경에서는 업데이트를 안하도록 해주는 그런 코드는 직접 구현해주어야 한다.
            locationManager.stopUpdatingLocation()
            
        } else {
            print("Location CanNot Find")
        }
    }
    
    //5. 위치권한을 허용을 해두었지만, 어떠한 이유(비행기 모드 등)으로 위치정보를 획득하지 못하는 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    //ios < 14
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
    
    //ios14 ~
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
    
    
    
}

extension MapViewController: MKMapViewDelegate {
    //맵 어노테이션 클릭시 이벤트 핸들링을 위한 함수
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Hear I am...")
    }
}
