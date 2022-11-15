//
//  ScanUUIDListViewController.swift
//  iBeacon
//
//  Created by GENKIFUJIMOTO on 2022/11/11.
//

import UIKit
import RealmSwift

class ScanUUIDListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var uuidTableView: UITableView!
    
    //ScanListの配列
    var scanListArray:[ScanList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uuidTableView.delegate = self
        self.uuidTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //サイトデータ取得後serviceDataArryに格納
        let realm = try! Realm()
        let ScanListData = Array(realm.objects(ScanList.self))
        
        scanListArray = ScanListData
        uuidTableView.reloadData()
    }
    
    @IBAction func TapAddBtn(_ sender: Any) {
        //UUID追加画面に遷移準備
        guard let addUUIDVC = self.storyboard!.instantiateViewController(withIdentifier: "addUUIDVC") as? AddUUIDViewController
        else { return }
        //ログイン画面遷移
        present(addUUIDVC, animated: true)
    }
    
    //===========================
    // tableView 処理
    //===========================
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scanListArray.count
    }
    
    //セルの表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //cellのタグを使用し定義
        let scanAddName = cell.contentView.viewWithTag(1) as! UILabel
        let scanUUIDLabel = cell.contentView.viewWithTag(2) as! UILabel
        
        //セルに表示
        scanAddName.text = "登録名: " + scanListArray[indexPath.row].addName
        scanUUIDLabel.text = "UUID: " + scanListArray[indexPath.row].UUID
        
        return cell
    }
    
    //セルタップ時
    func tableView(_ beaconsTable: UITableView, didSelectRowAt indexPath:IndexPath) {
        
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "scanList") as! ScanResultViewController
        
        //タップしたUUIDを渡す
        nextVC.scanUUIDString = scanListArray[indexPath.row].UUID
        
        //画面遷移
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        
        let selectUUID = scanListArray[indexPath.row].UUID
        let realm = try! Realm()
        
        // 削除したいUUIDを検索
        let targetEmployee = realm.objects(ScanList.self).filter("UUID == '\(selectUUID)'")

        // 削除する
        do{
            try realm.write{
              realm.delete(targetEmployee)
            }
        } catch {
          print("Error \(error)")
        }
        
        // 更新
        let ScanListData = Array(realm.objects(ScanList.self))
        scanListArray = ScanListData
        uuidTableView.reloadData()
    }
    
}
