//
//  ApiConfiguration.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import Moya
import Foundation

enum ApiConstants {
    
    enum Urls {
        static let baseUrl = "http://localhost:2727/"
    }
    
    enum Headers {
        // Base headers
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
    }

    enum HeaderValues {
        static let jsonContentType = "application/json"
        static let formUrlencodedType = "application/x-www-form-urlencoded"
    }

    enum ApiVersion: String {
        case one = "api/v1/"
    }
}

public protocol ApiConfiguration: TargetType {
    var urlString: String { get }
    var defaultHeaders: [String: String] { get }
}

extension ApiConfiguration {
    var path: String { "" }
    public var method: Moya.Method { .get }

    public var defaultHeaders: [String: String] {
        [ApiConstants.Headers.contentType: ApiConstants.HeaderValues.jsonContentType]
    }

    public var urlString: String { ApiConstants.Urls.baseUrl }
    public var baseURL: URL { URL(string: urlString)! }
    public var sampleData: Data { Data() }
    public var task: Task { .requestPlain }
    public var headers: [String: String]? { defaultHeaders }
}
