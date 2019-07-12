//
//  TimeZoneService.swift
//
//  Created by Roman Ganzha on 11/11/18.
//

import Foundation

protocol TimeZoneServiceProtocol {

    typealias GetTimezones = (Result<[CityCountryTimeZone], TimeZoneError>) -> Void
    func fetchTimezones(completion: @escaping GetTimezones)
}

final class TimeZoneService {
    init() {

    }
}

// MARK: - Private

extension TimeZoneService {

    private func handleFetchTimezonesSuccess(with json: Any?, completion: @escaping GetTimezones) {
        guard let jsons = json as? [[String: Any]] else {
            DispatchQueue.mainAsyncSafe {
                completion(.failure(TimeZoneError.invalidJson))
            }
            return
        }
        decodeJSONArray(type: CountryTimeZone.self, from: jsons) { result in
            switch result {
            case let .success(models):

                var timezones: [CityCountryTimeZone] = [CityCountryTimeZone]()

                for county in models {
                    for timezone in county.timezones {
                        let customTimezone = CityCountryTimeZone(city: timezone.city, alpha2Code: county.alpha2Code, region: county.region, subregion: county.subregion, countryName: county.countryName, timeZoneName: timezone.zoneName)
                        timezones.append(customTimezone)
                    }
                }

                completion(.success(timezones))
            case .failure:
                completion(.failure(.jsonSerialization))
            }
        }
    }
}

// MARK: - TimeZoneServiceProtocol

extension TimeZoneService: TimeZoneServiceProtocol {

    func fetchTimezones(completion: @escaping GetTimezones) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            let recource = "OhMyTimezones"
            guard let file = Bundle.main.url(forResource: recource, withExtension: "json") else {
                DispatchQueue.mainAsyncSafe {
                    completion(.failure(TimeZoneError.fileNotExist))
                }
                return
            }
            do {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.handleFetchTimezonesSuccess(with: json, completion: completion)
            } catch {
                DispatchQueue.mainAsyncSafe {
                    completion(.failure(TimeZoneError.jsonSerialization))
                }
            }
        }
    }
}

// MARK: - DecodableGeneric

extension TimeZoneService: DecodableGeneric { }
