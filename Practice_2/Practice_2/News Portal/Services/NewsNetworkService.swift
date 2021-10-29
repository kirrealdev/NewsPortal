//
//  NewsNetworkService.swift
//  Practice_2
//
//  Created by KirRealDev on 18.09.2021.
//

import Foundation
import UIKit

private enum ServerError: Error {
    case noDataProvided
    case failedToDecode
}

struct NewsAPIParameters {
    static let newsAPIKey = "ebe58b7f6a3b40559203542c2c8cbb82" // хранить в keychain
    static let urlNews = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=\(NewsAPIParameters.newsAPIKey)"
}

protocol NewsNetworkServiceProtocol {
    func performGetNewsDataRequestByUrl(url: String, onComplete: @escaping (NewsDataModel) -> Void, onError: @escaping (Error) -> Void)
}

final class NewsNetworkService: NewsNetworkServiceProtocol {
    
    private func makeGetRequest(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let request = URLRequest(url: url)
        return request
    }
    
    func performGetNewsDataRequestByUrl(url: String, onComplete: @escaping (NewsDataModel) -> Void, onError: @escaping (Error) -> Void) {
        guard let request = makeGetRequest(urlString: url) else {
            return
        }
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let info = try? JSONDecoder().decode(NewsDataModel.self, from: data) else {
                NSLog("Could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(info)
            }
        }
        task.resume()
    }

}
