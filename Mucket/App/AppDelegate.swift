//
//  AppDelegate.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import KakaoMapsSDK
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SDKInitializer.InitSDK(appKey: APIKeys.kakaoAppKey)
        
        sleep(2)
        
        migration()
        
        let realm = try! Realm()
        
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version", version)
        } catch {
            print("schema failed")
        }
        
        return true
    }
    
    private func migration() {
        // 현재 version이 아니라, 최종 업데이트될 version을 입력
        let config = Realm.Configuration(schemaVersion: 3) { migration, oldSchemaVersion in
            
            // 0 -> 1: Place의 folder 칼럼 타입 변경
            // 기존: @Persisted var folder: PlaceFolderObject?
            // 변경: @Persisted(originProperty: "places") var folder: LinkingObjects<PlaceFolderObject>
            if oldSchemaVersion < 1 {
                // 단순한 칼럼 삭제로 간주
            }
            
            // 1 -> 2: PlaceFolder의 places 칼럼명 변경
            // 기존: @Persisted var places: List<PlaceObject>
            // 변경: @Persisted var places: List<MyPlaceObject>
            if oldSchemaVersion < 2 {
                // 단순한 칼럼 삭제로 간주
            }
            
            // 2 -> 3: Place에 address 칼럼 추가
            if oldSchemaVersion < 3 {
                // 칼럼 추가
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

