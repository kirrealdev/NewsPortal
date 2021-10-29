//
//  NewsPortalViewController.swift
//  Practice_2
//
//  Created by KirRealDev on 15.09.2021.
//

import UIKit

protocol NewsPortalViewControllerDelegate: AnyObject {
    func updateDataBy(item: ArticleDataModel)
}

class NewsPortalViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var changeCollectionViewTypeButton: UIBarButtonItem!
    @IBOutlet private weak var changeSortTypeByTitleButton: UIButton!
    @IBOutlet private weak var changeSortTypeByDateButton: UIButton!
    
    // MARK: - Identifiers
    
    private let listCollectionViewCellIdentifier = "ListCollectionViewCellIdentifier"
    private let gridCollectionViewCellIdentifier = "GridCollectionViewCellIdentifier"
    private let detailNewsViewControllerIdentifier = "DetailNewsViewControllerIdentifier"
    private let newsFilterViewControllerIdentifier = "NewsFilterViewControllerIdentifier"
    private let downloadNewsViewControllerIdentifier = "DownloadNewsViewControllerIdentifier"
    
    // MARK: - Properties
    
    private let presenter = NewsPresenter()
    private var output: NewsPortalViewControllerOutput!
    internal var isList: Bool = true
    private var searchViewController: UISearchController!
    internal var arrayOfArticleData = [ArticleDataModel]()
    weak var delegate: NewsPortalViewControllerDelegate?
    private var activityIndicator = ActivityIndicatorViewController()
    private var isFirstLoaded = true
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.output = presenter
        self.presenter.viewInput = self
        
        showLoader()
        output.prepareData(url: "")
        
        configureNavigationBar()
        configureCollectionView()
    }
    
    // MARK: - Configure IU
    
    private func configureNavigationBar() {
        navigationItem.title = "News Portal"
        
        searchViewController = UISearchController(searchResultsController: nil)
        searchViewController.searchBar.delegate = self
        navigationItem.searchController = searchViewController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: String(describing: ListCollectionViewCell.self),
                                      bundle: nil), forCellWithReuseIdentifier: listCollectionViewCellIdentifier)
        collectionView.register(UINib(nibName: String(describing: GridCollectionViewCell.self),
                                      bundle: nil), forCellWithReuseIdentifier: gridCollectionViewCellIdentifier)
    }
    
    // MARK: - Actions
    
    @IBAction private func didChangeCollectionViewTypeButtonTapped(_ sender: Any) {
        if isList {
            isList = false
            DispatchQueue.main.async {
                self.changeCollectionViewTypeButton.image = UIImage(systemName: "list.dash")
                self.collectionView.reloadData()
            }
        } else {
            isList = true
            DispatchQueue.main.async {
                self.changeCollectionViewTypeButton.image = UIImage(systemName: "square.grid.3x1.below.line.grid.1x2")
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction private func didChangeFilterTypeButtonTapped(_ sender: Any) {
        guard let newsFilterVC = storyboard?.instantiateViewController(identifier: newsFilterViewControllerIdentifier) as? NewsFilterViewController else {
            return
        }
        newsFilterVC.delegate = self
        newsFilterVC.modalPresentationStyle = .automatic
        present(newsFilterVC, animated: true, completion: nil)
    }
    
    @IBAction func didSortByTitleButtonTapped(_ sender: Any) {
        output.didChangeSortTypeByTitle(dataArray: self.arrayOfArticleData)
        changeSortTypeByDateButton.tintColor = .systemBlue
        changeSortTypeByTitleButton.tintColor = .systemGray
    }
    
    @IBAction func didSortByDateButtonTapped(_ sender: Any) {
        output.didChangeSortTypeByDate(dataArray: self.arrayOfArticleData)
        changeSortTypeByTitleButton.tintColor = .systemBlue
        changeSortTypeByDateButton.tintColor = .systemGray
    }
    
    @IBAction func didDownloadedItemsButtonTapped(_ sender: Any) {
        guard let downloadNewsViewController = storyboard?.instantiateViewController(identifier: self.downloadNewsViewControllerIdentifier) as? DownloadNewsViewController else {
            fatalError()
        }
        navigationController?.pushViewController(downloadNewsViewController, animated: true)
    }
    
    // MARK: - Activity Indicator

    func showLoader() {
        view.addSubview(activityIndicator.view)
    }

    func hideLoader() {
        activityIndicator.view.removeFromSuperview()
    }
}

// MARK: - NewsPortalViewControllerInput

extension NewsPortalViewController: NewsPortalViewControllerInput {
    func updateCollectionViewDataBy(item: [ArticleDataModel]) {
        self.arrayOfArticleData = item
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.hideLoader()
            if self.isFirstLoaded {
                self.changeSortTypeByDateButton.tintColor = .systemGray
            }
            self.isFirstLoaded = false
        }
    }
}

// MARK: - NewsFilterViewControllerDelegate

extension NewsPortalViewController: NewsFilterViewControllerDelegate {
    func updateDataByFilter(filterName: String) {
        showLoader()
        output.didChangeFilter(filterName: filterName)
    }
}

// MARK: - UICollectionViewDataSource

extension NewsPortalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfArticleData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.isList {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.listCollectionViewCellIdentifier,
                                                                for: indexPath) as? ListCollectionViewCell else {
                fatalError()
            }
            
            cell.configureBy(arrayOfArticleData[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.gridCollectionViewCellIdentifier,
                                                                for: indexPath) as? GridCollectionViewCell else {
                fatalError()
            }
            cell.configureBy(arrayOfArticleData[indexPath.row])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension NewsPortalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let detailNewsViewController = storyboard?.instantiateViewController(identifier: self.detailNewsViewControllerIdentifier) as? DetailNewsViewController else {
            fatalError()
        }
        delegate = detailNewsViewController
        delegate?.updateDataBy(item: arrayOfArticleData[indexPath.row])
        
        navigationController?.pushViewController(detailNewsViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewsPortalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.isList {
            let leftAndBottomSpacing: CGFloat = 12.0
            let width = collectionView.frame.width - leftAndBottomSpacing
            let height = collectionView.frame.height / 2.0
            
            return CGSize(width: width, height: height)
        } else {
            let numberOfItemsPerRow: CGFloat = 2.0
            let interItemSpacing: CGFloat = 5.0
            
            let width = (collectionView.frame.width - (numberOfItemsPerRow - 1.0) * interItemSpacing) / numberOfItemsPerRow
            let height = width
            
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let lineSpacing: CGFloat = 5.0
        
        return lineSpacing
    }
}

// MARK: - UISearchBarDelegate

extension NewsPortalViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UserDefaults.standard.set(0, forKey: "TappedFilter")
        output.searchBy(query: searchText)
    }
}
