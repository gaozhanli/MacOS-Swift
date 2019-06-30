//
//  ResultTableTableViewController.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/28.
//  Copyright © 2019年 z14. All rights reserved.
//

import UIKit

//
//查询类
//
class ResultTableViewController: UITableViewController ,UISearchResultsUpdating{
    
    var studentInfo:[String:[(String, String)]] = [:]
    var names:[String]! = []       //名字
    var snos: [String]! = []                  //学号
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text      //搜索栏内容
        names.removeAll()
        
        for pairs in studentInfo.values{
            for (name, sno) in pairs{          //显示符合查询条件的姓名
                if name.transformToPinyin().range(of: searchText!, options: String.CompareOptions.caseInsensitive, range: nil, locale:nil) != nil || sno.range(of: searchText!, options: String.CompareOptions.caseInsensitive, range: nil, locale:nil) != nil{
                    names.append(name)
                    snos.append(sno)
                }
            }
        }
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }
    
    //点击cell事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(names[indexPath.row])
        Constant.login.student = names[indexPath.row]
        Constant.login.sno = snos[indexPath.row]
        //页面跳转
        let studentInfo = UIStoryboard(name: "Main", bundle:nil)
        let insert = studentInfo.instantiateViewController(withIdentifier: "grade") as! SourceViewController
        self.present(insert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        cell.detailTextLabel?.text = snos[indexPath.row]
        return cell
    }
}
