//
//  Networking.swift
//  TestActivity
//
//  Created by Sergey Pugach on 4/3/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import Moya

//class OnlineProvider<Target> where Target: TargetType {
//
//    private let provider: MoyaProvider<Target>
//
//    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
//         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
//         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
//         manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
//         plugins: [PluginType] = [],
//         trackInflights: Bool = false) {
//
//        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
//    }
//}

protocol NetworkingType {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}

struct Networking: NetworkingType {
    typealias T = EndPoints
    let provider: MoyaProvider<EndPoints>
}

// "Public" interfaces
extension Networking {
    
//    @discardableResult func request(_ target:      EndPoints,
//                                    callbackQueue: DispatchQueue? = .none,
//                                    progress:      ProgressBlock? = .none,
//                                    completion:    @escaping Completion) -> Cancellable {
//
//        return provider.request(target,
//                                callbackQueue: callbackQueue,
//                                progress:      progress,
//                                completion:    completion)
//    }
}

// Static methods
extension NetworkingType {
    
    static func newDefaultNetworking() -> Networking {
        return Networking(provider: newProvider(plugins))
    }
    
    static var plugins: [PluginType] {
        return [NetworkLoggerPlugin(verbose: true, cURL: true), AccessTokenPlugin(tokenClosure: getToken())]
    }
}

private func newProvider<T>(_ plugins: [PluginType]) -> MoyaProvider<T> {
    return MoyaProvider(plugins: plugins)
}
