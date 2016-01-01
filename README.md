# HelloZoo
參考資料:http://www.appcoda.com.tw/json-data-taipei-tutorial/

## 使用技術部份
* [索引字串（index String）](#index String)
* [參考資料來源（Origin）](#Origin)

### 索引字串（index String）
從JSON抓下來的資料雖然已整理過了，但如果想將動物依園區分組時，可以參考下列方式
擷取下來至Array後
```swift
func creatAnimalDic(){
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
```

### 參考資料來源（Origin）
APPCODA : http://www.appcoda.com.tw/json-data-taipei-tutorial/
台北市政府資料開放平台 : http://data.taipei/
