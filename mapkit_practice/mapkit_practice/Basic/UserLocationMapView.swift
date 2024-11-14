import SwiftUI
import MapKit
import CoreLocation

class ULLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    
    private let manager = CLLocationManager()
    
    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました: \(error.localizedDescription)")
    }
}

struct UserLocationMapView: View {
    @StateObject private var locationManager = ULLocationManager()
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ZStack {
            // マップビュー
            Map(position: $cameraPosition) {
                if let userLocation = locationManager.userLocation {
                    Marker("Your Location", coordinate: userLocation.coordinate)
                        .tint(Color.blue)
                }
            }
            .onAppear {
                // 位置情報が取得できない場合は東京駅を表示
                if locationManager.userLocation == nil {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            }
            .onChange(of: locationManager.userLocation) { newLocation in
                // ユーザー位置の更新時にマップの中心をユーザー位置に固定
                if let location = newLocation {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            }
            .edgesIgnoringSafeArea(.all)
            .disabled(true) // ユーザーのドラッグ操作を無効にする

            // 位置情報の許可メッセージ
            if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .notDetermined {
                VStack {
                    Text("位置情報の利用を許可してください")
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 4)
                        .padding()
                    Spacer()
                }
            }
        }
    }
}
