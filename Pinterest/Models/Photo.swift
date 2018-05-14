//
//  Photo.swift
//  ImagesDownloadAndCache
//
//  Created by SEPL MAC on 10/05/18.
//  Copyright © 2018 Medigarage Studios LTD. All rights reserved.
//


import UIKit

struct Photo {
  
  var caption: String
  var comment: String
  var image: UIImage
  
  
  init(caption: String, comment: String, image: UIImage) {
    self.caption = caption
    self.comment = comment
    self.image = image
  }
  
  init?(dictionary: [String: String]) {
    guard let caption = dictionary["Caption"], let comment = dictionary["Comment"], let photo = dictionary["Photo"],
      let image = UIImage(named: "background") else {
        return nil
    }
    
    self.init(caption: caption, comment: comment, image: image)
  }


}
