//
//  GridCollectionViewCell.swift
//  Practice_2
//
//  Created by KirRealDev on 15.09.2021.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleGridLabel: UILabel!
    @IBOutlet private weak var descriptionGridLabel: UILabel!
    @IBOutlet private weak var dateGridLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureBy(_ item: ArticleDataModel) {
        if let imageURL = item.urlToImage {
            self.imageView.loadImage(url: imageURL)
        } else {
            self.imageView.image = UIImage(named: "placeholder")
        }
        self.titleGridLabel.text = item.title
        self.descriptionGridLabel.text = item.articleDescription
        guard let date = item.publishedAt else { return }
        self.dateGridLabel.text = convertToString(dateString: date, formatIn: "yyyy-MM-dd'T'HH:mm:ssZ", formatOut: "MMM d, h:mm a")
    }

}
