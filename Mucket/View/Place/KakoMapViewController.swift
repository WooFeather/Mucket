//
//  KakoMapViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/8/25.
//

import UIKit
import KakaoMapsSDK

class KakaoMapViewController: UIViewController, MapControllerDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        _observerAdded = false
        _auth = false
        _appear = false
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        _observerAdded = false
        _auth = false
        _appear = false
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
        
        print("deinit")
    }
    
    override func loadView() {
        self.view = KMViewContainer(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapContainer = self.view as? KMViewContainer
        
        //KMController 생성.
        mapController = KMController(viewContainer: mapContainer!)
        mapController!.delegate = self
        
        mapController?.prepareEngine() //엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다.
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
        // mapController?.resetEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
            break;
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
            break;
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
            break;
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
            break;
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.prepareEngine()
            }
            break;
        default:
            break;
        }
    }
    
    func addViews() {
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 14)
        
        let mapView = mapController?.getView("mapview") as? KakaoMap
        
        // TODO: POI 조금더 연구
//        mapView?.setPoiEnabled(true)
//        createLabelLayer(view: mapView)
//        createPoiStyle(view: mapView)
//        createPois(view: mapView)
        
        //KakaoMap 추가.
        mapController?.addView(mapviewInfo)
    }
    
    // Poi생성을 위한 LabelLayer 생성
    func createLabelLayer(view: KakaoMap?) {
        let view = view
        let manager = view?.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
        let _ = manager?.addLabelLayer(option: layerOption)
    }
    
    // Poi 표시 스타일 생성
    func createPoiStyle(view: KakaoMap?) {
        let view = view
        let manager = view?.getLabelManager()
        
        // PoiBadge는 스타일에도 추가될 수 있다. 이렇게 추가된 Badge는 해당 스타일이 적용될 때 함께 그려진다.
        let noti1 = PoiBadge(badgeID: "badge1", image: .symbol, offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
        let iconStyle1 = PoiIconStyle(symbol: .symbol, anchorPoint: CGPoint(x: 0.0, y: 0.5), badges: [noti1])
        let noti2 = PoiBadge(badgeID: "badge2", image: .symbol, offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
        let iconStyle2 = PoiIconStyle(symbol: .symbol, anchorPoint: CGPoint(x: 0.0, y: 0.5), badges: [noti2])
    
        // 5~11, 12~21 에 표출될 스타일을 지정한다.
        let poiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
            PerLevelPoiStyle(iconStyle: iconStyle1, level: 5),
            PerLevelPoiStyle(iconStyle: iconStyle2, level: 12)
        ])
        manager?.addPoiStyle(poiStyle)
    }
    
    func createPois(view: KakaoMap?) {
        let view = view
        let manager = view?.getLabelManager()
        let layer = manager?.getLabelLayer(layerID: "PoiLayer")
        let poiOption = PoiOptions(styleID: "PerLevelStyle")
        poiOption.rank = 0
        
        let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: 127.108678, latitude: 37.402001))
        // Poi 개별 Badge추가. 즉, 아래에서 생성된 Poi는 Style에 빌트인되어있는 badge와, Poi가 개별적으로 가지고 있는 Badge를 갖게 된다.
        let badge = PoiBadge(badgeID: "noti", image: .symbol, offset: CGPoint(x: 0, y: 0), zOrder: 1)
        poi1?.addBadge(badge)
        poi1?.show()
        poi1?.showBadge(badgeID: "noti")
    }

    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
    }
    
    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
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
    
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        UIView.animate(withDuration: 0.4,
                       delay: duration - 0.4,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                                        toastLabel.alpha = 0.0
                                    },
                       completion: { (finished) in
                                        toastLabel.removeFromSuperview()
                                    })
    }
    
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var _observerAdded: Bool
    var _auth: Bool
    var _appear: Bool
}
