//
//  CustomizableTableViewIndexController.swift
//  CustomizableTableViewIndex
//
//  Created by 王 きん on 2019/07/19.
//

import Foundation

public class CustomizableTableViewIndexController: NSObject {
    
    fileprivate var optionWidth: CGFloat = 20.0
    fileprivate var optionFont: UIFont = UIFont.boldSystemFont(ofSize: 10)
    fileprivate var optionColor: UIColor = UIColor.blue
    
    fileprivate var optionIndicatorViewSize: CGFloat = 80
    
    fileprivate var labels: [String] = []
    fileprivate weak var superView: UIView?
    fileprivate weak var tableView: UITableView?
    
    fileprivate var indexView: UIView?
    fileprivate var indicatorView: UIView?
    fileprivate var currentSection: Int = 0
    
    fileprivate let feedback = UIImpactFeedbackGenerator(style: .light)
    
    public func initialize(labels: [String], superView: UIView, tableView: UITableView) {

        self.labels = labels
        self.superView = superView
        self.tableView = tableView
        
        self.prepareIndexView()
        self.prepareIndexLabelView()
        self.prepareIndicatorView()
    }
    
    fileprivate func saveInput() {

    }
    
    fileprivate func prepareIndexView() {
        guard let superView = superView else { return }
        guard let tableView = tableView else { return }
        guard indexView == nil else { return }
        
        let tableViewFrame = tableView.frame
        let indexViewHeight = tableViewFrame.size.height
        let indexViewWidth: CGFloat = optionWidth
        let indexViewX = tableViewFrame.maxX - optionWidth
        let indexViewY = tableViewFrame.minY
        
        // add indexView as a subview of view (not tableView)
        indexView = UIView(frame: CGRect(x: indexViewX, y: indexViewY, width: indexViewWidth, height: indexViewHeight))
        superView.addSubview(indexView!)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        gesture.delegate = self
        indexView!.addGestureRecognizer(gesture)
        
    }
    
    fileprivate func prepareIndexLabelView() {
        guard let indexView = indexView else { return }
        
        //calcuate label height
        let height = min(indexView.frame.height / CGFloat(self.labels.count), 28)
        let topMargin = (indexView.frame.height - height * CGFloat(labels.count)) / 2
        for index in 0..<labels.count {
            let label = UILabel(frame: CGRect(x: 0, y: CGFloat(index) * height + topMargin, width: optionWidth, height: height))
            label.isUserInteractionEnabled = true
            label.text = labels[index]
            label.font = optionFont
            label.textColor = optionColor
            label.textAlignment = .center
            label.tag = index
            indexView.addSubview(label)
        }
    }
    
    fileprivate func prepareIndicatorView() {
        guard let superView = superView else { return }
        guard let tableView = tableView else { return }
        guard indicatorView == nil else { return }
        
        let tableViewFrame = tableView.frame
        let indicatorViewX = tableViewFrame.midX - optionIndicatorViewSize *  0.5
        let indicatorViewY = tableViewFrame.midY - optionIndicatorViewSize *  0.5
        indicatorView = IndicatorView(frame: CGRect(x: indicatorViewX, y: indicatorViewY, width: optionIndicatorViewSize, height: optionIndicatorViewSize))
        indicatorView?.isHidden = true
        superView.addSubview(indicatorView!)
        
    }
    
    @objc func panAction(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            let view = gesture.view
            let loc = gesture.location(in: view)
            guard let currentLabel = view?.hitTest(loc, with: nil) else { return }
            
            if let indicatorView = indicatorView as? IndicatorView {
                indicatorView.configureLabel(by: self.labels[currentLabel.tag])
                indicatorView.isHidden = false
            }
            
        } else if gesture.state == UIGestureRecognizer.State.changed {
            let view = gesture.view
            let loc = gesture.location(in: view)
            guard let currentLabel = view?.hitTest(loc, with: nil) else { return }
            
            scrollToCurrentLabel(section: currentLabel.tag)
            if let indicatorView = indicatorView as? IndicatorView {
                indicatorView.configureLabel(by: self.labels[currentLabel.tag])
            }
        } else {
            self.indicatorView?.isHidden = true
        }
    }
    
    fileprivate func scrollToCurrentLabel(section: Int) {
        guard currentSection != section else { return }
        self.feedback.impactOccurred()
        self.currentSection = section
        self.tableView?.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: false)
    }
    
}

extension CustomizableTableViewIndexController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            return true
        }
        
        return false
    }
}
