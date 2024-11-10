//import SwiftUI
//import MapKit
//import CoreLocation
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    
//    private let manager = CLLocationManager()
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.requestWhenInUseAuthorization() // 位置情報利用の許可をリクエスト
//        manager.startUpdatingLocation() // 現在地の更新を開始
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways:
//            // 許可された場合、位置情報の取得を開始
//            manager.startUpdatingLocation()
//        case .denied, .restricted:
//            // 拒否された場合の処理
//            print("位置情報が許可されていません")
//        default:
//            break
//        }
//    }
//}
//
//
//struct TokyoStationCenteredMapView: View {
//    @State private var cameraPosition = MapCameraPosition.region(
//        MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125), // 東京駅
//            // ズームのレベル
//            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        )
//    )
//    
//    var body: some View {
//        Map(position: $cameraPosition) {
//            // 必要に応じて他のコンテンツ（アノテーションなど）を追加
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}
