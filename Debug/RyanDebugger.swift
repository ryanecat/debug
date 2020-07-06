//
//  RyanDebugger.swift
//  FX
//
//  Created by ryan on 2020/7/6.
//  Copyright © 2020 Tony. All rights reserved.
//

import UIKit

class RyanDebugger {
    //开启装逼模式
    public static func open() {
        if let window = KEY_WINDOW {
            let openBtn: UIButton = {
                let btn = UIButton(frame: .init(x: 15, y: 88, width: 120, height: 60))
                btn.backgroundColor = .orange
                btn.setTitle("震惊", for: .normal)
                btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
                return btn
            }()
            window.addSubview(openBtn)
        }
    }
}

extension RyanDebugger {
    @objc
    private func btnClick() {
        let nav = UINavigationController(rootViewController: RyanDebuggerVC())
        UIViewController.current()?.present(nav, animated: true, completion: nil)
    }
}

private extension UIViewController {
    class func current(base: UIViewController? = (UIApplication.shared.keyWindow?.rootViewController ?? UIApplication.shared.windows.first?.rootViewController)) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }
}

private var KEY_WINDOW: UIWindow? = {
    var window: UIWindow? = nil
    if #available(iOS 13.0, *) {
        for windowScene in (UIApplication.shared.connectedScenes as! Set<UIWindowScene>) {
            if windowScene.activationState == .foregroundActive {
                window = windowScene.windows.first
                break
            }
        }
        return window
    } else {
        return UIApplication.shared.keyWindow
    }
}()
