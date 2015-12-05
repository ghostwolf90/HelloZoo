//
//  DetailViewController.swift
//  HelloZoo
//
//  Created by Laibit on 2015/11/23.
//  Copyright © 2015年 Laibit. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDownloadDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var thisAnimalDic:AnyObject?
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animalName = (thisAnimalDic as! [String: AnyObject])["A_Name_Ch"]
        self.detailDescriptionLabel?.text = animalName as! String
        
        //取得圖片網址
        let url = (thisAnimalDic as! [String: AnyObject])["A_Pic01_URL"]
        if let url = url //如果有圖片網址，向伺服器請求圖片資料
        {
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            
            let dataTask = session.downloadTaskWithURL(NSURL(string: url as! String)!)
            
            dataTask.resume()
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        guard let imageData = NSData(contentsOfURL: location) else {
            return
        }
        
        imageView.image = UIImage(data: imageData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

