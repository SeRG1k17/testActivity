//
//  EndPoints.swift
//  TestActivity
//
//  Created by Sergey Pugach on 4/3/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import Moya

private typealias Parameters = [String: Any]
private let appClientUsername = "34809511-816A-47F3-9DBC-586CFA570BEB"
private let appClientPassword = "{7.l?^>GW010^5Yt!I[~s464"

enum EndPoints {
    case login(username: String, password: String)
    case weather(in: String)
}

extension EndPoints: TargetType {

    enum BaseURL {
        case azure(EndPoints)
        case openWeather(EndPoints)
        
        static func type(for endpoint: EndPoints) -> BaseURL {
            switch endpoint {
            case .weather: return .openWeather(endpoint)
            case .login: return .azure(endpoint)
            } // switch
        }
        
        var url: URL {
            
            var url: String!
            switch self {
            case .azure: url = "https://tdcoauth2server.azurewebsites.net"
            case .openWeather: url = "http://api.openweathermap.org"
            } // switch
            
            return URL(string: url)!
        }
    }
    
    public var urlType: BaseURL { return BaseURL.type(for: self) }
    public var baseURL: URL { return urlType.url }
    
    public var path: String {
        switch self {
        case .login: return "oauth/token"
        case .weather: return "data/2.5/weather"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var task: Task {
        switch self {
        case .login: return .requestParameters(parameters: parameters,encoding: URLEncoding.default)
        case .weather: return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString) //or .default ?
        }
    }
    
    //Manually created property
    private var parameters: Parameters {
        
        func addGrantType(to dictionary: inout Parameters) {
            
            var value: String!
            switch self {
            case .login: value = "password"
            default: return
            } // switch
            
            dictionary["grant_type"] = value
        }
        
        var params = Parameters()
        
        switch self {
        case .weather(let city): params = ["APPID": "71f12a08eb70ed0907cdf8e15f9a70c6", "q": city]
        case .login(let username, let password): params = ["username": username, "password": password]
        }
        
        addGrantType(to: &params)
        
        return params
    }
    
    var sampleData: Data {
        return Data()
    }
}

extension EndPoints: AccessTokenAuthorizable {
    
    var authorizationType: AuthorizationType {
        switch self {
        case .login: return .basic
        case .weather: return .none
        }
    }
}

func getToken() -> String {
    return String(format: "%@:%@", appClientUsername, appClientPassword).data(using: .utf8)!.base64EncodedString()
}

