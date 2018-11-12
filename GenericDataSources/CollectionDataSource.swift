//
//  CollectionDataSource.swift
//  GenericDataSources
//
//  Created by José Ramos on 08/11/2017.
//  Copyright © 2017 José Ramos. All rights reserved.
//

import UIKit

public protocol Section {
    associatedtype Row
    var rows: [Row] { get }
}

public struct CollectionCellDescriptor {
    fileprivate let cellIdentifier: String
    let configure: (UICollectionViewCell) -> ()
    
    public init<T: UICollectionViewCell>(configure: @escaping (T) -> Void) {
        self.cellIdentifier = String(describing: T.self)
        self.configure = {
            configure($0 as! T)
        }
    }
}

public protocol CollectionViewRearrangeItemsDelegate: class {
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

public final class GenericCollectionViewDataSource<SectionType: Section>: NSObject, UICollectionViewDataSource {
    public var sections: [SectionType]
    let cellDescriptor: (SectionType.Row) -> CollectionCellDescriptor
    
    public weak var rearrangeItemsDelegate: CollectionViewRearrangeItemsDelegate?
    
    public init(items: [SectionType], cellDescriptor: @escaping (SectionType.Row) -> CollectionCellDescriptor) {
        self.sections = items
        self.cellDescriptor = cellDescriptor
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellDescriptor = self.cellDescriptor(self.sections[indexPath.section].rows[indexPath.row])
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDescriptor.cellIdentifier, for: indexPath)
        cellDescriptor.configure(cell)
        
        return cell
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return self.rearrangeItemsDelegate != nil
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.rearrangeItemsDelegate?.collectionView(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }
}

public struct TableCellDescriptor {
    fileprivate let cellIdentifier: String
    let configure: (UITableViewCell) -> ()
    
    public init<T: UITableViewCell>(cellIdentifier: String, configure: @escaping (T) -> Void) {
        self.cellIdentifier = String(describing: T.self)
        self.configure = {
            configure($0 as! T)
        }
    }
}

public final class GenericTableViewDataSource<SectionType: Section>: NSObject, UITableViewDataSource {
    public var sections: [SectionType]
    let cellDescriptor: (SectionType.Row) -> TableCellDescriptor
    
    public init(items: [SectionType], cellDescriptor: @escaping (SectionType.Row) -> TableCellDescriptor) {
        self.sections = items
        self.cellDescriptor = cellDescriptor
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDescriptor = self.cellDescriptor(self.sections[indexPath.section].rows[indexPath.row])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptor.cellIdentifier, for: indexPath)
        cellDescriptor.configure(cell)
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
}
