[![Build Status](https://travis-ci.org/lightsprint09/Sourcing.svg?branch=master)](https://travis-ci.org/lightsprint09/Sourcing)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov](https://codecov.io/gh/lightsprint09/Sourcing/branch/master/graph/badge.svg)](https://codecov.io/gh/lightsprint09/Sourcing)

# Sourcing

Typesafe and flexible abstraction for TableView &amp; CollectionView DataSources written in Swift. It helps you to seperate conecerns ans keep ViewControllers light. By operating on data providers it is easy to replace you view implementation.

## Documentation

Read the [docs](https://lightsprint09.github.io/Sourcing/). Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).


## Quick Demo
Setting up your Cell by implementing `ConfigurableCell` & `CellIdentifierProviding`.
```swift
import Sourcing

class TrainCell: UITableViewCell, ConfigurableCell {
   @IBOutlet var nameLabel: UILabel!
   
   func configure(with train: Train) {
      nameLabel.text = train.name
   }
}

//If your reuse identifier is the same a the class name
extension TrainCell: CellIdentifierProviding {}

let trainCell = CellConfiguration<TrainCell>()
let trains: [Train] = //
let dataProvider = ArrayDataProvider(rows: trains)
let dataSource = TableViewDataSource(dataProvider: dataProvider, cell: trainCell)

tableView.dataSource = dataSource

//For Updates
let changeAnimator = TableViewChangeAnimator(tableView: tableView, dataProviderObservable: dataProvider.observable)
```

## Requirements

- iOS 9.3+
- Xcode 8.0+
- Swift 3.0

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

Specify the following in your `Cartfile`:

```ogdl
github "lightsprint09/sourcing" ~> 3.0
```
## Contributing
See CONTRIBUTING for details.

## Contact
Lukas Schmidt ([Mail](mailto:lukas.la.schmidt@deutschebahn.com), [@lightsprint09](https://twitter.com/lightsprint09))

## License
Sourcing is released under the MIT license. See LICENSE for details.
