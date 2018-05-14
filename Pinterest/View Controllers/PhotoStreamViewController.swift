//
//  PhotoStreamViewController.swift
//  ImagesDownloadAndCache
//
//  Created by SEPL MAC on 10/05/18.
//  Copyright © 2018 Medigarage Studios LTD. All rights reserved.
//


import UIKit
import AVFoundation

class PhotoStreamViewController: UICollectionViewController {
  
  var photos = [Photo]()
  var photoUrls  :[String]!

  var refreshCtrl: UIRefreshControl!
  var tableData:[AnyObject]!
  var task: URLSessionDownloadTask!
  var session: URLSession!
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    session = URLSession.shared
    task = URLSessionDownloadTask()
    photoUrls = []
    
    self.refreshCtrl = UIRefreshControl()
    self.refreshCtrl.addTarget(self, action: #selector(PhotoStreamViewController.refreshTableView), for: .valueChanged)
    refreshTableView()
//    self.refreshCtrl = self.refreshCtrl
    if #available(iOS 10.0, *) {
      self.collectionView?.refreshControl = self.refreshCtrl
    } else {
      // Fallback on earlier versions
    }
    if let patternImage = UIImage(named: "Pattern") {
      view.backgroundColor = UIColor(patternImage: patternImage)
    }
    collectionView?.backgroundColor = UIColor.clear
    collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
    // Set the PinterestLayout delegate
    if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
      layout.delegate = self
    }
  }
  @objc func refreshTableView(){
    
    let url:URL! = URL(string: "http://pastebin.com/raw/wgkJgazE")
    task = session.downloadTask(with: url, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
      
      if location != nil{
        let data:Data! = try? Data(contentsOf: location!)
        do{
          
          let response = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSArray
          for jsonResult   in response  {
            if let dictionary = jsonResult as? Dictionary<String, AnyObject> {
              var user = dictionary["user"] as? Dictionary<String, AnyObject>
              var urls = dictionary["urls"] as? Dictionary<String, AnyObject>
              let populatedDictionary = ["Caption": user!["name"]!  , "Comment": "","Photo":urls!["raw"]!] as! [String : String]
              
              if let photo = Photo(dictionary: populatedDictionary) {
                self.photos.append(photo)
              }
              self.photoUrls.append(urls!["raw"] as! String)
              print(populatedDictionary)
            }
          }
          DispatchQueue.main.async(execute: { () -> Void in
            self.collectionView?.reloadData()
           
            if #available(iOS 10.0, *) {
              self.collectionView?.refreshControl?.endRefreshing()
            } else {
              // Fallback on earlier versions
            }
            
          })
          
        }catch{
          print("something went wrong, try again")
        }
      }
    })
    task.resume()
  }
}

extension PhotoStreamViewController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(photoUrls)
    return photos.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath)
    if let annotateCell = cell as? AnnotatedPhotoCell
    {
      annotateCell.photo = photos[indexPath.item]
      
      let request = URLRequest.init(url: URL.init(string: photoUrls[indexPath.item] )!)
      
      let downloadKey = NSDownloadManager.shared.dowloadFile(withRequest: request,
                                                             inDirectory: "",
                                                             withName: "",
                                                             onProgress: nil
        ){ [weak self] (error, data) in
        if let error = error {
          print("Error is \(error as NSError)")
        } else {
          if let data = data {
          
              let img:UIImage! = UIImage(data: data)
              annotateCell.photo?.image = img
          
            

          }
        }
      }
    }
    return cell
  }
  
}

//MARK: - PINTEREST LAYOUT DELEGATE
extension PhotoStreamViewController : PinterestLayoutDelegate {
  
  // 1. Returns the photo height
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    if(indexPath.item % 2 == 0)
    {
      return photos[indexPath.item].image.size.height/4
    }
    else
    {
      return photos[indexPath.item].image.size.height/5

    }
  }

}
