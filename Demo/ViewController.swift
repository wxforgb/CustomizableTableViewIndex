//
//  ViewController.swift
//  Demo
//
//  Created by 王 きん on 2019/07/17.
//

import UIKit
import CustomizableTableViewIndex

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - private variables
    private let customizableTableViewIndexController = CustomizableTableViewIndexController()
    private let valueCellIdentifier = "ValueCell"
    private let rowData = [["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"]]
    private let sectionData = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.blue
        self.tableView.register(UINib(nibName: "ValueCell", bundle: nil), forCellReuseIdentifier: valueCellIdentifier)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var option = CustomizableTableViewIndexOption()
        option.enableScrollShow = false
        option.indexViewTopMargin = 0
        option.indexViewBottomMargin = 0
        self.customizableTableViewIndexController.initialize(labels: sectionData, tableView: self.tableView, option: option)
    }

    func getDeviceSAFE() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if let insets = UIApplication.shared.keyWindow?.safeAreaInsets {
                return insets
            }
        }
        return UIEdgeInsets.zero
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: valueCellIdentifier, for: indexPath) as! ValueCell
        cell.configure(by: self.rowData[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionData[section]
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.customizableTableViewIndexController.reconfigure(by: sectionData.map { "\($0)\(indexPath.row)"} )
    }
    
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDragging")
//        self.customizableTableViewIndexController.show()
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.customizableTableViewIndexController.show()
    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
//        self.customizableTableViewIndexController.hide()
//    }
}
