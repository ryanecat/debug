//
//  DebugFileCell.swift
//  Test
//
//  Created by Ryan on 2019/12/25.
//  Copyright © 2019 Ryan. All rights reserved.
//

import UIKit

class DebugFileCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.lineBreakMode = .byTruncatingMiddle
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUrl(_ url: URL) {
        imageView?.image = UIImage.init(named: url.isDirectory ? "文件夹":"文件")
        textLabel?.text = url.lastPathComponent
        detailTextLabel?.text = "\(url.fileSize) Byte"
        accessoryType = url.isDirectory ? .disclosureIndicator : .none
    }
}
