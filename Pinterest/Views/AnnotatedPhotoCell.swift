 //
 //  AnnotatedPhotoCell.swift
 //  ImagesDownloadAndCache
 //
 //  Created by SEPL MAC on 10/05/18.
 //  Copyright © 2018 Medigarage Studios LTD. All rights reserved.
 //


import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
  
  @IBOutlet fileprivate weak var containerView: UIView!
  @IBOutlet fileprivate weak var imageView: UIImageView!
  @IBOutlet fileprivate weak var captionLabel: UILabel!
  @IBOutlet fileprivate weak var commentLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
  }
  
  var photo: Photo? {
    didSet {
      if let photo = photo {
        imageView.image = photo.image
        imageView.contentMode = .scaleToFill

        captionLabel.text = photo.caption
        commentLabel.text = photo.comment
      }
    }
  }
  
}
