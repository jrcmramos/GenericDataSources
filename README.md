# Generic Data Sources
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://opensource.org/licenses/MIT)
![platforms](https://img.shields.io/badge/platforms-iOS%20-lightgrey.svg)
![Carthage compatible](https://camo.githubusercontent.com/3dc8a44a2c3f7ccd5418008d1295aae48466c141/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f43617274686167652d636f6d70617469626c652d3442433531442e7376673f7374796c653d666c6174)

Implementation of generic data sources for both collection and table views.  
This solution was based on the existing Florian Kugler's [approach](https://github.com/objcio/S01E26-generic-table-view-controllers-part-2)

## Purpose
Implementing a data source generaly requires repetitive and boilerplate code.  
This solution proposes a different approach to simplify the definition of your static collection's content.

### Approach
Definition of the view models for sections and rows and definition of the cell type for each kind.

## Example
#### Note 
The cell identifier can dependent on the cell type or can be improved with some other approach. I decided to not include it here because we are not performing cell registration and it depends on that.

```

struct SectionViewModel: Section {
    
    enum RowType {
        case rowType1(viewModel: Type1TableViewCellModel)
        case rowType2(viewModel: Type2TableViewCellModel)
        case rowType3(viewModel: Type3TableViewCellModel)
    }
    
    var rows: [RowType]
}

struct FirstSectionViewModel {
	
	static func make() -> SectionViewModel {
		let rows = [SectionViewModel.RowType.rowType1(viewModel: Type1TableViewCellModel()),
		            SectionViewModel.RowType.rowType2(viewModel: Type2TableViewCellModel())]
		return SectionViewModel(rows: rows)
	}
	
	private init() {}
}


final class ViewController: UIViewController {
    
	private var dataSource: GenericTableViewDataSource<SectionViewModel>!
	
	(...)
	
	
	private func configureTableView() {
        // Cells registration code
        (...)
        
        // Create cells descriptor
        let cellDescriptor: (SectionViewModel.RowType) -> TableCellDescriptor = { rowType in
            switch rowType {
            case .rowType1(let viewModel):
                return TableCellDescriptor(cellIdentifier: String(describing: Type1TableViewCell.self)) { (cell: Type1TableViewCell) -> Void in
                    cell.configure(with: viewModel) // cell based implementation
                }
            case .rowType2(let viewModel):
                return TableCellDescriptor(cellIdentifier: String(describing: Type2TableViewCell.self)) { (cell: Type2TableViewCell) -> Void in
                    cell.configure(with: viewModel) // cell based implementation
                }
            case .rowType3(let viewModel):
                return TableCellDescriptor(cellIdentifier: String(describing: Type3TableViewCell.self)) { (cell: Type3TableViewCell) -> Void in
                    cell.configure(with: viewModel) // cell based implementation
                }
            }
        }
        
        self.dataSource = GenericTableViewDataSource(items: [FirstSectionViewModel.make()], cellDescriptor: cellDescriptor)
        self.tableView.dataSource = self.dataSource
	}
}
```