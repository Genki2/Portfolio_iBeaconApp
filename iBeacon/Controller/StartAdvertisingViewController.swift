//
//  TrasmitStartViewController.swift
//  iBeacon
//
//  Created by GENKIFUJIMOTO on 2022/11/15.
//

import UIKit
import CoreLocation
import CoreBluetooth
import RealmSwift

class StartAdvertisingViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate{
    
    var localBeacon : CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    var uuidString = ""
    var addtitle = ""
    var majorString = ""
    var minerString = ""
    
    let BEACON_ID: String = "BEACON"
    var MAJOR: CLBeaconMajorValue = 0
    var MINOR: CLBeaconMinorValue = 0
    
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var minerTextField: UITextField!
    
    @IBOutlet weak var transmissionBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(uuidString)
        
        transmissionBtn.setTitle("発信開始", for: .normal)
        
        majorTextField.text = majorString
        minerTextField.text = minerString
        
        majorTextField.keyboardType = UIKeyboardType.numberPad
        minerTextField.keyboardType = UIKeyboardType.numberPad
        
        transmissionBtn.isEnabled = true
        stopBtn.isEnabled = false
    }
    
    // Beaconを起動
    func initBeacon() {
        
        if localBeacon != nil {
            stopLocalBeacon()
        }
        
        localBeacon = createBeaconRegion()!
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        //CBPeripheralデリゲート
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }

    // Bluetoothの電源が切り替わった際に実行される処理
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
    
    // Beaconを停止
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    // ビーコン発信情報
    func createBeaconRegion() -> CLBeaconRegion? {
        
        let uuid: UUID = UUID(uuidString: uuidString)!
        
        print(uuid)
        
        return CLBeaconRegion (
            uuid: uuid,
            major: self.MAJOR,
            minor: self.MINOR,
            identifier: self.BEACON_ID
        )
    }
    
    func updateTrasmitdate(){
        
        let realm = try! Realm()
        let transmitList = TrasmitList()

        transmitList.addName = addtitle
        transmitList.major = majorTextField.text!
        transmitList.miner = minerTextField.text!
        transmitList.UUID = uuidString

        try! realm.write {
            realm.add(transmitList,update: .modified)
        }
    }
    
    @IBAction func start(_ sender: Any) {
        
        transmissionBtn.setTitle("発信中", for: .normal)
        transmissionBtn.isEnabled.toggle()
        stopBtn.isEnabled.toggle()
        
        if let majorint = UInt16(majorTextField.text!){
            MAJOR = majorint
        }
        
        if let minerint = UInt16(minerTextField.text!){
            MINOR = minerint
        }
        
        self.updateTrasmitdate()
        self.initBeacon()
    }
    
    
    @IBAction func stop(_ sender: Any) {
        
        stopBtn.isEnabled = false
        transmissionBtn.isEnabled = true
        transmissionBtn.setTitle("発信開始", for: .normal)
        self.stopLocalBeacon()
    }
    
    //=======================
    //MARK: キーボード UITextFieldDelegate
    //=======================
    //キーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    //キーボード閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.majorTextField.endEditing(true)
        self.minerTextField.endEditing(true)
    }
        
}
