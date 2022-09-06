//
//  APIRequestProtocol.swift
//  Songs App
//
//  Created by Aditya Gautam on 12/05/21.
//

import Foundation

public protocol APIRequest {
    var url : String { get }
    var httpMethod : HTTPRequestMethod { get set }
    var params : [String]? { get set }
    var postBody : [String]? { get set }
}
