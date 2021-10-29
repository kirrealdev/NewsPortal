//
//  NewsPresenter.swift
//  Practice_2
//
//  Created by KirRealDev on 18.09.2021.
//

import UIKit

final class NewsPresenter {
    weak var viewInput: NewsPortalViewControllerInput?
    private let networkService = NewsNetworkService()
    
    private func filterArticlesData(_ data: [ArticleDataModel]) -> [ArticleDataModel] {
        var filteredData = [ArticleDataModel]()
        for iter in data {
            if (iter.title != nil || iter.publishedAt != nil) {
                filteredData.append(iter)
            }
        }
        return filteredData
    }
}

extension NewsPresenter: NewsPortalViewControllerOutput {
    
    func prepareData(url: String) {
        var selfUrl = url
        if url == "" {
            selfUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(NewsAPIParameters.newsAPIKey)"
        }
 
        networkService.performGetNewsDataRequestByUrl(url: selfUrl,
            onComplete: { [weak self] (data) in
                guard let self = self else { return }
                self.viewInput?.updateCollectionViewDataBy(item: self.filterArticlesData(data.articles))
            },
            onError: { (error) in NSLog(error.localizedDescription)
            }
        )
    }
    
    func didChangeFilter(filterName: String) {
        var url = ""
        
        if filterName == "top headlines" {
            url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(NewsAPIParameters.newsAPIKey)"
        } else {
            url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(NewsAPIParameters.newsAPIKey)" + "&category=\(filterName)"
        }
        prepareData(url: url)
    }
    
    func didChangeSortTypeByTitle(dataArray: [ArticleDataModel]) {
        let sortedArray = dataArray.sorted(by: { $0.title! < $1.title! })
        viewInput?.updateCollectionViewDataBy(item: sortedArray)
        
    }
    
    func didChangeSortTypeByDate(dataArray: [ArticleDataModel]) {
        let sortedArray = dataArray.sorted(by: { $0.publishedAt! > $1.publishedAt! })
        viewInput?.updateCollectionViewDataBy(item: sortedArray)
    }
    
    func searchBy(query: String) {
        prepareData(url: "https://newsapi.org/v2/everything?q=\(query)&apiKey=\(NewsAPIParameters.newsAPIKey)&sortBy=relevancy")
    }
}
