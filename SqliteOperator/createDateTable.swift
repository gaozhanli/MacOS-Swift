//
//  createDateTable.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/22.
//  Copyright © 2019年 z14. All rights reserved.
//

import Foundation
import UIKit

//
//对数据库的操作类
//
class table{
    static let operators = table()
    //获取数据库连接
    var db = Database.db.getConnection()
    
    //单例模式
    private init() {
    
    }
    
    //析构函数
    deinit {
        sqlite3_close(db)
    }
    
    //读取数据表，参数为建表语句
    public func create( sql : String) {
        var errorMesg:UnsafeMutablePointer<Int8>? = nil
        let result = sqlite3_exec(db, sql.cString(using: .utf8), nil, nil, &errorMesg)
        if(result != SQLITE_OK){
            print("create table error")
        }
        else{
            print("create table success")
        }
    }
    
    //查询数据表，返回string数组
    public func select(sql:String, place :Int) -> [String]{
        var dataList:[String] = []
        //sqlite3_stmt指针
        var statement:OpaquePointer?=nil
        if sqlite3_prepare_v2(db, sql.cString(using: .utf8), -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let rowData = sqlite3_column_text(statement, Int32(place))
                let filedValue = String.init(cString: rowData!)
                
                dataList.append(filedValue)
            }
            sqlite3_finalize(statement)
        }
        return dataList
    }
    
    //查询数据表，返回string数组
    public func select(sql:String, name:String, place :Int) -> [String]{
        var dataList:[String] = []
        //sqlite3_stmt指针
        var statement:OpaquePointer?=nil
        if sqlite3_prepare_v2(db, sql.cString(using: .utf8), -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, Int32(1), name.cString(using: .utf8), -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let rowData = sqlite3_column_text(statement, Int32(place))
                let filedValue = String.init(cString: rowData!)
                
                dataList.append(filedValue)
            }
            sqlite3_finalize(statement)
            
        }
        return dataList
    }
   
    //根据姓名查询
    public func selectByName(sql:String, name:String) ->[String]{
        var dataList:[String] = []
        //sqlite3_stmt指针
        var statement:OpaquePointer?=nil
        if sqlite3_prepare_v2(db, sql.cString(using: .utf8), -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, Int32(1), name.cString(using: .utf8), -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                for i in 0...6{            //查询某一姓名的全部信息
                    let rowData = sqlite3_column_text(statement, Int32(i))
                    let filedValue = String.init(cString: rowData!)
                    
                    dataList.append(filedValue)
                }
            }
            sqlite3_finalize(statement)
        }
        return dataList
    }
    
    
    //插入或更新数据,参数为sql语句和NSString数组
    public func insert(sql:String, data:[NSString]){
        //sqlite3_stmt指针
        var stmt:OpaquePointer? = nil
        let sql1 = sql.cString(using: .utf8)
        //编译sql
        let result = sqlite3_prepare_v2(db, sql1, -1, &stmt, nil)
        if result != SQLITE_OK{
            print("insert table error")
        }
        else{
            var n = 1
            for d in data{
                //print()
                //绑定参数
                sqlite3_bind_text(stmt, Int32(n), d.utf8String, -1, nil)
                n =  n+1
            }
        }
        
        //step执行
        let step_result = sqlite3_step(stmt)
        if step_result != SQLITE_DONE{
            print("step error");
        }
        else{
            print("insert success")
        }
        sqlite3_finalize(stmt)
    }
    
    //删除
    public func delete(sql:String, name:String){
        //sqlite3_stmt指针
        var stmt:OpaquePointer? = nil
        //编译sql
        let result = sqlite3_prepare_v2(db, sql.cString(using: .utf8), -1, &stmt, nil)
        if result != SQLITE_OK{
            print("delete table error")
        }
        sqlite3_bind_text(stmt, Int32(1), name.cString(using: .utf8), -1, nil)
        
        //step执行
        let step_result = sqlite3_step(stmt)
        if step_result != SQLITE_OK && step_result != SQLITE_DONE{
            sqlite3_finalize(stmt)
            print("step error");
        }
        else{
            //finalize
            sqlite3_finalize(stmt)
            print("delete success")
        }
    }
    
    //删除所有数据
    public func deleteAll(sql:String){
        //sqlite3_stmt指针
        var stmt:OpaquePointer? = nil
        //编译sql
        let result = sqlite3_prepare_v2(db, sql.cString(using: .utf8), -1, &stmt, nil)
        if result != SQLITE_OK{
            print("delete table error")
        }
        
        //step执行
        let step_result = sqlite3_step(stmt)
        if step_result != SQLITE_OK && step_result != SQLITE_DONE{
            sqlite3_finalize(stmt)
            print("step error");
        }
        else{
            //finalize
            sqlite3_finalize(stmt)
            print("delete success")
        }
    }
}
