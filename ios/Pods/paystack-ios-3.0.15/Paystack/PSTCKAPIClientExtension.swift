//
//  PSTCKAPIClientExtension.swift
//  PaystackiOS
//
//  Created by Jubril Olambiwonnu on 6/19/20.
//  Copyright © 2020 Paystack, Inc. All rights reserved.
//

import Foundation

@objc extension PSTCKAPIClient {
    
     public func fetchStates(country: String, completion: @escaping ([PSTCKState], Error?) -> Void) {
        let url = URL(string: "https://api.paystack.co/address_verification/states?country=\(country)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                completion([PSTCKState](), error)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                guard responseJSON["status"] as? Bool == true else {
                    completion([PSTCKState](), StringError(responseJSON["message"] as? String ?? "Could not fetch issuing country states"))
                    return
                }
                if let data = responseJSON["data"] as? [[String : Any]] {
                    let states = data.compactMap{PSTCKState(dict: $0)}
                    completion(states, nil)
                }
            }
        }).resume()
    }    
}


@objc public class PSTCKState: NSObject {
    public var name: String
    public var abbreviation: String
    
    init(name: String, abb: String) {
        self.name = name
        self.abbreviation = abb
    }
    
    init?(dict: [String : Any]) {
        if let name = dict["name"] as? String, let abb = dict["abbreviation"] as? String {
            self.name = name
            self.abbreviation = abb
            return
        }
       return nil
    }
}

struct StringError : LocalizedError {
    var errorDescription: String? { return errorMessage }
    var failureReason: String? { return errorMessage }
    var recoverySuggestion: String? { return "" }
    var helpAnchor: String? { return "" }
    
    private var errorMessage : String
    
    init(_ description: String)
    {
        errorMessage = description
    }
}




