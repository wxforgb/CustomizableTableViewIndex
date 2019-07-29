//
//  CustomizableTableViewIndexController.swift
//  CustomizableTableViewIndex
//
//  Created by 王 きん on 2019/07/19.
//

import Foundation

public class CustomizableTableViewIndexController: NSObject {
    
    fileprivate var option: CustomizableTableViewIndexOption = CustomizableTableViewIndexOption()
    fileprivate let feedback = UIImpactFeedbackGenerator(style: .light)
    
    fileprivate weak var superView: UIView?
    fileprivate weak var tableView: UITableView?
    
    fileprivate var labels: [String] = []
    
    fileprivate var indexView: UIView?
    fileprivate var indicatorView: UIView?
    fileprivate var currentSection: Int = 0
    fileprivate var isPanning: Bool = false
    fileprivate var hideWaitingSecond: Int = 3
    fileprivate var countDownTimer: Timer?
    
    public func initialize(labels: [String], tableView: UITableView, superView: UIView? = nil, option: CustomizableTableViewIndexOption? = nil) {
        
        if let superView = superView {
            self.superView = superView
        } else {
            self.superView = tableView.superview
        }

        self.labels = labels
        self.tableView = tableView
        if let option = option {
            self.option = option
        }
        
        if self.option.enableScrollShow {
            self.countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(hideIfNecessary), userInfo: nil, repeats: true)
        }

        self.prepareIndexView()
        self.prepareIndexLabelView()
        self.prepareIndicatorView()
    }
    
    public func reconfigure(by labels: [String]) {
        self.labels = labels
        self.prepareIndexLabelView()
    }
    
    public func show(animated: Bool = true) {
        guard self.option.enableScrollShow else { return }
        guard let tableView = tableView else { return }
        guard let indexView = indexView else { return }
        guard indexView.isHidden else {
            self.hideWaitingSecond = 3
            return
        }
        indexView.isHidden = false
        indexView.frame.origin.x = tableView.frame.maxX
        if animated {
            UIView.animate(withDuration: 1, delay: 0.0, options: [.curveEaseIn], animations: {
                indexView.frame.origin.x = tableView.frame.maxX - self.option.indexViewWidth
            }) { _ in

            }
        } else {
            indexView.frame.origin.x -= self.option.indexViewWidth
        }
    }
    
    @objc func hideIfNecessary() {
        guard self.option.enableScrollShow else { return }
        guard !isPanning else { return }
        guard hideWaitingSecond > 0 else { return }
        hideWaitingSecond -= 1
        
        if hideWaitingSecond == 0 {
            guard let tableView = tableView else { return }
            guard let indexView = indexView else { return }
            UIView.animate(withDuration: 1, delay: 0.0, options: [.curveEaseIn], animations: {
                indexView.frame.origin.x += tableView.frame.maxX
            }) { _ in
                indexView.isHidden = true
            }
        }
    }

    
    fileprivate func prepareIndexView() {
        guard let superView = superView else { return }
        guard let tableView = tableView else { return }
        guard indexView == nil else { return }
        
        let tableViewFrame = tableView.frame
        let indexViewHeight = tableViewFrame.size.height - self.option.indexViewTopMargin - self.option.indexViewBottomMargin
        let indexViewWidth: CGFloat = self.option.indexViewWidth
        let indexViewX = tableViewFrame.maxX - self.option.indexViewWidth
        let indexViewY = tableViewFrame.minY
        
        // add indexView as a subview of view (not tableView)
        indexView = UIView(frame: CGRect(x: indexViewX, y: indexViewY, width: indexViewWidth, height: indexViewHeight))
        superView.addSubview(indexView!)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        gesture.delegate = self
        indexView!.addGestureRecognizer(gesture)
        
        indexView!.isHidden = self.option.enableScrollShow
    }
    
    fileprivate func prepareIndexLabelView() {
        guard let indexView = indexView else { return }
        indexView.subviews.forEach { $0.removeFromSuperview() }
        
        //calcuate label height
        let height = min(indexView.frame.height / CGFloat(self.labels.count), 28)
        let topMargin = (indexView.frame.height - height * CGFloat(labels.count)) / 2
        for index in 0..<labels.count {
            let label = UILabel(frame: CGRect(x: 0, y: CGFloat(index) * height + topMargin, width: self.option.indexViewWidth, height: height))
            label.isUserInteractionEnabled = true
            label.text = labels[index]
            label.font = self.option.font
            label.textColor = self.option.color
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
        let indicatorViewX = tableViewFrame.midX - self.option.indicatorSize *  0.5
        let indicatorViewY = tableViewFrame.midY - self.option.indicatorSize *  0.5
        let indicatorView = IndicatorView(frame: CGRect(x: indicatorViewX, y: indicatorViewY, width: self.option.indicatorSize, height: self.option.indicatorSize))
        indicatorView.prepare(by: self.option)
        indicatorView.isHidden = true
        self.indicatorView = indicatorView
        superView.addSubview(indicatorView)
        
    }
    
    @objc func panAction(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            isPanning = true
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
            isPanning = false
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
