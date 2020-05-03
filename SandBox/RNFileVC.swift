//
//  RNFileVC.swift
//  Test
//
//  Created by Ryan on 2019/12/31.
//  Copyright © 2019 Ryan. All rights reserved.
//

import UIKit

class RNFileVC: UIViewController {
    enum Menu: String {
        case edit  = "编辑"
        case selAll  = "全选"
        case delete = "删除"
        case exitEdit = "退出编辑"
    }
    
    private var subURLs: [URL] = []
    
    var selAllItem: UIBarButtonItem!
    var deleteItem: UIBarButtonItem!
    var editItem: UIBarButtonItem!
    var tableView: UITableView!
    
    convenience init(_ url: URL) {
        self.init()
        navigationItem.title = url == kHomeURL ? "Home" : url.lastPathComponent
        subURLs = url.subURLs.sorted(by: { (url1, url2) -> Bool in
            url1.isDirectory
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}

extension RNFileVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigation()
        prepareTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension RNFileVC {
    func prepareNavigation() {
        editItem = UIBarButtonItem(title: Menu.edit.rawValue, style: .plain, target: self, action: #selector(editItemClick))
        selAllItem = UIBarButtonItem(title: Menu.selAll.rawValue, style: .plain, target: self, action: #selector(selAllItemClick))
        deleteItem = UIBarButtonItem(title: Menu.delete.rawValue, style: .plain, target: self, action: #selector(deleteItemClick))
        navigationItem.rightBarButtonItem = editItem
    }
    
    func prepareTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.rowHeight = 64
        tableView.register(RNFileCell.classForCoder(), forCellReuseIdentifier: "RNFileCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension RNFileVC {
    @objc
    func editItemClick() {
        let isEditing = !tableView.isEditing
        tableView.setEditing(isEditing, animated: true)
        editItem.title = isEditing ? Menu.exitEdit.rawValue : Menu.edit.rawValue
        navigationItem.leftBarButtonItems = isEditing ? [selAllItem, deleteItem] : nil
    }
    
    @objc
    func selAllItemClick() {
        for i in 0 ..< subURLs.count {
            let indexPath = IndexPath(row: i, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    @objc
    func deleteItemClick() {
        if !mDeleteRow() {
            RNToastUtil.showMsgAlert("删除失败")
        }
    }
}

extension RNFileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RNFileCell = tableView.dequeueReusableCell(withIdentifier: "RNFileCell") as! RNFileCell
        cell.setUrl(subURLs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selURL = subURLs[indexPath.row]
        guard selURL.isDirectory else {
            print("这不是文件夹, 所以没有下一级")
            return
        }
        navigationController?.pushViewController(RNFileVC(selURL), animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if !mDeleteRow([indexPath]) {
                RNToastUtil.showMsgAlert("删除失败")
            }
        }
    }
}

extension RNFileVC {
    private func mDeleteRow(_ indexPaths: [IndexPath]? = nil) -> Bool {
        if let selIndexPaths = indexPaths ?? tableView.indexPathsForSelectedRows {
            var selURLs: [URL] = []
            for i in selIndexPaths {
                selURLs.append(subURLs[i.row])
            }
            
            // Remove File
            if !RNFileUtil.removeItem(selURLs) {
                return false
            }
            
            // Reomve Data
            subURLs = subURLs.filter({
                !selURLs.contains($0)
            })
            
            // Update UI
            tableView.deleteRows(at: selIndexPaths, with: .automatic)
        }
        return true
    }
}
