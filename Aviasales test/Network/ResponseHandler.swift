//
//  ResponseHandler.swift
//  iTransfers
//
//  Created by Сергей Полицинский on 14/11/2018.
//  Copyright © 2018 iTransfers. All rights reserved.
//

import Foundation
import Result
import Moya

protocol ResponseHandler {
    func handle<T: Codable>(_ result: Result<Response, MoyaError>, completion: @escaping (Result<T, ErrorResponse>) -> Void)
    func handle<T: Codable>(_ result: Result<Response, MoyaError>, keyPath: String, completion: @escaping (Result<T, ErrorResponse>) -> Void)
}

extension ResponseHandler {
    func handle<T: Codable>(_ result: Result<Response, MoyaError>, completion: @escaping (Result<T, ErrorResponse>) -> Void) {
        switch result {
        case .success(let value):
            do {
                print(T.self)
                let response = try value.map(T.self)
                completion(.success(response))
            } catch {
                print(error)
                do {
                    let errorResponse = try value.map(ErrorResponse.self)
                    completion(.failure(errorResponse))
                } catch {
                    if value.statusCode == 401 {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UnauthUser"), object: nil)
                        return
                    }
                    let errorResponse = ErrorResponse(error: error.localizedDescription)
                    completion(.failure(errorResponse))
                    //fatalError()
                }
            }
        case .failure(let error):
            let errorResponse = ErrorResponse(error: error.localizedDescription)
            completion(.failure(errorResponse))
        }
    }
    
    func handle<T: Codable>(_ result: Result<Response, MoyaError>, keyPath: String, completion: @escaping (Result<T, ErrorResponse>) -> Void) {
        switch result {
        case .success(let value):
            do {
                let response = try value.map(T.self, atKeyPath: keyPath, using: JSONDecoder(), failsOnEmptyData: false)
                completion(.success(response))
            } catch {
                do {
                    let errorResponse = try value.map(ErrorResponse.self)
                    completion(.failure(errorResponse))
                } catch {
                    let errorResponse = ErrorResponse(error: error.localizedDescription)
                    completion(.failure(errorResponse))
                    //fatalError()
                }
            }
        case .failure(let error):
            let errorResponse = ErrorResponse(error: error.localizedDescription)
            completion(.failure(errorResponse))
        }
    }
}
