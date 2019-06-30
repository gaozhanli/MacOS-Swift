//
//  SqliteConnnection.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/22.
//  Copyright © 2019年 z14. All rights reserved.
//

import Foundation
//
//获取sqlite连接类
//
class Database{
    //单例模式
    static let db = Database();
     private init(){
        
    }
    
    //返回数据库的连接
    public  func getConnection()-> OpaquePointer? {
        var database:OpaquePointer? = nil
        var dbPath:String = ""
        //获得沙盒中的数据库文件名
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls.first!.appendingPathComponent("data.sqlite3")
        dbPath = url.path
        
        //打开数据库
        let result = sqlite3_open(dbPath, &database)
        if(result != SQLITE_OK){
            sqlite3_close(database);
            print("open database error")
            return nil;
        }
        else{
            print("open database success")
        }
        return database;
    }
}
