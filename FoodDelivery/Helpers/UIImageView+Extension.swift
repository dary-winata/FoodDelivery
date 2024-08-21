//
//  UIImageView+Extension.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 27/06/24.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {
        ImageCache.shared.countLimit = 100
        ImageCache.shared.totalCostLimit = 1024 * 1024 * 100
    }
}

extension UIImageView {
    
    
    /// Load The Image from internet with url for UIImageView
    /// - Parameter url: url to be loaded
    func load(url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, err in
            guard let self = self else {return}
            
            if let err = err {
                print("Failed to load image: \(err.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data,scale: 0.05) else {
                print("Error to load data image")
                return
            }
            
            ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString, cost: data.count)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
