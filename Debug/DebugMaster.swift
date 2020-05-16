//
//  DebugMaster.swift
//  Archiver
//
//  Created by ryan on 2020/5/4.
//  Copyright © 2020 RyanZee. All rights reserved.
//

import UIKit

class DebugMaster {
    public static func addButtons() {
        if let view = UIViewController.current()?.view {
            view.addSubview(UIButton("查看沙盒文件", frame: .init(x: 15, y: 88, width: 160, height: 64)) {
                let nav = UINavigationController(rootViewController: DebugFileVC(kHomeURL))
                UIViewController.current()?.present(nav, animated: true, completion: nil)
            })
            view.addSubview(UIButton("验证收据(本地)", frame: .init(x: 15, y: 88+10+64, width: 160, height: 64)) {
                let success = PurchaseManager.shared.verifyReceiptLocally(kUnlockProductID, type: .nonConsumable)
                RNToastUtil.showMsgAlert(success ? "成功!":"失败!")
            })
            view.addSubview(UIButton("验证收据(联网)", frame: .init(x: 15, y: 88+10+64+10+64, width: 160, height: 64)) {
                PurchaseManager.shared.verifyReceiptOnline(kUnlockProductID, sharedSecret: kSharedSecret) { (success) in
                    RNToastUtil.showMsgAlert(success ? "成功!":"失败!")
                }
            })
            
        }
    }
}


private extension UIButton {
    typealias buttonClick = () -> ()
    // 改进写法【推荐】
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
        /// ...其他Key声明
    }
    /// 运行时关联
    private var actionBlock: buttonClick? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UIButton.RuntimeKey.actionBlock!) as? buttonClick
        }
    }
     /// 点击回调
    @objc
    func tapped(button:UIButton){
        if self.actionBlock != nil {
            self.actionBlock!()
        }
    }
    
    /// 快速创建
    convenience init(_ title: String, frame: CGRect, action: @escaping buttonClick) {
        self.init()
        self.frame = frame
        backgroundColor = .orange
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addTarget(self, action: #selector(tapped(button:)), for: .touchUpInside)
        actionBlock = action
        layer.cornerRadius = 10
    }
 
}
