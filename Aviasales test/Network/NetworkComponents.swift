//
//  NetworkComponents.swift
//  iTransfers
//
//  Created by Сергей Полицинский on 14/11/2018.
//  Copyright © 2018 iTransfers. All rights reserved.
//

import Foundation
import Moya
import Result

class NetworkComponents: ResponseHandler {
    static var shared = NetworkComponents()
    private let apiService = MoyaProvider<API>(plugins: [])
    
    func searchPlace(place: String, completion: @escaping (Result<[AirportPlace], ErrorResponse>) -> Void) {
        apiService.request(.searchPlace(placeName: place)) { result in
            self.handle(result, completion: completion)
        }
    }
}
