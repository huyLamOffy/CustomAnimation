//
//  ViewController.swift
//  StretchyLayouts
//
//  Created by Lam on 11/28/18.
//  Copyright © 2018 Enabled. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1235740449, blue: 0.2699040081, alpha: 1)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
    }
}

// MARK: - Tableview methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
        let vc = StretchyViewController()
        vc.animationTransition.indexPath = indexPath
        vc.animationTransition.tableCellFrame = rectOfCellInSuperview
        present(vc, animated: true, completion: nil)
        return nil
    }
}
