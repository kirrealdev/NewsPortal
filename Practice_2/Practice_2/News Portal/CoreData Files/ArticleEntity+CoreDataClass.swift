//
//  ArticleEntity+CoreDataClass.swift
//  
//
//  Created by KirRealDev on 21.09.2021.
//
//

import Foundation
import CoreData

@objc(ArticleEntity)
public class ArticleEntity: NSManagedObject {
    static func object(data: ArticleDataModel, in context: NSManagedObjectContext) -> ArticleEntity? {
        guard let entity = entity(in: context) else {
            return nil
        }
        let object = ArticleEntity(entity: entity, insertInto: context)
        
        object.articleDescription = data.articleDescription
        object.publishedAt = data.publishedAt
        //object.source = data.source
        object.title = data.title
        object.url = data.url
        object.urlToImage = data.urlToImage
        
        return object
    }
}
