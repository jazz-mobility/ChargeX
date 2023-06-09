//
//  MapView.swift
//  ChargeX
//
//  Created by Jasveer Singh on 24.08.22.
//

import MapKit
import SwiftUI

struct MapView: View {
    private let timer = Timer.publish(
        every: 30,
        tolerance: 1,
        on: .main,
        in: .common
    ).autoconnect()

    @State private var region = MKCoordinateRegion()
    @ObservedObject var viewModel = MapViewModel()

    var body: some View {
        NavigationView {
            Map(
                coordinateRegion: $region,
                annotationItems: viewModel.chargingPoints
            ) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    NavigationLink {
                        ChargePointDetailView(point: place)
                    } label: {
                        Image(systemName: "bolt.car.circle.fill")
                            .resizable()
                            .foregroundColor(.primary)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                    }
                }
            }
            .ignoresSafeArea()
        }
        .onReceive(timer, perform: { _ in
            viewModel.getChargingPoints(for: region.center)
        })
        .onAppear {
            setRegion(CLLocationCoordinate2D(latitude: 52.526, longitude: 13.415))
            viewModel.getChargingPoints(for: region.center)
        }
    }

    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
