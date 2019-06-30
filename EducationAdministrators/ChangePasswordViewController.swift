//
//  ChangePasswordViewController.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/31.
//  Copyright © 2019年 z14. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    //
    //管理员更改密码
    //
    @IBOutlet var passwords: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置密码隐藏
        for pwd in passwords{
            pwd.isSecureTextEntry = true
        }
    }
    
    //cancel
    @IBAction func cancle(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //confirm
    @IBAction func confirm(_ sender: Any) {
        var isWarn = 0
        if((passwords[0].text == "" || passwords[0].text!.count == 0) || (passwords[1].text == "" || passwords[1].text!.count == 0)){
            isWarn += 1
            // 创建
            let alertController = UIAlertController(title: "Warning⚠️", message: "The password is null!", preferredStyle:.alert)
            // 设置UIAlertAction
            let okAction = UIAlertAction(title: "Confirm", style: .default)
            // 添加
            alertController.addAction(okAction)
            // 弹出
            self.present(alertController, animated: true, completion: nil)
        }
        
        if(passwords[0].text! != passwords[1].text!){
            isWarn += 1
            // 创建
            let alertController = UIAlertController(title: "Error⚠️", message: "The two passwords are not same!", preferredStyle:.alert)
            // 设置UIAlertAction
            let okAction = UIAlertAction(title: "Confirm", style: .default)
            // 添加
            alertController.addAction(okAction)
            // 弹出
            self.present(alertController, animated: true, completion: nil)
        }
        
        //没有问题时，更新密码
        if isWarn == 0{
            var datas :[String] = []   //保存输入的数据
            datas.append(Constant.login.account!)
            datas.append(passwords[0].text!)
            datas.append(Constant.login.name!)
            
            let sql = "INSERT or replace INTO teacher(account,password, name) VALUES (?,?,?);"
            table.operators.insert(sql: sql, data: datas as [NSString] )
        }
        
        //退回到登陆j页面
        let studentInfo = UIStoryboard(name: "Main", bundle:nil)
        let insert = studentInfo.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.present(insert, animated: true, completion: nil)
    }
}
