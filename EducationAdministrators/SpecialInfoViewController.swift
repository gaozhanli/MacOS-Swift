//
//  SpecialInfoViewController.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/28.
//  Copyright © 2019年 z14. All rights reserved.
//

import UIKit
//
//学生具体信息类，更新学生信息
//
class SpecialInfoViewController: UIViewController {

    //上一页面传来的学生姓名
    var name:String = "";
    //学生信息集合
    @IBOutlet var datas: [UITextField]!
    var infos:[String] = []      //保存查询得到的结果
    @IBOutlet weak var titleBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inits()
        datas[0].isEnabled = false       //姓名不可更改
        
        let navigationItem = UINavigationItem()
        //创建按钮
        let rightBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,target: self, action: #selector(cancal(_:)))
        //设置导航栏标题
        navigationItem.title = "Update Info"
        //设置导航项左边的按钮
        navigationItem.setLeftBarButton(rightBtn, animated: true)
        titleBar.popItem(animated: true)
        titleBar.pushItem(navigationItem, animated: true)
    }
    
    //查询数据库，初始化界面
    func inits(){
        let select = "select * from student where name = ?;"
        infos = table.operators.selectByName(sql: select, name:name)
        //初始化界面
        for i in 0...6{
            datas[i].text = infos[i]
        }
    }
    
    //更新学生信息
    @IBAction func update(_ sender: UIButton) {
        // 插入sql语句
        let sql = "INSERT or replace INTO student(name,sno, school, id, native, phone, email) VALUES (?,?,?,?,?,?,?);"
        //存储插入学生信息数组
        var datas1:[String] = []
        var isWarn = 0
        for s in datas{
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
            datas1.append(s.text!)
        }
        
        if isWarn == 0{
            //执行插入操作
            table.operators.insert(sql: sql, data: datas1 as [NSString])
            //返回上一级
            dismiss(animated: true, completion: nil)
        }
    }
    
    //取消
    @IBAction func cancal(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
