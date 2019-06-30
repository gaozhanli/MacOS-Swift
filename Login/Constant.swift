//
//  Constant.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/31.
//  Copyright © 2019年 z14. All rights reserved.
//

import Foundation
//
//用于存储页面跳转似的部分数据
//
class Constant{
    static  let login = Constant()
    public  var account:String?   //保存登陆用的账号
    public var name:String?        //教师姓名
    public var student:String?     //学生姓名
    public var sno :String?         //学生学号
    private init(){
        
    }
}
