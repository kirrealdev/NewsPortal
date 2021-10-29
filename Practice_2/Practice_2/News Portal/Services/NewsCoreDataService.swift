//
//  NewsCoreDataService.swift
//  Practice_2
//
//  Created by KirRealDev on 21.09.2021.
//

import Foundation
import CoreData
import UIKit

final class NewsCoreDataService {
    static let shared = NewsCoreDataService()
    private init() { }

    // MARK: - Core Data stack

    func getFetchResultsController(entityName: String, sortDescriptorKey: String, filterKey: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let sortDescriptor = NSSortDescriptor(key: sortDescriptorKey, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            if let filter = filterKey {
                fetchRequest.predicate = NSPredicate(format: "title = %@", filter)
            }
            let fetchedResultsVc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

            return fetchedResultsVc
        }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ArticleCoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Core Data methods for change characters

    func downloadObject(articleData: ArticleDataModel?) {
        let contect = persistentContainer.viewContext

        guard let articleData = articleData else { return }
        let _ = ArticleEntity.object(data: articleData, in: contect)!

        saveContext()
    }

    func deleteObjectBy(title: String) {
        let getArticleFetchRequestController = getFetchResultsController(entityName: "ArticleEntity", sortDescriptorKey: "title", filterKey: title) as? NSFetchedResultsController<ArticleEntity>

        try? getArticleFetchRequestController?.performFetch()
        let context = persistentContainer.viewContext
        guard let article = getArticleFetchRequestController?.fetchedObjects?.first else { return }

        context.delete(article)

        saveContext()
    }

    func findArticleObjectBy(title: String) -> ArticleEntity? {
        let getArticleFetchRequestController = getFetchResultsController(entityName: "ArticleEntity", sortDescriptorKey: "title", filterKey: title) as? NSFetchedResultsController<ArticleEntity>
        try? getArticleFetchRequestController?.performFetch()

        return getArticleFetchRequestController?.fetchedObjects?.first
    }

}
