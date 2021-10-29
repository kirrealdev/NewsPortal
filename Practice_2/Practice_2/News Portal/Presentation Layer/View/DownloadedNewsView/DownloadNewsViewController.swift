//
//  DownloadNewsViewController.swift
//  Practice_2
//
//  Created by KirRealDev on 21.09.2021.
//

import UIKit
import CoreData

protocol DownloadNewsViewControllerDelegate: AnyObject {
    func updateDataBy(downloadedItem: ArticleDataModel)
}

class DownloadNewsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var articlefetchResultsController: NSFetchedResultsController<ArticleEntity>?
    private var articleUniTitleName: String?
    private let detailNewsViewControllerIdentifier = "DetailNewsViewControllerIdentifier"
    private let downloadedArticleCell = "DownloadedArticleCell"
    private let detailViewIdentifier = "detailViewController"
    private let newsCoreDataService = NewsCoreDataService.shared
    weak var delegate: DownloadNewsViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Saved Articles"
        configureTableView()
        articlefetchResultsController = configureFetchResultsController()
        articlefetchResultsController?.delegate = self
        
        try? articlefetchResultsController?.performFetch()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Methods
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: DownloadedArticleTableViewCell.self), bundle: nil), forCellReuseIdentifier: downloadedArticleCell)
    }
    
    func configureFetchResultsController() -> NSFetchedResultsController<ArticleEntity>? {
        newsCoreDataService.getFetchResultsController(entityName: String(describing: ArticleEntity.self), sortDescriptorKey: "title", filterKey: articleUniTitleName) as? NSFetchedResultsController<ArticleEntity>
    }
}

// MARK: - UITableViewDataSource

extension DownloadNewsViewController: UITableViewDataSource {
    func numbersOfSections() -> Int {
        return articlefetchResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlefetchResultsController?.sections?[section].objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: downloadedArticleCell) as? DownloadedArticleTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(descriptionText: articlefetchResultsController?.object(at: indexPath).title ?? "The title is empty", imageURL: articlefetchResultsController?.object(at: indexPath).urlToImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width / 4.0
    }
}

// MARK: - UITableViewDelegate

extension DownloadNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = articlefetchResultsController?.object(at: indexPath) else { return }

        guard let detailNewsViewController = storyboard?.instantiateViewController(identifier: self.detailNewsViewControllerIdentifier) as? DetailNewsViewController else {
                fatalError()
        }
        delegate = detailNewsViewController
        delegate?.updateDataBy(downloadedItem: ArticleDataModel(title: item.title, articleDescription: item.articleDescription, url: item.url, urlToImage: item.urlToImage, publishedAt: item.publishedAt))
        navigationController?.pushViewController(detailNewsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
           let object = articlefetchResultsController?.object(at: indexPath) {
            newsCoreDataService.persistentContainer.viewContext.delete(object)
            newsCoreDataService.saveContext()
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension DownloadNewsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
