import SwiftUI
import MapKit
import CoreLocation

struct TokyoStationCenteredMapView: View {
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125), // 東京駅
            // ズームのレベル
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        Map(position: $cameraPosition) {
            // 必要に応じて他のコンテンツ（アノテーションなど）を追加
        }
        .edgesIgnoringSafeArea(.all)
    }
}
