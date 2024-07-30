//
//  TableViewExtension.swift
//  synex
//
//  Created by Ritesh chopra on 05/09/23.
//

import Foundation
import UIKit


extension UICollectionView {
    func registerColletionCell(identifier:String)  {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
}

extension UITableView {
    func registerTableCell(identifier:String)  {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
  
}
