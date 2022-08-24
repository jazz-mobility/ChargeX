//
//  MapView.swift
//  ChargeX
//
//  Created by Jasveer Singh on 24.08.22.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var region = MKCoordinateRegion()

    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                setRegion(CLLocationCoordinate2D(latitude: 52.526, longitude: 13.415))
            }
    }

    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
