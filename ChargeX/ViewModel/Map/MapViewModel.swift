//
//  MapViewModel.swift
//  ChargeX
//
//  Created by Jasveer Singh on 24.08.22.
//

import Combine
import CoreLocation
import Foundation

final class MapViewModel: ObservableObject {
    @Published private(set) var chargingPoints = [ChargingPoint]()
    @Published private(set) var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()
    private let chargingPointsApi: ChargingPointsProvider

    init(chargingPointsApi: ChargingPointsProvider = OpenChargeMapService.shared) {
        self.chargingPointsApi = chargingPointsApi
    }

    func getChargingPoints(for coordinate: CLLocationCoordinate2D) {
        chargingPointsApi
            .getChargingPoints(
                for: coordinate
            )
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.errorMessage = error.localizedDescription
                    print("error: \(error)")
                case .finished: print("finished")
                }
            } receiveValue: { [weak self] points in
                self?.chargingPoints = points
            }
            .store(in: &cancellables)
    }
}
