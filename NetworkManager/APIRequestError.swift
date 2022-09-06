//
//  APIRequestError.swift
//  Songs App
//
//  Created by Aditya Gautam on 12/05/21.
//

import Foundation

public enum APIRequestError {
    case malformedURL
    case noInternetConnectivity
    case jsonDecodingFailed
    case responseNotReceived
    case unknownError
}
