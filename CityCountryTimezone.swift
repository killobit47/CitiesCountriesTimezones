//
//  CityCountryTimezone.swift
//
//  Created by  Roman Ganzha on 11/11/18.
//

import Foundation

struct CustomTimeZone: Codable {

    let countryCode: String
    let city: String
    let zoneName: String

    var gmt: String {
        guard let zoneAniher = TimeZone(identifier: self.zoneName) else {
            return "GMT +0"
        }
        let seconds = zoneAniher.secondsFromGMT()
        let hours = seconds / 3_600
        let tz = String(format: "%+2d", hours)

        return "GMT \(tz)"
    }
}

struct CountryTimeZone: Codable {

    let timezones: [CustomTimeZone]
    let capital: String
    let alpha2Code: String
    let region: String
    let subregion: String
    let countryName: String
    let alpha3Code: String
}

struct CityCountryTimeZone: Codable {

    let city: String
    let alpha2Code: String
    let region: String
    let subregion: String
    let countryName: String
    let timeZoneName: String

    var timeZoneNameToDispay: String {
        return timeZoneName.replacingOccurrences(of: "_", with: " ")
    }

    var gmt: String {
        guard let zoneAniher = TimeZone(identifier: self.timeZoneName) else {
            return "GMT +0"
        }
        let seconds = zoneAniher.secondsFromGMT()
        let hours = seconds / 3_600
        let tz = String(format: "%+2d", hours)

        return "GMT \(tz)"
    }

    var abbrevation: String {
        return "\(self.countryName)/\(self.city)"
    }

    // MARK: - Initializations
    init(city: String,
         alpha2Code: String,
         region: String,
         subregion: String,
         countryName: String,
         timeZoneName: String) {
        self.city = city
        self.alpha2Code = alpha2Code
        self.region = region
        self.subregion = subregion
        self.countryName = countryName
        self.timeZoneName = timeZoneName
    }

    func contains(_ string: String) -> Bool {
        return city.lowercased().contains(string.lowercased()) || countryName.lowercased().contains(string.lowercased()) || abbrevation.lowercased().contains(string.lowercased()) || timeZoneName.lowercased().contains(string.lowercased()) ||
            gmt.lowercased().contains(string.lowercased()) || timeZoneNameToDispay.lowercased().contains(string.lowercased())
    }
}
