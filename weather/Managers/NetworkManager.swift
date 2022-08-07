//
//  NetworkManager.swift
//  weather
//
//  Created by Kito on 7/31/22.
//

import Foundation

//AppError enum which shows all possible errors
enum AppError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
}

//Result enum to show success or failure
enum Result<T> {
    case success(T)
    case failure(AppError)
}

final class NetworkManager {
    
    func dataRequest<T: Decodable>(with url: URL, objectType: T.Type, completion: @escaping (Result<T>) -> Void) {
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(Result.failure(AppError.networkError(error!)))
                return
            }
            guard let data = data else {
                completion(Result.failure(AppError.dataNotFound))
                return
            }
            do {
                //create decodable object from data
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(Result.success(decodedObject))
            } catch let error {
                completion(Result.failure(AppError.jsonParsingError(error)))
            }
        })
        task.resume()
    }
}
