//
//  LoginViewController.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/31.
//  Copyright © 2019年 z14. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
//
//登陆界面
//
class LoginViewController: UIViewController, UITextFieldDelegate {
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    var btnLogin:UIButton!
    var btnSign:UIButton!
    //左手离脑袋的距离
    var offsetLeftHand:CGFloat = 60
    
    //左手图片,右手图片(遮眼睛的)
    var imgLeftHand:UIImageView!
    var imgRightHand:UIImageView!
    
    //左手图片,右手图片(圆形的)
    var imgLeftHandGone:UIImageView!
    var imgRightHandGone:UIImageView!
    
    //登录框状态
    var showType:LoginShowType = LoginShowType.NONE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //建表语句
        let sql = "Create Table If Not Exists teacher(account Text Primary Key, password Text , name Text)"
        table.operators.create(sql: sql)
        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        
        //猫头鹰头部
        let imgLogin =  UIImageView(frame:CGRect(x: mainSize.width/2-211/2, y: 100, width: 211, height: 109))
        imgLogin.image = UIImage(named:"owl-login")
        imgLogin.layer.masksToBounds = true
        self.view.addSubview(imgLogin)
        
        //猫头鹰左手(遮眼睛的)
        let rectLeftHand = CGRect(x: 61 - offsetLeftHand, y: 90, width: 40, height: 65)
        imgLeftHand = UIImageView(frame:rectLeftHand)
        imgLeftHand.image = UIImage(named:"owl-login-arm-left")
        imgLogin.addSubview(imgLeftHand)
        
        //猫头鹰右手(遮眼睛的)
        let rectRightHand = CGRect(x: imgLogin.frame.size.width / 2 + 60, y: 90, width: 40, height: 65)
        imgRightHand = UIImageView(frame:rectRightHand)
        imgRightHand.image = UIImage(named:"owl-login-arm-right")
        imgLogin.addSubview(imgRightHand)
        
        //登录框背景
        let vLogin =  UIView(frame:CGRect(x: 15, y: 200, width: mainSize.width - 30, height: 220))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
        self.view.addSubview(vLogin)
        
        //猫头鹰左手(圆形的)
        let rectLeftHandGone = CGRect(x: mainSize.width / 2 - 100,
                                      y: vLogin.frame.origin.y - 22, width: 40, height: 40)
        imgLeftHandGone = UIImageView(frame:rectLeftHandGone)
        imgLeftHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgLeftHandGone)
        
        //猫头鹰右手(圆形的)
        let rectRightHandGone = CGRect(x: mainSize.width / 2 + 62,
                                       y: vLogin.frame.origin.y - 22, width: 40, height: 40)
        imgRightHandGone = UIImageView(frame:rectRightHandGone)
        imgRightHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgRightHandGone)
        
        //用户名输入框
        txtUser = UITextField(frame:CGRect(x: 30, y: 30, width: vLogin.frame.size.width - 60, height: 44))
        txtUser.delegate = self
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor.lightGray.cgColor
        txtUser.layer.borderWidth = 0.5
        txtUser.autocapitalizationType = .none
        txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtUser.leftViewMode = UITextField.ViewMode.always
        
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgUser.image = UIImage(named:"iconfont-user")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x: 30, y: 90, width: vLogin.frame.size.width - 60, height: 44))
        txtPwd.delegate = self
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor.lightGray.cgColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.isSecureTextEntry = true
        txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwd.leftViewMode = UITextField.ViewMode.always
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named:"iconfont-password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
    
        //添加登录按钮
        btnLogin = UIButton(frame:CGRect(x: mainSize.width/2, y: 150, width: 120, height: 50))
        btnLogin.setTitle("Login", for: .normal)
        btnLogin.backgroundColor = UIColor.gray
        vLogin.addSubview(btnLogin)
        
        //注册按钮
        btnSign = UIButton(frame:CGRect(x: mainSize.width/2 - 150, y: 150, width: 120, height: 50))
        btnSign.setTitle("Sign", for: .normal)
        btnSign.backgroundColor = UIColor.gray
        vLogin.addSubview(btnSign)
        
        //添加action
        txtUser.addTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControl.Event.editingDidBegin)
        txtPwd.addTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControl.Event.editingDidBegin)
        btnLogin.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        btnSign.addTarget(self, action: #selector(signEvent), for: .touchUpInside)
        //txtUser.text = AppArchiver.share.read()?.userCode
    }
    
    //输入框获取焦点开始编辑
    @objc private func textFieldDidBeginEditing(textField:UITextField)
    {
        //如果当前是用户名输入
        if textField.isEqual(txtUser){
            if (showType != LoginShowType.PASS)
            {
                showType = LoginShowType.USER
                return
            }
            showType = LoginShowType.USER
            
            //播放不遮眼动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRect(
                    x: self.imgLeftHand.frame.origin.x - self.offsetLeftHand,
                    y: self.imgLeftHand.frame.origin.y + 30,
                    width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x: self.imgRightHand.frame.origin.x + 48,
                    y: self.imgRightHand.frame.origin.y + 30,
                    width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x: self.imgLeftHandGone.frame.origin.x - 70,
                    y: self.imgLeftHandGone.frame.origin.y, width: 40, height: 40)
                self.imgRightHandGone.frame = CGRect(
                    x: self.imgRightHandGone.frame.origin.x + 30,
                    y: self.imgRightHandGone.frame.origin.y, width: 40, height: 40)
            })
        }
            //如果当前是密码名输入
        else if textField.isEqual(txtPwd){
            if (showType == LoginShowType.PASS)
            {
                showType = LoginShowType.PASS
                return
            }
            showType = LoginShowType.PASS
            
            //播放遮眼动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRect(
                    x: self.imgLeftHand.frame.origin.x + self.offsetLeftHand,
                    y: self.imgLeftHand.frame.origin.y - 30,
                    width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x: self.imgRightHand.frame.origin.x - 48,
                    y: self.imgRightHand.frame.origin.y - 30,
                    width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x: self.imgLeftHandGone.frame.origin.x + 70,
                    y: self.imgLeftHandGone.frame.origin.y, width: 0, height: 0)
                self.imgRightHandGone.frame = CGRect(
                    x: self.imgRightHandGone.frame.origin.x - 30,
                    y: self.imgRightHandGone.frame.origin.y, width: 0, height: 0)
            })
        }
    }
    
    //登陆事件
    @objc func loginEvent () {
        //let s = "delete from teacher;"
        //table.operators.deleteAll(sql: s)
        //检查账号
        if(txtUser.text == "" || txtUser.text!.count == 0){
            // 创建
            let alertController = UIAlertController(title: "Warning⚠️", message: "The account is null!", preferredStyle:.alert)
            // 设置UIAlertAction
            let okAction = UIAlertAction(title: "Confirm", style: .default)
            // 添加
            alertController.addAction(okAction)
            // 弹出
            self.present(alertController, animated: true, completion: nil)
        }
        //检查密码
        if(txtPwd.text == "" || txtPwd.text!.count == 0){
            // 创建
            let alertController = UIAlertController(title: "Warning⚠️", message: "The password is null!", preferredStyle:.alert)
            // 设置UIAlertAction
            let okAction = UIAlertAction(title: "Confirm", style: .default)
            // 添加
            alertController.addAction(okAction)
            // 弹出
            self.present(alertController, animated: true, completion: nil)
        }
        //输入的账号和密码
        let user = txtUser.text!
        let pwd = txtPwd.text!
        //查询数据库中密码和账号
        var allUser:[String] = []
        var allPwd:[String] = []
        var allName:[String] = []
        let sql = "select * from teacher;";
        allUser = table.operators.select(sql: sql, place: 0)
        allPwd = table.operators.select(sql: sql, place: 1)
        allName = table.operators.select(sql: sql, place: 2)
        let count = allUser.count - 1
        var isOk = 0
        var isAccount = 0;
        
        for i in 0...count {
            if(allUser[i] == user){
                isAccount += 0
            }
            if(allUser[i] == user && allPwd[i] == pwd){   //代表登陆成功
                isOk += 1
                Constant.login.account = allUser[i]    //保存登陆成功时的用户信息
                Constant.login.name = allName[i]
                let studentInfo = UIStoryboard(name: "Main", bundle:nil)
                let insert = studentInfo.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                self.present(insert, animated: true, completion: nil)
            }
        }
        if(isAccount == 0){
            // 创建
            let alertController = UIAlertController(title: "Error⚠️", message: "The account is not exist!", preferredStyle:.alert)
            // 设置UIAlertAction
            let okAction = UIAlertAction(title: "Confirm", style: .default)
            // 添加
            alertController.addAction(okAction)
            // 弹出
            self.present(alertController, animated: true, completion: nil)
        }
        
        if(isAccount != 0 && isOk == 0){
            // 创建
            let alertController = UIAlertController(title: "Error⚠️", message: "The password is false!", preferredStyle:.alert)
            // 设置UIAlertAction
            let okAction = UIAlertAction(title: "Confirm", style: .default)
            // 添加
            alertController.addAction(okAction)
            // 弹出
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //注册事件
    @objc func signEvent(){
        let studentInfo = UIStoryboard(name: "Main", bundle:nil)
        let insert = studentInfo.instantiateViewController(withIdentifier: "sign") as! SignViewController
        self.present(insert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//登录框状态枚举
enum LoginShowType {
    case NONE
    case USER
    case PASS
}

