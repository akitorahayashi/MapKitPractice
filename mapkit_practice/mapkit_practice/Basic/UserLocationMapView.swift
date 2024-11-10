import SwiftUI
import MapKit
import CoreLocation

class ULLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
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
                    // ユーザーの位置を示すマーカーを追加
                    Marker("Your Location", coordinate: userLocation.coordinate)
                }
            }
            .onAppear {
                // ユーザーの位置が取得できた場合、カメラをその位置に移動
                if let userLocation = locationManager.userLocation {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: userLocation.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                } else {
                    // 位置情報がまだ取得できない場合は、デフォルトの位置（例: 東京駅）を使用
                    cameraPosition = .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            }
            .edgesIgnoringSafeArea(.all)

            // 現在地に戻るボタン
            VStack {
                Spacer()
                Button(action: {
                    if let userLocation = locationManager.userLocation {
                        cameraPosition = .region(MKCoordinateRegion(
                            center: userLocation.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        ))
                    }
                }) {
                    Image(systemName: "location.fill")
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
            }
        }
    }
}