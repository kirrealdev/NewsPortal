//
//  SideMenuViewController.swift
//  Practice_2
//
//  Created by KirRealDev on 21.09.2021.
//

import UIKit

class SideMenuTableViewController: UITableViewController {

    // MARK: - Properties
    
    private let items = ["Cats List", "Star Wars List", "Cats + Dogs List", "News Portal"]
    private let newsFilterViewControllerIdentifier = "NewsFilterViewControllerIdentifier"
    private let sideMenuCellIdentifier = "SideMenuCellIdentifier"

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    // MARK: - Configure UI Methods
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: sideMenuCellIdentifier)
        tableView.separatorStyle = .none
    }

    // MARK: - Table View Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sideMenuCellIdentifier, for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let tab = self.presentingViewController as? UITabBarController else { return }
        self.dismiss(animated: true, completion: { tab.selectedIndex = indexPath.row })
    }
}
