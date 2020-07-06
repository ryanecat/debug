//
//  RyanDebuggerVC.swift
//  FX
//
//  Created by ryan on 2020/7/6.
//  Copyright © 2020 Tony. All rights reserved.
//

import UIKit

class RyanDebuggerVC: UITableViewController {
    let titles = ["查看某个VC","后面再说"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RyanDebuggerVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "debugCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "debugCell")
        }
        cell?.textLabel?.text = titles[indexPath.row]
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("猴赛雷")
    }
}
