//
//  MapViewModelTests.swift
//  ChargeXTests
//
//  Created by Jasveer Singh on 25.08.22.
//

@testable import ChargeX
import Combine
import CoreLocation
import XCTest

final class MapViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func testGetChargingPointsFailure() {
        let error = MockedError.mockError
        let mockAPI = ChargingPointsProviderMock(error: error)
        let sut = MapViewModel(chargingPointsApi: mockAPI)
        sut.getChargingPoints(
            for: CLLocationCoordinate2D(latitude: 52.526, longitude: 13.415)
        )
        waitUntil(sut.$errorMessage, equals: error.localizedDescription)
    }

    func testGetChargingPointsSuccess() {
        let points = [
            ChargingPoint(
                id: 123,
                numberOfPoints: 2,
                uuid: UUID().uuidString,
                usageCost: "5",
                addressInfo: AddressInfo(
                    id: 1,
                    title: "Address Title",
                    addressLine1: "addressLine1",
                    town: "Town",
                    stateOrProvince: "stateOrProvince",
                    postcode: "10154",
                    country: Country(isoCode: "DE", id: 1, title: "Germany"),
                    latitude: 52.526,
                    longitude: 13.415,
                    distance: 5
                ),
                operatorInfo: nil
            ),
        ]

        let mockAPI = ChargingPointsProviderMock(points: points)
        let sut = MapViewModel(chargingPointsApi: mockAPI)
        sut.getChargingPoints(
            for: CLLocationCoordinate2D(latitude: 52.526, longitude: 13.415)
        )
        waitUntil(sut.$chargingPoints, equals: points)
    }
}

private struct ChargingPointsProviderMock: ChargingPointsProvider {
    private let stub = PassthroughSubject<[ChargingPoint], Error>()
    private let points: [ChargingPoint]?
    private let error: Error?

    init(points: [ChargingPoint]? = nil, error: Error? = nil) {
        self.points = points
        self.error = error
    }

    func getChargingPoints(for _: CLLocationCoordinate2D) -> AnyPublisher<[ChargingPoint], Error> {
        if let error = error {
            stub.send(completion: .failure(error))
        }
        if let points = points {
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                stub.send(points)
            }
        }

        return stub.eraseToAnyPublisher()
    }
}

private enum MockedError: Error {
    case mockError
}
