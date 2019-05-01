//
//  API.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 30/04/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import Foundation
import Moya

enum API {
    case searchPlace(placeName: String)
}

extension API: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://places.aviasales.ru")!
    }
    
    var task: Task {
        switch self {
        case let .searchPlace(placeName):
            return .requestParameters(parameters: ["term": placeName, "locale": "ru"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json", "Content-type": "application/json"]
    }
    
    var path: String {
        switch self {
        case .searchPlace:
            return "/places"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchPlace:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}
