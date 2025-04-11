//
//  RestaurantMapViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import CoreLocation
import ReactorKit
import RxCocoa
import KakaoMapsSDK

final class PlaceViewController: BaseViewController, CLLocationManagerDelegate {
    private let placeView = PlaceView()
    private let locationManager = CLLocationManager()
    
    private var mapContainer: KMViewContainer?
    private var mapController: KMController?
    private var _observerAdded: Bool = false
    private var _auth: Bool = false
    private var _appear: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _observerAdded = false
        _auth = false
        _appear = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        _observerAdded = false
        _auth = false
        _appear = false
        super.init(coder: aDecoder)
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
        
        print("deinit")
    }
    
    override func loadView() {
        view = placeView
    }
    
    override func configureAction() {
        placeView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func currentLocationButtonTapped() {
        checkAuthorizationStatus()
    }
}

// MARK: - KakaoMap
extension PlaceViewController: MapControllerDelegate {
    func addViews() {
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        let defaultPosition: MapPoint = MapPoint(longitude: 126.972317, latitude: 37.555946)
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 17)
        
        //KakaoMap 추가.
        DispatchQueue.main.async {
            self.mapController?.addView(mapviewInfo)
        }
    }
    
    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getLabelManager()
        guard let image = UIImage(named: "poi") else {
            print("❌ 이미지 로드 실패")
            return
        }
        
        mapView?.setPoiEnabled(true)
        createLabelLayer(view: mapView, manager: manager)
        // createPoiStyle(view: mapView, manager: manager, image: image)
        createPois(view: mapView, manager: manager, image: image)
        
        // 지도가 로드된 후 현재 사용자 위치 확인
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            // 이미 위치 정보가 있는 경우 바로 적용
            if let location = locationManager.location {
                setRegion(center: location.coordinate)
            } else {
                // 위치 정보가 없으면 업데이트 요청
                locationManager.startUpdatingLocation()
            }
        }

    }
    
    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mapContainer 초기화
        mapContainer = placeView.mapView
        guard mapContainer != nil else {
            print("맵 생성 실패")
            return
        }
        
        // 위치 관리자 설정
        setupLocationManager()
        
        // 컨트롤러 초기화 및 엔진 준비
        mapController = KMController(viewContainer: mapContainer!)
        mapController!.delegate = self
        mapController?.prepareEngine()
        
        // 지도 추가 - 여기서는 기본 위치로 초기화하고, 위치 정보가 확인되면 이동시킬 예정
        addViews()
        
        // 앱 실행 시 이미 권한이 있는 경우 자동으로 위치 찾도록 즉시 요청
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            checkAuthorizationStatus() // 권한 없으면 요청 프로세스 시작
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()  //렌더링 중지.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    // MARK: - Authentication
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
            break
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
            break
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
            break
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
            break
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.prepareEngine()
            }
            break
        default:
            break
        }
    }
    
    // MARK: - etc.
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
    }
    
    func viewWillDestroyed(_ view: ViewBase) {
        
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = true
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = false
    }
    
    @objc func willResignActive(){
        mapController?.pauseEngine()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
    }
    
    @objc func didBecomeActive(){
        mapController?.activateEngine() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
    }
    
    func mapControllerDidChangeZoomLevel(_ mapController: KakaoMapsSDK.KMController, zoomLevel: Double) {
        print("Zoom level changed to: \(zoomLevel)")
    }
    
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        
        UIView.animate(withDuration: 0.4,
                       delay: duration - 0.4,
                       options: .curveEaseOut,
                       animations: {
            toastLabel.alpha = 0.0
        },
                       completion: { (finished) in
            toastLabel.removeFromSuperview()
        })
    }
}

// MARK: - Poi
extension PlaceViewController {
    // Poi생성을 위한 LabelLayer 생성
    func createLabelLayer(view: KakaoMap?, manager: LabelManager?) {
        
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
        let _ = manager?.addLabelLayer(option: layerOption)
    }
    
    // Poi 표시 스타일 생성
    func createPoiStyle(view: KakaoMap?, manager: LabelManager?, image: UIImage?) {
        
        let iconStyle = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.0, y: 0.5))
    
        // 5~11, 12~21 에 표출될 스타일을 지정한다.
        let poiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
            PerLevelPoiStyle(iconStyle: iconStyle, level: 5)
        ])
        manager?.addPoiStyle(poiStyle)
    }
    
    func createPois(view: KakaoMap?, manager: LabelManager?, image: UIImage?) {
        guard let layer = manager?.getLabelLayer(layerID: "PoiLayer") else { return }
        
        let poiOption = PoiOptions(styleID: "PerLevelStyle")
        poiOption.rank = 0
        
        // POI를 추가할 위치 리스트 (위도, 경도)
        let poiLocations = [
            MapPoint(longitude: 127.108678, latitude: 37.402001),
            MapPoint(longitude: 127.106, latitude: 37.403),
            MapPoint(longitude: 127.109, latitude: 37.404),
            MapPoint(longitude: 127.107, latitude: 37.405),
            MapPoint(longitude: 127.105, latitude: 37.406)
        ]
        
        for (index, point) in poiLocations.enumerated() {
            if let poi = layer.addPoi(option: poiOption, at: point) {
                let badge = PoiBadge(
                    badgeID: "badge\(index)",
                    image: image,
                    offset: CGPoint(x: 0, y: 0),
                    zOrder: 1
                )
                poi.addBadge(badge)
                poi.show()
                poi.showBadge(badgeID: "badge\(index)")
            }
        }
    }
}

// MARK: - CoreLocation
extension PlaceViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("➡️ 현재 위치: \(location.coordinate)")
        locationManager.stopUpdatingLocation()
        
        // 지도가 초기화된 후에만 카메라 이동
        if let mapView = mapController?.getView("mapview") as? KakaoMap {
            setRegion(center: location.coordinate)
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        checkSystemLocation()
    }
    
    private func checkSystemLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkAuthorizationStatus()
            } else {
                print("❌SYSTEM DENIED")
                self.setDefaultRegion()
                
                DispatchQueue.main.async {
                    self.showAlert(title: "위치서비스 사용 불가", message: "위치 서비스를 사용할 수 없습니다.\n기기의 '설정->개인정보 보호'에서 위치 서비스를 켜주세요.", button: "설정으로 이동", isCancelButton: true) {
                        // 설정앱으로 이동
                        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                            UIApplication.shared.open(appSettings)
                        }
                    }
                }
            }
        }
    }
    
    private func checkAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("❌DENIED")
            setDefaultRegion()
            
            DispatchQueue.main.async {
                self.showAlert(title: "위치서비스 사용 불가", message: "위치 서비스를 사용할 수 없습니다.\n기기의 '설정->개인정보 보호'에서 위치 서비스를 켜주세요.", button: "설정으로 이동", isCancelButton: true) {
                    // 설정앱으로 이동
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            }
        case .authorizedWhenInUse:
            print("✅AUTHORIZED")
            locationManager.startUpdatingLocation()
        default:
            print("권한 확인 실패")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkSystemLocation()
    }
    
    private func setRegion(center: CLLocationCoordinate2D) {
        // 받아온 현재위치로 카메라 이동
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        
        let mapPoint = MapPoint(longitude: center.longitude, latitude: center.latitude)
        mapView.moveCamera(CameraUpdate.make(target: mapPoint, zoomLevel: 15, mapView: mapView))
    }
    
    private func setDefaultRegion() {
        // 위치정보를 받아오지 못했을때 기본 좌표(37.555946 / 126.972317)로 카메라 이동
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.555946, longitude: 126.972317)
        setRegion(center: defaultCoordinate)
    }
}
