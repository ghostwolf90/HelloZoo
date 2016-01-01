# HelloZoo
參考資料:http://www.appcoda.com.tw/json-data-taipei-tutorial/

## 使用技術部份
* [索引字串（index String）](#index String)
* [修改標題視圖高度&的文字及顏色（Set Height & Font and Color）](#Set Height & Font and Color)
* [參考資料來源（Origin）](#Origin)

### 索引字串（index String）
從JSON抓下來的資料雖然已整理過了，但如果想將動物依園區分類時，可以參考下列方式，這是將資料擷取下來至Array後
```swift
func creatAnimalDic(){
  //先做20筆，發現太多筆在使用TableView時會崩潰...
  for item in 1...20 {
    let animalName = dataArray[item]["A_Name_Ch"] as? String
    let animalLocation = dataArray[item]["A_Location"] as? String
            
    if var animalValues = animalsDict[animalLocation!]{
      animalValues.append(animalName!)
      animalsDict[animalLocation!] = animalValues
    }else{
      animalsDict[animalLocation!] = [animalName!]
    }
  }
  animalSectonTitles = [String](animalsDict.keys)
  animalSectonTitles.sort({ $0 < $1 })    
}

override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
  //回傳區塊數
  return animalSectonTitles.count
}
    
//顯示區塊表頭標題
override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
  return animalSectonTitles[section]
}
```

###修改標題視圖高度&的文字及顏色（Set Height & Font and Color
美觀小技巧
```swift
//修改標題視圖高度
override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
  return 50
}
//修改標題視圖的文字及顏色
override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
  let headerView = view as! UITableViewHeaderFooterView
  headerView.textLabel?.textColor = UIColor.orangeColor()
  headerView.textLabel?.font = UIFont(name: "Avenir", size:  25.0)
}
```

### 參考資料來源（Origin）
APPCODA : http://www.appcoda.com.tw/json-data-taipei-tutorial/
台北市政府資料開放平台 : http://data.taipei/
