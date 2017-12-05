//
//  Order.swift
//  BasicAuthAndPOST
//
//  Created by C4Q  on 12/5/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct Order: Codable {
    let name: String
    let totalCost: Int?
    enum CodingKeys: String, CodingKey {
        case name
        case totalCost = "total_cost"
    }
}

enum HTTPVerb: String {
    case GET
    case POST
}

struct OrderAPIClient {
    private init() {}
    static let manager = OrderAPIClient()
    func getOrders(completionHandler: @escaping ([Order]) -> Void,
                   errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://api.fieldbook.com/v1/5a21d3ea92dfac03005db55a/orders"
        guard let authenticatedRequest = buildAuthRequest(from: urlStr, httpVerb: .GET) else { errorHandler(AppError.badURL); return }
        let parseDataIntoOrderArr = {(data: Data) in
            do {
                let onlineOrders = try JSONDecoder().decode([Order].self, from: data)
                completionHandler(onlineOrders)
            }
            catch let error {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: authenticatedRequest, completionHandler: parseDataIntoOrderArr, errorHandler: errorHandler)
    }
    func post(order: Order, errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://api.fieldbook.com/v1/5a21d3ea92dfac03005db55a/orders"
        guard var authPostRequest = buildAuthRequest(from: urlStr, httpVerb: .POST) else {errorHandler(AppError.badURL); return }
        do {
            let encodedOrder = try JSONEncoder().encode(order)
            authPostRequest.httpBody = encodedOrder
            NetworkHelper.manager.performDataTask(with: authPostRequest,
                                                  completionHandler: {_ in print("Made a post request")},
                                                  errorHandler: errorHandler)
        }
        catch {
            errorHandler(AppError.codingError(rawError: error))
        }
        
        
    }
    private func buildAuthRequest(from urlStr: String, httpVerb: HTTPVerb) -> URLRequest? {
        guard let url = URL(string: urlStr) else { return nil }
        var request = URLRequest(url: url)
        let userName = "key-1"
        let password = "p3Z-A83YixDsI-B4aRLm"
        let authStr = buildAuthStr(userName: userName, password: password)
        request.addValue(authStr, forHTTPHeaderField: "Authorization")
        if httpVerb == .POST {
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
    private func buildAuthStr(userName: String, password: String) -> String {
        let nameAndPassStr = "\(userName):\(password)"
        let nameAndPassData = nameAndPassStr.data(using: .utf8)!
        let authBase64Str = nameAndPassData.base64EncodedString()
        let authStr = "Basic \(authBase64Str)"
        return authStr
    }
}
