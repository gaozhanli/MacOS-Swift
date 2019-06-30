//
//  SourceViewController.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/6/1.
//  Copyright © 2019年 z14. All rights reserved.
//

import UIKit

class SourceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //
    //学生成绩显示界面
    //
    @IBOutlet weak var titleBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    var cnames:[String] = []    //课程表
    var cnos:[String] = []         //课程号表
    var grades:[String] = []     //成绩表
    let sno = Constant.login.sno!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationItem = UINavigationItem()
        //创建按钮
        let rightBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,target: self, action: #selector(cancel))
        //设置导航栏标题
        navigationItem.title = "\(String(describing: Constant.login.student!))'s grades"
        //设置导航项zuo边的按钮
        navigationItem.setLeftBarButton(rightBtn, animated: true)
        titleBar.popItem(animated: true)
        titleBar.pushItem(navigationItem, animated: true)
        
        inits();
//        let delete1 = "drop table sc";
//        let delete2 = "drop table course"
//        table.operators.deleteAll(sql: delete1)
//        table.operators.deleteAll(sql: delete2)
        //let selectGrade = "Select * from sc;"      //查询该学生课程成绩
        
        let select2 = "select * from sc where sno = ? ;"  //查询数据时有查询数据不完整的现象，未知原因
        grades = table.operators.select(sql: select2, name:sno , place: 2)
        cnos = table.operators.select(sql: select2,  name:sno , place: 1)
        
        let selectCname = "select * from course where cno = ? ;"    //查询课程名
        for c in cnos{
            var cname = table.operators.select(sql: selectCname, name: c, place: 0)
            cnames.append(cname[0])
        }
    }
    
    //构建课程表，学生成绩表
    func inits(){
        //建立成绩表
        let createC = "Create Table If Not Exists course(cname Text Primary Key, cno Text , tname Text)"   //建立课程表
        table.operators.create(sql: createC)
        let createG = "Create Table If Not Exists sc(sno Text, cno Text, grade Text)"    //建立成绩表
        table.operators.create(sql: createG)
        
        let courses:[[String]] = [["Object-C","1","gao"], ["English","2","huang"], ["Unix", "3", "feng"], ["Database","4","zhang"]]
        
        let grades:[[String]] = [[sno,"1","97"], [sno, "2","79"], [sno,"3","91"], [sno,"4","93"]]
        
        let insertC = "INSERT or replace INTO course(cname,cno, tname) VALUES (?,?,?);"    //插入课程表
        for c in courses{
            table.operators.insert(sql: insertC, data: c as [NSString])
        }
        let insertG = "INSERT or replace INTO sc(sno,cno, grade) VALUES (?,?,?);"               //插入成绩表
        for g in grades{
            table.operators.insert(sql: insertG, data: g as [NSString])
        }
    }
    
    // 表行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cnames.count
    }
    
    //返回单元格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell")
        cell?.textLabel?.text = cnames[indexPath.row]
        cell?.detailTextLabel?.text = grades[indexPath.row]
        return cell!
    }
    
    //行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    //返回上一界面
   @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
}
