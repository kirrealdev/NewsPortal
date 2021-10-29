//
//  NewsDataModel.swift
//  Practice_2
//
//  Created by KirRealDev on 18.09.2021.
//

import Foundation
import UIKit

struct NewsDataModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDataModel]
}

struct ArticleDataModel: Codable {
    //let source: SourceDataModel?
    //let author: String?
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    //let content: String?
    //var image: UIImage?

    enum CodingKeys: String, CodingKey {
        case /*source, author,*/ title
        case articleDescription = "description"
        case url, urlToImage, publishedAt//, content
    }
}

struct SourceDataModel: Codable {
    let id: String?
    let name: String?
}
