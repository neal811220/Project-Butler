//
//  MJRefreshWrapper.swift
//  Project Butler
//
//  Created by Neal on 2020/3/4.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit
import MJRefresh

extension UITableView {
    
    func addRefreshHeader(refreshingBlock: @escaping () -> Void) {

        mj_header = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
    }
    
    func endHeaderRefreshing() {

        mj_header?.endRefreshing()
    }

    func beginHeaderRefreshing() {

        mj_header?.beginRefreshing()
    }
    
}
