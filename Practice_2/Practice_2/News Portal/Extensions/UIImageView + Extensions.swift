//
//  UIImageView + Extensions.swift
//  Practice_2
//
//  Created by KirRealDev on 20.09.2021.
//

import Foundation
import UIKit

var imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {

    func loadImage(url: String) {
        let activityIndicator = UIActivityIndicatorView()
        var task: URLSessionDataTask?

        guard let url = URL(string: url) else { return }

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.startAnimating()

        if let task = task {
            task.cancel()
        }
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            image = cachedImage
            activityIndicator.removeFromSuperview()
            return
        }

        task = URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil { return }
            guard let data = data, let newImage = UIImage(data: data) else { return }

            imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                self.image = newImage
                activityIndicator.removeFromSuperview()
            }
        }
        task?.resume()
    }
}
