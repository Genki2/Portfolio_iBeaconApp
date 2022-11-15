//
//  ViewController.swift
//  BeaconApp
//
//  Created by GENKIFUJIMOTO on 2022/04/14.
//

import UIKit
import CoreLocation

class ScanResultViewController: UIViewController, CLLocationManagerDelegate ,UITableViewDelegate, UITableViewDataSource {
    
    /*
     CoreLocation の概要
     位置関連イベントの配信を開始および停止するために使用するオブジェクト
     
     CLBeaconRegion の概要
     iBeaconデバイスの存在を検出するために使用される領域
     
     */
    
    // CoreLocation
    var locationManager : CLLocationManager!
    var beaconRegion : CLBeaconRegion!
    
    var beaconArry:[CLBeacon] = []
    var scanUUIDString: String!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ロケーションマネージャーオブジェクトを作成
        self.locationManager = CLLocationManager()
        
        // デリゲートを自身に設定
        self.locationManager.delegate = self
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // 位置情報の認証ステータスを取得
        let status = CLLocationManager.authorizationStatus()
        
        // 位置情報の認証が許可されていない場合は認証ダイアログを表示
        if (status != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // 受信対象のビーコンのUUIDを設定
        if let scanUUIDString = scanUUIDString {
            
            let uuid:UUID? = UUID(uuidString: scanUUIDString)
            print("uuid ====> \(uuid!)")
            
            // ビーコン領域の初期化
            beaconRegion = CLBeaconRegion(uuid: uuid!, identifier: "BeaconApp")
            self.locationManager.startMonitoring(for: self.beaconRegion)
        }
    }
    
    //===========================
    // ボタン 処理
    //===========================
    @IBAction func reset(_ sender: Any) {
    
        // ビーコン領域の観測を停止
        self.locationManager.stopMonitoring(for: self.beaconRegion)
        
        // beaconArry削除
        beaconArry.removeAll()
        
        // update tableView
        self.tableView.reloadData()
    }
    
    //===========================
    // locationManager デリゲート
    //===========================
    // 位置情報の認証ステータス変更
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .authorizedWhenInUse) {
            // ビーコン領域の観測を開始
            self.locationManager.startMonitoring(for: self.beaconRegion)
        }
    }
    
    //観測の開始に成功すると呼ばれる
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        //観測開始に成功したら、領域内にいるかどうかの判定をおこなう。→（didDetermineState）へ
        // ビーコン領域のステータスを取得
        self.locationManager.requestState(for: self.beaconRegion)
    }
    
    // ビーコン領域のステータスを取得
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for inRegion: CLRegion) {
        
        switch (state) {
        case .inside: // ビーコン領域内
            // ビーコンの測定を開始
            self.locationManager.startRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
            print("iBeacon inside")
            
            break
        case .outside: // ビーコン領域外
            print("iBeacon outside")
            break
            
        case .unknown: // 不明
            print("iBeacon unknown")
            break
            
        }
    }

    //領域内にいるので測定をする
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion){
        
        beaconArry = beacons
        
        // update tableView
        self.tableView.reloadData()
        
        /*
         beaconから取得できるデータ
         proximityUUID   :   regionの識別子
         major           :   識別子１
         minor           :   識別子２
         proximity       :   相対距離
         accuracy        :   精度
         rssi            :   電波強度
         
         timestamp:2022-04-15 00:52:16 +0000
         uuid:FDA50693-A4E2-4FB1-AFCF-C6EB07647825
         major:10065
         minor:26049
         proximity:immediate
         accuracy:0.03592646551894389
         rssi:-49
         */
        
        for beacon in beacons {
            
            print("uuid:\(beacon.uuid)")
            print("major:\(beacon.major)")
            print("minor:\(beacon.minor)")
            
            if (beacon.proximity == CLProximity.immediate) {
                //すぐそば
                print("proximity:immediate")
            }
            if (beacon.proximity == CLProximity.near) {
                //近く
                print("proximity:near")
            }
            if (beacon.proximity == CLProximity.far) {
                //遠い
                print("proximity:Far")
            }
            if (beacon.proximity == CLProximity.unknown) {
                //未検出
                print("proximity:unknown")
            }
            print("accuracy:\(beacon.accuracy)")
            print("rssi:\(beacon.rssi)")
            print("timestamp:\(beacon.timestamp)\n")
        }
    }
    
    //===========================
    // tableView 処理
    //===========================
    //cellの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beaconArry.count
    }
    
    //cellの内容表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell定義
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //cellのタグを使用し定義
        let uuidLabel = cell.contentView.viewWithTag(1) as! UILabel
        let majorMinorLabel = cell.contentView.viewWithTag(2) as! UILabel
        let proximityRssiLabel = cell.contentView.viewWithTag(3) as! UILabel
        
        //相対距離
        var proximityState = ""
        
        if (beaconArry[indexPath.row].proximity == CLProximity.immediate) {
            proximityState = "すぐそば"
        }
        if (beaconArry[indexPath.row].proximity == CLProximity.near) {
            proximityState = "近く"
        }
        if (beaconArry[indexPath.row].proximity == CLProximity.far) {
            proximityState = "遠い"
        }
        if (beaconArry[indexPath.row].proximity == CLProximity.unknown) {
            proximityState = "未検出"
        }
        
        //cellに表示
        uuidLabel.text = "UUID: " + (String(describing: beaconArry[indexPath.row].uuid))
        majorMinorLabel.text = "Major: " + (String(describing: beaconArry[indexPath.row].major)) + "　Minor: " + (String(describing: beaconArry[indexPath.row].minor))
        proximityRssiLabel.text = "RSSI: " + (String(describing: beaconArry[indexPath.row].rssi)) + "　proximity: " + proximityState
        
        return cell
    }
    
    //cellをタップ時の動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択解除
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    //cellの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
