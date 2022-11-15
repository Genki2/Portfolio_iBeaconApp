//
//  AddUUIDListViewController.swift
//  iBeacon
//
//  Created by GENKIFUJIMOTO on 2022/11/11.
//

import UIKit
import RealmSwift

class AddUUIDViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var uuidText: UITextField!
    @IBOutlet weak var addNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uuidText.delegate = self
        self.addNameText.delegate = self
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
        let scanList = ScanList()
        
        scanList.addName = addNameText.text!
        scanList.UUID = uuidText.text!
        
        try! realm.write {
            realm.add(scanList,update: .modified)
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
    }
}
