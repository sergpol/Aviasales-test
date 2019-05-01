//
//  ErrorResponse.swift
//  iTransfers
//
//  Created by Сергей Полицинский on 14/11/2018.
//  Copyright © 2018 iTransfers. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable, Error {
    var error: String
}
