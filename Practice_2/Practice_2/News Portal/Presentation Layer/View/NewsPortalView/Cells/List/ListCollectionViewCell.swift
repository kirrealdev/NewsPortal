//
//  ListCollectionViewCell.swift
//  Practice_2
//
//  Created by KirRealDev on 15.09.2021.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleListLabel: UILabel!
    @IBOutlet private weak var descriptionListLabel: UILabel!
    @IBOutlet private weak var dateListLabel: UILabel!
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureBy(_ item: ArticleDataModel) {
        if let imageURL = item.urlToImage {
            self.imageView.loadImage(url: imageURL)
        } else {
            self.imageView.image = UIImage(named: "placeholder")
        }
        self.titleListLabel.text = item.title
        self.descriptionListLabel.text = item.articleDescription
        guard let date = item.publishedAt else { return }
        self.dateListLabel.text = convertToString(dateString: date, formatIn: "yyyy-MM-dd'T'HH:mm:ssZ", formatOut: "MMM d, h:mm a")
    }
}
