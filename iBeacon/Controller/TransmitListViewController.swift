//
//  TrasmitListViewController.swift
//  iBeacon
//
//  Created by GENKIFUJIMOTO on 2022/11/14.
//

import UIKit
import RealmSwift

class TransmitListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //ScanListの配列
    var transmitListArray:[TrasmitList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //サイトデータ取得後serviceDataArryに格納
        let realm = try! Realm()
        let trasmitListData = Array(realm.objects(TrasmitList.self))
        
        transmitListArray = trasmitListData
        tableView.reloadData()
    }
    
    @IBAction func TapAddBtn(_ sender: Any) {
        //UUID追加画面に遷移準備
        guard let addUUIDVC = self.storyboard!.instantiateViewController(withIdentifier: "addTransmit") as? AddTransmitViewController
        else { return }
        //ログイン画面遷移
        present(addUUIDVC, animated: true)
    }
    
    //===========================
    // tableView 処理
    //===========================
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transmitListArray.count
    }
    
    //セルの表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //cellのタグを使用し定義
        let scanAddName = cell.contentView.viewWithTag(1) as! UILabel
        let majorMinorLabel = cell.contentView.viewWithTag(2) as! UILabel
        let scanUUIDLabel = cell.contentView.viewWithTag(3) as! UILabel
        
        //セルに表示
        scanAddName.text = "登録名: " + transmitListArray[indexPath.row].addName
        majorMinorLabel.text = "Major: " + (String(describing: transmitListArray[indexPath.row].major)) + "　Minor: " + (String(describing: transmitListArray[indexPath.row].miner))
        scanUUIDLabel.text = "UUID: " + transmitListArray[indexPath.row].UUID
        
        return cell
    }
    
    //セルタップ時
    func tableView(_ beaconsTable: UITableView, didSelectRowAt indexPath:IndexPath) {
        
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "start") as! StartAdvertisingViewController
        
        //タップしたUUIDを渡す
        nextVC.uuidString = transmitListArray[indexPath.row].UUID
        nextVC.majorString = transmitListArray[indexPath.row].major
        nextVC.minerString = transmitListArray[indexPath.row].miner
        nextVC.addtitle = transmitListArray[indexPath.row].addName
        
        //画面遷移
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        
        let selectName = transmitListArray[indexPath.row].addName
        let realm = try! Realm()
        
        // 削除したい登録名を検索
        let targetEmployee = realm.objects(TrasmitList.self).filter("addName == '\(selectName)'")

        // 削除する
        do{
            try realm.write{
              realm.delete(targetEmployee)
            }
        } catch {
          print("Error \(error)")
        }
        
        // 更新
        let trasmitListData = Array(realm.objects(TrasmitList.self))
        transmitListArray = trasmitListData
        tableView.reloadData()
    }
}
