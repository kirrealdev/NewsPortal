//
//  NewsFilterViewController.swift
//  Practice_2
//
//  Created by KirRealDev on 19.09.2021.
//

import UIKit

protocol NewsFilterViewControllerDelegate: AnyObject {
    func updateDataByFilter(filterName: String)
}

class NewsFilterViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Identifiers
    
    private let filterTypeCellIdentifier = "FilterTypeCellIdentifier"
    
    // MARK: - Proferties
    
    weak var delegate: NewsFilterViewControllerDelegate?
    private let arrayOfFilters = [
        "top headlines", "business", "entertainment", "general", "health", "science", "sports", "technology"
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    // MARK: - Methods
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.headerView()
    }
    
    private func headerView() -> UIView {
        let headerViewHeight: CGFloat = 40.0
        let headerView = UIView(frame: CGRect(x: 0.0,
                                        y: 0.0,
                                        width: self.tableView.frame.width,
                                        height: headerViewHeight))
        headerView.backgroundColor = .systemGray6
        
        let label = UILabel(frame: CGRect(x: 16.0,
                                          y: 0.0,
                                          width: self.tableView.frame.width,
                                          height: headerViewHeight))
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "HiraMinProN-W3", size: 17.0)
        label.text = "What's News"
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    // MARK: - Actions
    
    @IBAction func didCancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource

extension NewsFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfFilters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: filterTypeCellIdentifier) else {
            return UITableViewCell()
        }
        if UserDefaults.standard.integer(forKey: "TappedFilter") == indexPath.row {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.font = UIFont(name: "HiraMinProN-W3", size: 16.0)
        cell.textLabel?.text = arrayOfFilters[indexPath.row]
        
        return cell
    }

}

// MARK: - UITableViewDelegate

extension NewsFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaults.standard.set(indexPath.row, forKey: "TappedFilter")
        print("KEY", UserDefaults.standard.integer(forKey: "TappedFilter"))
        delegate?.updateDataByFilter(filterName: arrayOfFilters[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
