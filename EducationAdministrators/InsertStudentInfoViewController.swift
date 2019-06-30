//
//  InsertStudentInfoViewController.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/26.
//  Copyright © 2019年 z14. All rights reserved.
//

import UIKit
//
//该类用于添加学生信息
//
class InsertStudentInfoViewController: UIViewController {

    //将插入数据库的信息
    @IBOutlet var studentInfo: [UITextField]!
    @IBOutlet weak var titleBar: UINavigationBar!   //导航栏
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationItem = UINavigationItem()
        //创建按钮
        let rightBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,target: self, action: #selector(back))
        //设置导航栏标题
        navigationItem.title = "Add student"
        //设置导航项左边的按钮
        navigationItem.setLeftBarButton(rightBtn, animated: true)
        titleBar.popItem(animated: true)
        titleBar.pushItem(navigationItem, animated: true)
    }
    
    //确认添加按钮
    @IBAction func insertConfirm(_ sender: UIButton) {
        // 插入sql语句
        let sql = "INSERT or replace INTO student(name,sno, school, id, native, phone, email) VALUES (?,?,?,?,?,?,?);"
        //存储插入学生信息数组
        var datas:[String] = []
        var isWarn = 0;
        for s in studentInfo{
            //当有一栏为空时，弹出警告视图
            if s.text! .count == 0 || s.text! == ""{
                isWarn = 1
                    // 创建
                let alertController = UIAlertController(title: "Warning⚠️", message: "The information is not complete", preferredStyle:.alert)
                    // 设置UIAlertAction
                let okAction = UIAlertAction(title: "Confirm", style: .default)
                    // 添加
                    alertController.addAction(okAction)
                    // 弹出
                self.present(alertController, animated: true, completion: nil)
            }
            datas.append(s.text!)
        }
        
        //执行插入操作
        table.operators.insert(sql: sql, data: datas as [NSString])
        //返回上一级
        if(isWarn == 0){
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    //取消添加
    @IBAction func insertCancle(_ sender: UIButton) {
        //table.operators.delete(sql: "drop table student;")
         dismiss(animated: true, completion: nil)
    }
    
    
    //按下done，关闭键盘
    @IBAction func textFieldDoneEditing(sender:UITextView){
        sender.resignFirstResponder()
    }
    
    //轻触背景关闭键盘
    @IBAction func onTapGestureRecognized(_ sender: UITapGestureRecognizer) {
        for s in studentInfo{
            s.resignFirstResponder()
        }
    }
    
    //回退到上一级
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }
}
