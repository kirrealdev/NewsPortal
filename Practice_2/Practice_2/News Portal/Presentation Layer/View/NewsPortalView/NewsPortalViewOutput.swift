//
//  NewsPortalViewOutput.swift
//  Practice_2
//
//  Created by KirRealDev on 19.09.2021.
//

protocol NewsPortalViewControllerOutput: AnyObject {
    func prepareData(url: String)
    func didChangeFilter(filterName: String)
    func didChangeSortTypeByTitle(dataArray: [ArticleDataModel])
    func didChangeSortTypeByDate(dataArray: [ArticleDataModel])
    func searchBy(query: String)
}
