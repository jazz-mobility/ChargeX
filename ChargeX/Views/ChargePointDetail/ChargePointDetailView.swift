//
//  ChargePointDetailView.swift
//  ChargeX
//
//  Created by Jasveer Singh on 25.08.22.
//

import SwiftUI

struct ChargePointDetailView: View {
    let point: ChargingPoint

    var body: some View {
        List {
            Section(header: Text("Address")) {
                VStack(alignment: .leading) {
                    Text(point.addressInfo.addressLine1)
                    if let town = point.addressInfo.town {
                        Text(town)
                    }
                    if let state = point.addressInfo.stateOrProvince,
                       point.addressInfo.town != point.addressInfo.stateOrProvince
                    {
                        Text(state)
                    }
                    Text(point.addressInfo.postcode)
                    Text(point.addressInfo.country.title)
                }
            }

            Section(header: Text("Distance")) {
                VStack(alignment: .leading) {
                    Text(String(format: "%.2f km away.", point.addressInfo.distance))
                }
            }

            Section(header: Text("Available Points")) {
                if let numberOfPoints = point.numberOfPoints {
                    Text("\(numberOfPoints) available.")
                } else {
                    Text("Sorry, Not available.")
                }
            }

            if let operatorInfo = point.operatorInfo {
                Section(header: Text("Operator")) {
                    VStack(alignment: .leading) {
                        Text(operatorInfo.title)

                        if let websiteURL = operatorInfo.websiteURL,
                           let url = URL(string: websiteURL)
                        {
                            HStack {
                                Image(systemName: "network")
                                    .resizable()
                                    .foregroundColor(.primary)
                                    .frame(width: 20, height: 20)
                                Link(websiteURL, destination: url)
                            }
                        }

                        if let phonePrimaryContact = operatorInfo.phonePrimaryContact {
                            HStack {
                                Image(systemName: "phone")
                                    .resizable()
                                    .foregroundColor(.primary)
                                    .frame(width: 20, height: 20)
                                Text(phonePrimaryContact)
                            }
                        }

                        if let email = operatorInfo.contactEmail {
                            HStack {
                                Image(systemName: "mail")
                                    .resizable()
                                    .foregroundColor(.primary)
                                    .frame(width: 20, height: 20)
                                Text(email)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(point.addressInfo.title)
    }
}

struct ChargePointDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChargePointDetailView(
            point: ChargingPoint(
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
            )
        )
    }
}
