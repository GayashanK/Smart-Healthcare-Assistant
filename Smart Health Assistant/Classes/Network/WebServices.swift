//
//  ViewController.swift
//  StaterPack-iOS-swift-4.0
//
//  Created by Kasun Gayashan on 2/7/18.
//  Copyright © 2018 cis4. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
import RxAlamofire
import AlamofireObjectMapper

class WebService {
    static var instance = WebService()
    
    var headersWithApiToken = [
        "api-secret" : "CA41A12EA2828DBC49CDBDA88D521",
        "api-key" : "2BAAFD2BE944AAA5B21BCBDF99F6E",
        "Content-Type": "application/json",
    ]
    
    init(){
        if let token = UserDefaults.standard.string(forKey: Key.accessToken) {
            self.headersWithApiToken["access-token"] = token
        }
    }
    
    func postRequest(parameters:Dictionary<String, Any>, endPoint: endPoint) -> Observable<JSON> {
        let url = APIURL.completeUrl(endPoint: endPoint)
        return Observable.create{ observer in
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headersWithApiToken)
                .responseJSON { response in
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            observer.onNext(JSON(data))
                            print(data)
                        }
                        break
                        
                    case .failure(_):
                        if let error = response.result.error {
                            observer.onError(error)
                            print(error)
                        }
                        break
                        
                    }
            }
            return Disposables.create()
        }
    }
    
    func putRequest(parameters:Dictionary<String, Any>, endPoint: endPoint, endValue: String) -> Observable<JSON> {
        let url = APIURL.completeUrl(endPoint: endPoint, endValue: endValue)
        return Observable.create{ observer in
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.headersWithApiToken)
                .responseJSON { response in
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            observer.onNext(JSON(data))
                            print(data)
                        }
                        break
                        
                    case .failure(_):
                        if let error = response.result.error {
                            observer.onError(error)
                            print(error)
                        }
                        break
                        
                    }
            }
            return Disposables.create()
        }
    }
    
    func deleteRequest(endPoint: endPoint, endValue: String) -> Observable<JSON> {
        let url = APIURL.completeUrl(endPoint: endPoint, endValue: endValue)
        return Observable.create{ observer in
            Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: self.headersWithApiToken)
                .responseJSON { response in
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            observer.onNext(JSON(data))
                            print(data)
                        }
                        break
                        
                    case .failure(_):
                        if let error = response.result.error {
                            observer.onError(error)
                            print(error)
                        }
                        break
                        
                    }
            }
            return Disposables.create()
        }
    }
    
    func getRequest(endPoint: endPoint, params: String? = nil, query: String? = nil) -> Observable<JSON> {
        let url = APIURL.completeGetUrl(endPoint: endPoint, params: params, query: query)
        return Observable.create{ observer in
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: self.headersWithApiToken)
                .responseJSON { response in
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value {
                            print("Response:\(data)")
                            observer.onNext(JSON(data))
                        }
                        break
                    case .failure(_):
                        if let error = response.result.error {
                            print("Error:\(error)")
                            observer.onError(error)
                        }
                        break
                    }
            }
            return Disposables.create()
        }
    }
    
}
