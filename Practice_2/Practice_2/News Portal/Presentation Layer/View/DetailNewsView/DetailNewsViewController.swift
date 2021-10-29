//
//  DetailNewsViewController.swift
//  Practice_2
//
//  Created by KirRealDev on 15.09.2021.
//

import UIKit

class DetailNewsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Properties
    
    private var articleData: ArticleDataModel!
    private let newsCoreDataService = NewsCoreDataService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIBarItem()
        
        configureImageView()
        configureLabels()
    }
    
    // MARK: - Configure IU
    
    private func configureImageView() {
        if let imageURL = articleData.urlToImage {
            imageView.loadImage(url: imageURL)
        } else {
            imageView.image = UIImage(named: "placeHolder")
        }
    }
    
    private func configureLabels() {
        titleLabel.text = articleData.title
        descriptionLabel.text = articleData.articleDescription
        guard let date = articleData.publishedAt else { return }
        dateLabel.text = "Updated " + convertToString(dateString: date, formatIn: "yyyy-MM-dd'T'HH:mm:ssZ", formatOut: "MMM d, h:mm a")
    }
    
    private func updateUIBarItem() {
        if newsCoreDataService.findArticleObjectBy(title: articleData.title ?? "The title is empty") == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeButtonTapped))
        }
    }
    
    // MARK: - Actions
    @objc private func downloadButtonTapped() {
        newsCoreDataService.downloadObject(articleData: articleData)
        updateUIBarItem()
    }
    
    @objc private func removeButtonTapped() {
        newsCoreDataService.deleteObjectBy(title: articleData.title ?? "The title is empty")
        updateUIBarItem()
    }
    
    @IBAction func didSeeOriginalArticleButtonTapped(_ sender: Any) {
        guard let urlString = articleData.url,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func didShareArticleButtonTapped(_ sender: Any) {
        guard let urlString = articleData.url, let activityItem = URL(string: urlString) else { return }
        let activityViewController: UIActivityViewController = UIActivityViewController(
            activityItems: [activityItem], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

// MARK: - NewsPortalViewControllerDelegate

extension DetailNewsViewController: NewsPortalViewControllerDelegate {
    func updateDataBy(item: ArticleDataModel) {
        self.articleData = item
    }
}

// MARK: - DownloadNewsViewControllerDelegate

extension DetailNewsViewController: DownloadNewsViewControllerDelegate {
    func updateDataBy(downloadedItem: ArticleDataModel) {
        self.articleData = downloadedItem
    }
}
