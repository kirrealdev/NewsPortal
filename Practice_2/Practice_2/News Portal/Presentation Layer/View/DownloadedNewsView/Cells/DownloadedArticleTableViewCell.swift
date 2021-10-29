//
//  DownloadedArticleTableViewCell.swift
//  Practice_2
//
//  Created by KirRealDev on 21.09.2021.
//

import UIKit

class DownloadedArticleTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(descriptionText: String, imageURL: String?) {
        if let imageURL = imageURL {
            self.articleImageView.loadImage(url: imageURL)
        }
        self.titleLabel.text = descriptionText
    }
    
}
