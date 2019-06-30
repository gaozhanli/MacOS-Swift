//
//  SignViewController.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/31.
//  Copyright © 2019年 z14. All rights reserved.
//

import UIKit

//
//注册界面
//

class SignViewController: UIViewController {
    
@IBOutlet weak var titleBar: UINavigationBar!
    @IBOutlet var TeacherInfo: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TeacherInfo[1].isSecureTextEntry = true
        
        let navigationItem = UINavigationItem()
        //创建按钮
        let rightBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,target: self, action: #selector(cancel(_:)))
        //设置导航栏标题
        navigationItem.title = "Sign"
        //设置导航项左边的按钮
        navigationItem.setLeftBarButton(rightBtn, animated: true)
        titleBar.popItem(animated: true)
        titleBar.pushItem(navigationItem, animated: true)
    }
    
    //confirm
    @IBAction func confirm(_ sender: Any) {
        var datas:[String] = []       //保存数据
        var isWarn = 0
        for s in TeacherInfo{
            //当有一栏为空时，弹出警告视图
            if s.text! .count == 0 || s.text! == ""{
                 isWarn += 1
                // 创建
                let alertController = UIAlertController(title: "Warning⚠️", message: "The information is not complete!", preferredStyle:.alert)
                // 设置UIAlertAction
                let okAction = UIAlertAction(title: "Confirm", style: .default)
                // 添加
                alertController.addAction(okAction)
                // 弹出
                self.present(alertController, animated: true, completion: nil)
            }
            datas.append(s.text!)
        }
        if isWarn == 0 {
            //插入语句
            let sql = "INSERT or replace INTO teacher(account,password, name) VALUES (?,?,?);"
            table.operators.insert(sql: sql, data: datas as [NSString])
            //返回上一级
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    //cancel
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
