//
//  FirstViewController.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/22.
//  Copyright © 2019年 z14. All rights reserved.
//

import UIKit
//
//学生信息列表
//
class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!  //搜索栏
    @IBOutlet weak var studentTitle: UINavigationBar!    //学生信息页title
    var navigationBar:UINavigationBar?           //声明导航栏
    
    var name:[String]! = []         //姓名
    var sno:[String]! = []            //学号
    var keys: [String]!
    var studentInfo:[String:[(String, String)]] = [:]   //字典
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationItem = UINavigationItem()
        //创建右边按钮
        let rightBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,target: self, action: #selector(toAddStudent))
        //设置导航栏标题
        navigationItem.title = "Student Infos"
        //设置导航项右边的按钮
        navigationItem.setRightBarButton(rightBtn, animated: true)
        studentTitle.popItem(animated: true)
        studentTitle.pushItem(navigationItem, animated: true)
    }
    
    //初始化函数
    func inits(){
        name = []
        sno = []
        keys = []
        studentInfo = [:]
        
        //学生表建立语句
        let createSql = "Create Table If Not Exists student(name Text Primary Key, sno Text , school Text, id Text, native Text, phone Text, email Text)"
        table.operators.create(sql: createSql);
        
        let selectName = "select * from student order by name;";     //查询姓名
        let selectSno = "select * from student order by name;";          //查询学号
        
        name = table.operators.select(sql: selectName, place:0)
        sno = table.operators.select(sql: selectSno, place:1)
        
        var s = 0;      //学号数组下标
        for n in name{
            //将姓名转换为拼音
            let pinyin = n.transformToPinyin()
            let sec = pinyin.getHead()
            
            let ar = studentInfo[sec]
            if ar == nil{
                studentInfo[sec] = [(n, sno[s])]
            }else{
                studentInfo[sec]?.append((n, sno[s]))
            }
            s += 1;
            keys = studentInfo.keys.sorted()
        }
        
        tableView.reloadData()
        
        //搜索框
        let resultController = ResultTableViewController()
        searchController = UISearchController(searchResultsController: resultController)
        tableView.tableHeaderView = searchController.searchBar
        resultController.studentInfo = self.studentInfo
        searchController.searchResultsUpdater = resultController
    }
    
   //页面即将出现的函数
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inits()
    }
    
    // 表行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec  = keys[section]
        return studentInfo[sec]!.count
    }
    
    //返回单元格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell")
        let sec = keys[indexPath.section]
        let (name,sno) = studentInfo[sec]![indexPath.row]
        cell?.textLabel?.text = name
        cell?.detailTextLabel?.text = sno
        return cell!
    }
    
    //返回决定分区的头部
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }
    
    //实现索引数据源代理方法
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keys
    }
    
    //行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    //组头高
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    //组数
    func numberOfSections(in tableView: UITableView) -> Int{
        if keys != nil{
            return keys.count
        }else{
            return 0
        }
        
    }
    
    //返回编辑类型，滑动删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    //修改删除按钮文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    //点击删除按钮的响应事件
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let sql = "delete from student where name = ?;"
            let tableViewCell = tableView.cellForRow(at: indexPath)
            let name = tableViewCell?.textLabel?.text
            table.operators.delete(sql: sql, name: name!)
            inits()
        }
        
    }
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //获得点击的vcell
        let tableViewCell = sender as! UITableViewCell
        let names = tableViewCell.textLabel?.text
        
        if segue.identifier == "specialInfo"{
            let controller = segue.destination as! SpecialInfoViewController
             controller.name = names!
        }
    }
    
    //点击单元格跳转
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCell = tableView.cellForRow(at: indexPath)
        Constant.login.student = tableViewCell!.textLabel?.text
        Constant.login.sno = tableViewCell!.detailTextLabel?.text
        
        //页面跳转
        let studentInfo = UIStoryboard(name: "Main", bundle:nil)
        let insert = studentInfo.instantiateViewController(withIdentifier: "grade") as! SourceViewController
        self.present(insert, animated: true, completion: nil)
    }
    
    //跳转到添加学生信息界面
    @objc func toAddStudent(){
        let studentInfo = UIStoryboard(name: "Main", bundle:nil)
        let insert = studentInfo.instantiateViewController(withIdentifier: "Insert") as! InsertStudentInfoViewController
        self.present(insert, animated: true, completion: nil)
    }
}

