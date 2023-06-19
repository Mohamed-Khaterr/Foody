//
//  UIImageView+Extension.swift
//  Foody
//
//  Created by Khater on 6/6/23.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    public func setImage(_ urlString: String) {
        let imageURL = URL(string: urlString)
        sd_imageIndicator = SDWebImageActivityIndicator.gray
        sd_setImage(with: imageURL, placeholderImage: Constant.defaultImage)
    }
}
