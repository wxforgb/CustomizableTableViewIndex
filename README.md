# CustomizableTableViewIndex
A customizable replacement for UITableView section index, written by Swift

## Installation via CocoaPods
```
pod 'CustomizableTableViewIndex', '~> 0.0.5'
```

## Usage
```swift
  import CustomizableTableViewIndex

  fileprivate let customizableTableViewIndexController = CustomizableTableViewIndexController()

  self.customizableTableViewIndexController.initialize(labels: [], tableView: self.tableView, option: option)

  self.customizableTableViewIndexController.reconfigure(by: arrayTitles)
```

## Customize
```swift
public var enableScrollShow: Bool = true

public var indexViewWidth: CGFloat = 20.0
public var font: UIFont = UIFont.boldSystemFont(ofSize: 10)
public var color: UIColor = UIColor.blue

public var indicatorSize: CGFloat = 80
public var indicatorFont: UIFont = UIFont.boldSystemFont(ofSize: 32)
public var indicatorColor: UIColor = UIColor.white
public var indicatorBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)
```
