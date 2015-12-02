//
//  PhotoCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Yevhen Herasymenko on 01/12/2015.
//  Copyright © 2015 YevhenHerasymenko. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = 10
    }
    
    func configure(photo: Photo) {
        if photo.image != nil {
            photoImageView.image = photo.image
        } else {
            activityIndicator.startAnimating()
            photo.loadedImage = { (image) -> Void in
                self.activityIndicator.startAnimating()
                self.activityIndicator.hidden = true
                self.photoImageView.image = photo.image
            }
        }
        
    }
    
}
