//
//  SecondViewController.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/22.
//  Copyright © 2019年 z14. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

//
//用户f个人信息类
//
class SecondViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePictureButton: UIButton!
    var avPlayerViewController:AVPlayerViewController!
    var image: UIImage?
    var movieURL :URL?
    var lastChosenMediaType:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = "Welcome, \(String(describing: Constant.login.name!))!"
        
        readWithFile()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            takePictureButton.isHidden = true
        }
    }
    
    @IBAction func shootPictureOrVideo(_ sender: Any) {
        pickMediaFromSource(UIImagePickerController.SourceType.camera)
    }
    
    @IBAction func selectExistingPictureOrVedio(_ sender: Any) {
        pickMediaFromSource(UIImagePickerController.SourceType.photoLibrary)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDisPlay()
    }
    
    
    func setAVPlayerViewLayoutConstraints(){
        let avPlayerView = avPlayerViewController!.view
        avPlayerView?.translatesAutoresizingMaskIntoConstraints = false
        let views = ["avPlayerView":avPlayerView, "takePictureButton":takePictureButton!]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[avPlayerView]|", options: .alignAllLeft, metrics: nil, views: views as [String : Any]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[avPlayerView]-0-[takePictureButton]", options: .alignAllLeft, metrics: nil, views: views as [String : Any]))
    }
    
    
    func pickMediaFromSource(_ sourceType: UIImagePickerController.SourceType){
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType)!
        if UIImagePickerController.isSourceTypeAvailable(sourceType) && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            present(picker, animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: "Error acessing media", message: "Unsupported media source.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        lastChosenMediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        
        if let mediaType = lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String {
                image = info [UIImagePickerController.InfoKey.editedImage] as? UIImage
            }else if mediaType == (kUTTypeMovie as NSString) as String {
                movieURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            }
        }
        saveImage(img: image!)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateDisPlay(){
        if let mediaType =  lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String{
                imageView.image = image!
                imageView.isHidden = false
                if avPlayerViewController != nil{
                    avPlayerViewController!.view.isHidden = true
                }
            }else if mediaType == (kUTTypeMovie as NSString) as String{
                if avPlayerViewController == nil{
                    avPlayerViewController  = AVPlayerViewController()
                    let avPlayerView = avPlayerViewController!.view
                    avPlayerView?.frame = imageView.frame
                    avPlayerView?.clipsToBounds = true
                    view.addSubview(avPlayerView!)
                    setAVPlayerViewLayoutConstraints()
                    
                }
                if let url = movieURL {
                    imageView.isHidden = true;
                    avPlayerViewController.player = AVPlayer(url:url)
                    avPlayerViewController!.view.isHidden = false
                    avPlayerViewController!.player!.play()
                }
            }
        }
    }
    
    //保存图片至沙盒
    func saveImage(img:UIImage){
        let home = NSHomeDirectory() as NSString
        //打印沙盒路径,可以前往文件夹看到你下载好的图片
        print(home)
        let docPath = home.appendingPathComponent("Documents") as NSString
        let filePath = docPath.appendingPathComponent("666.png")
        let url = URL(fileURLWithPath: filePath)
        do {
            try img.pngData()?.write(to: url, options: NSData.WritingOptions.atomic)
        }catch _{
        }
    }
    
    //从沙盒中读取图片
    func readWithFile() {
        let home = NSHomeDirectory() as NSString;
        let docPath = home.appendingPathComponent("Documents") as NSString;
        /// 获取文本文件路径
        let filePath = docPath.appendingPathComponent("666.png");
        let image = UIImage.init(contentsOfFile: filePath)
        if image == nil {
            imageView.image = UIImage(named: "owl-login.png")
        }else{
            imageView.image = image
        }
    }
}

