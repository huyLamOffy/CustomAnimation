//
//  CustomTableCell.swift
//  StretchyLayouts
//
//  Created by Lam on 11/28/18.
//  Copyright © 2018 Enabled. All rights reserved.
//

import UIKit

struct CustomTableCellItem {
}

class CustomTableCell: UITableViewCell {
    lazy var imageViewCell = UIImageView()
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializationUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializationUI() {
        backgroundColor = .clear
        addSubview(imageViewCell)
        
        imageViewCell.image = UIImage(named: "Header")
        imageViewCell.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(CGFloat.padding)
            maker.left.right.equalToSuperview()
            maker.bottom.equalToSuperview().inset(CGFloat.padding)
            maker.height.equalTo(self.snp.width).multipliedBy(0.7)
        }
        imageViewCell.contentMode = .scaleToFill
        imageViewCell.clipsToBounds = true
    }
}
