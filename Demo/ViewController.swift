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
    private let rowData = [["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"], ["1", "2", "3"], ["4", "5", "6"]]
    private let sectionData = ["A", "B", "C", "D", "E", "F", "G", "H"]
    private let sectionData1 = ["A1", "B1", "C1", "D1", "E1", "F1", "G1", "H1"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "ValueCell", bundle: nil), forCellReuseIdentifier: valueCellIdentifier)
        
        self.customizableTableViewIndexController.initialize(labels: sectionData, tableView: self.tableView)
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
