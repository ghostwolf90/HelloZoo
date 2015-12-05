//
//  MasterViewController.swift
//  HelloZoo
//
//  Created by Laibit on 2015/11/23.
//  Copyright © 2015年 Laibit. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate {

    //下滑選單
    var menuTransitionManager = MenuTransitionManager()

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var dataArray = [AnyObject]()
    var animalsDict = [String:[String]]()
    var animalSectonTitles = [String]()
    
    var area_lst = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //台北市立動物園公開網址
        let url = NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613")
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        //設定委任對象為自己
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        //設定下載網址
        let dataTask = session.downloadTaskWithURL(url!)
        
        dataTask.resume()
        
        for animal in dataArray{
            let animaltemp = (dataArray as! [String: AnyObject])["A_Location"] as! String
            print(animaltemp)
            /*
            let animalKey = animal.substringToIndex(animaltemp)
            
            if var animalValues = animalsDict[animalKey]{
                animalValues.append(animal)
                animalsDict[animalKey] = animalValues
            }else{
                animalsDict[animalKey] = [animal]
            }*/
            
        }
        animalSectonTitles = [String](animalsDict.keys)
        animalSectonTitles.sort({ $0 < $1 })
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let sourceController = segue.sourceViewController as! MenuTableViewController
        self.title = sourceController.currentItem
    }
    
    func creatAnimalDic(){
        for item in 1...100 {
            let animalName = dataArray[item]["A_Name_Ch"] as? String
            let animalLocation = dataArray[item]["A_Location"] as? String
            print(animalName)
            print(animalLocation)
            
            if var animalValues = animalsDict[animalLocation!]{
                animalValues.append(animalName!)
                animalsDict[animalLocation!] = animalValues
                print(animalValues)
            }else{
                animalsDict[animalLocation!] = [animalName!]
            }
        }
        animalSectonTitles = [String](animalsDict.keys)
        animalSectonTitles.sort({ $0 < $1 })    
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do{
            //JSON資料處理
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:[String: AnyObject]]
            //依據先前觀察的結構，取得result對應中的results所對應的陣列
            dataArray = dataDic["result"]!["results"] as! [AnyObject]
            
            creatAnimalDic()

            //重新整理Table View
            self.tableView.reloadData()
    
        }catch{
            print("Error!")
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Menu" {
            let menuTableViewController = segue.destinationViewController as! MenuTableViewController
            menuTableViewController.currentItem = self.title!
            menuTableViewController.transitioningDelegate = self.menuTransitionManager
            //menuTransitionManager.delegate = self
        }else if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //取得被選取到的這一隻動物的資料
                let object = dataArray[indexPath.row]
                //設定在第二個畫面控制器中的資料為這一隻動物的資料
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.thisAnimalDic = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        

    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return animalSectonTitles.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return animalSectonTitles[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let animalKey = animalSectonTitles[section]
        if let animalValues = animalsDict[animalKey]{
            return animalValues.count
        }
        //return dataArray.count
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MasterTableViewCell
        
        let animalKey = animalSectonTitles[indexPath.section]
        if let animalValues = animalsDict[animalKey]{
            cell.animalLbl?.text = animalValues[indexPath.row]
            let imageFilename = animalValues[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "_", options: [], range: nil)
            cell.imageView?.image = UIImage(named: imageFilename)
            
        }
        //顯示動物的中文名稱於Table View中
        //cell.animalLbl?.text = dataArray[indexPath.row]["A_Name_Ch"] as? String
        //cell.detailLbl?.text = dataArray[indexPath.row]["A_Location"] as? String
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

