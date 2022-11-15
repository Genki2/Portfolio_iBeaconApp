//
//  AddTranmitViewController.swift
//  iBeacon
//
//  Created by GENKIFUJIMOTO on 2022/11/15.
//

import UIKit
import RealmSwift

class AddTransmitViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var uuidText: UITextField!
    @IBOutlet weak var addNameText: UITextField!
    @IBOutlet weak var majorText: UITextField!
    @IBOutlet weak var minerText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uuidText.delegate = self
        self.addNameText.delegate = self
        self.majorText.delegate = self
        self.minerText.delegate = self
        
        
        majorText.keyboardType = UIKeyboardType.numberPad
        minerText.keyboardType = UIKeyboardType.numberPad
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        
        if (uuidText.text == "" || addNameText.text == ""){
            self.showErrorAlert(message: "登録名またはUUIDが入力されていません。")
            return
        }
        
        if uuidText.text!.count < 32 {
            self.showErrorAlert(message: "UUIDの値が足りません")
            return
        }
        
        let realm = try! Realm()
        let transmitList = TrasmitList()
        
        transmitList.addName = addNameText.text!
        transmitList.UUID = uuidText.text!
        transmitList.major = majorText.text!
        transmitList.miner = minerText.text!
        
        try! realm.write {
            realm.add(transmitList,update: .modified)
        }
        
        self.dismiss(animated: true)
    }
    
    //エラー表示
    func showErrorAlert(message:String){
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true)
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
        self.uuidText.endEditing(true)
        self.addNameText.endEditing(true)
        self.majorText.endEditing(true)
        self.minerText.endEditing(true)
    }
}
