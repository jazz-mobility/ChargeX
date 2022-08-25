//
//  OpenChargeAPI.swift
//  ChargeX
//
//  Created by Jasveer Singh on 24.08.22.
//

import Combine
import CoreLocation

protocol ChargingPointsProvider {
    func getChargingPoints(for coordinates: CLLocationCoordinate2D) -> AnyPublisher<[ChargingPoint], Error>
}

private enum Errors: Error {
    case invalidURL
}

struct OpenChargeMapService: ChargingPointsProvider {
    static let shared = OpenChargeMapService()

    private init() {}

    private static let OpenChargeMapBaseAPI = "https://api.openchargemap.io/"
    private static let APIKey = "1e2cb9c6-a0e9-4a68-bc09-f3c97a6bd8e4"

    func getChargingPoints(for coordinates: CLLocationCoordinate2D) -> AnyPublisher<[ChargingPoint], Error> {
        guard let url = buildURL(for: coordinates) else {
            return Fail(error: Errors.invalidURL)
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["X-API-Key": Self.APIKey]

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [ChargingPoint].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func buildURL(for coordinates: CLLocationCoordinate2D) -> URL? {
        guard let baseURL = URL(string: Self.OpenChargeMapBaseAPI) else { return nil }

        var urlComponents = URLComponents(
            url: baseURL,
            resolvingAgainstBaseURL: false
        )

        urlComponents?.path = "/v3/poi"
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: "\(coordinates.latitude)"),
            URLQueryItem(name: "longitude", value: "\(coordinates.longitude)"),
            URLQueryItem(name: "distance", value: "5"),
            URLQueryItem(name: "distanceunit", value: "km"),
            URLQueryItem(name: "camelcase", value: "true"),
        ]

        return urlComponents?.url
    }
}
