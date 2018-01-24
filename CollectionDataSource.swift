//
//  CollectionDataSource.swift
//  GenericDataSources
//
//  Created by José Ramos on 08/11/2017.
//  Copyright © 2017 José Ramos. All rights reserved.
//

import UIKit

protocol Section {
    associatedtype Row
    var rows: [Row] { get }
}

struct CollectionCellDescriptor {
    let cellClass: UICollectionViewCell.Type
    let configure: (UICollectionViewCell) -> ()
    
    fileprivate let cellIdentifier: String
    
    init<T: UICollectionViewCell>(cellIdentifier: String, configure: @escaping (T) -> Void) {
        self.cellClass = T.self
        self.configure = {
            configure($0 as! T)
        }
        
        self.cellIdentifier = cellIdentifier
    }
}

protocol CollectionViewRearrangeItemsDelegate: class {
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

final class GenericCollectionViewDataSource<SectionType: Section>: NSObject, UICollectionViewDataSource {

    var sections: [SectionType]
    let cellDescriptor: (SectionType.Row) -> CollectionCellDescriptor
    
    weak var rearrangeItemsDelegate: CollectionViewRearrangeItemsDelegate?
    
    init(items: [SectionType], cellDescriptor: @escaping (SectionType.Row) -> CollectionCellDescriptor) {
        self.sections = items
        self.cellDescriptor = cellDescriptor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellDescriptor = self.cellDescriptor(self.sections[indexPath.section].rows[indexPath.row])
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDescriptor.cellIdentifier, for: indexPath)
        cellDescriptor.configure(cell)
        
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return self.rearrangeItemsDelegate != nil
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.rearrangeItemsDelegate?.collectionView(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }
}

struct TableCellDescriptor {
    let cellClass: UITableViewCell.Type
    let configure: (UITableViewCell) -> ()
    
    fileprivate let cellIdentifier: String
    
    init<T: UITableViewCell>(cellIdentifier: String, configure: @escaping (T) -> Void) {
        self.cellClass = T.self
        self.configure = {
            configure($0 as! T)
        }
        self.cellIdentifier = cellIdentifier
    }
}

final class GenericTableViewDataSource<SectionType: Section>: NSObject, UITableViewDataSource {
    
    var sections: [SectionType]
    let cellDescriptor: (SectionType.Row) -> TableCellDescriptor
    
    init(items: [SectionType], cellDescriptor: @escaping (SectionType.Row) -> TableCellDescriptor) {
        self.sections = items
        self.cellDescriptor = cellDescriptor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDescriptor = self.cellDescriptor(self.sections[indexPath.section].rows[indexPath.row])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptor.cellIdentifier, for: indexPath)
        cellDescriptor.configure(cell)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
}
