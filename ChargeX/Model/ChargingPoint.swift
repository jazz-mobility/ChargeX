//
//  ChargingPoint.swift
//  ChargeX
//
//  Created by Jasveer Singh on 24.08.22.
//

import CoreLocation
import Foundation

// MARK: - ChargingPoint

struct ChargingPoint: Codable, Identifiable {
    let id: Int
    let numberOfPoints: Int?
    let uuid: String
    let usageCost: String?
    var addressInfo: AddressInfo
    let operatorInfo: OperatorInfo?
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: addressInfo.latitude,
            longitude: addressInfo.longitude
        )
    }
}

extension ChargingPoint: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - AddressInfo

struct AddressInfo: Codable {
    let id: Int
    let title, addressLine1: String
    let town: String?
    let stateOrProvince: String?
    let postcode: String
    let country: Country
    let latitude, longitude: Double
    let distance: Double
}

// MARK: - Country

struct Country: Codable {
    let isoCode: String
    let id: Int
    let title: String
}

// MARK: - OperatorInfo

struct OperatorInfo: Codable {
    let websiteURL: String?
    let phonePrimaryContact: String?
    let contactEmail: String?
    let id: Int
    let title: String
}
