//
//  Constant.swift
//  StretchyLayouts
//
//  Created by Lam on 11/29/18.
//  Copyright © 2018 Enabled. All rights reserved.
//

import UIKit

extension CGFloat {
    static let padding: CGFloat = 16.0
}

extension UIView {
    func setView(hidden: Bool, completionHandler: (() -> Void)? = nil) {
        if isHidden == hidden { return }
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {[weak self] in
            self?.isHidden = hidden
            }, completion: { _ in
                completionHandler?()
        })
    }
}
