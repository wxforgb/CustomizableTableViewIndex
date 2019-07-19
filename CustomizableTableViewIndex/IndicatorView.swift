//
//  IndicatorView.swift
//  CustomizableTableViewIndex
//
//  Created by 王 きん on 2019/07/19.
//

public class IndicatorView: UIView {
    
    private var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareCircleView()
        prepareLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareCircleView()
        prepareLabel()
    }
    
    public func configureLabel(by text: String) {
        guard let label = label else { return }
        label.text = text
    }
    
    private func prepareCircleView() {
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        circleView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        circleView.layer.cornerRadius = self.frame.width * 0.5
        self.addSubview(circleView)
        
    }
    
    private func prepareLabel() {
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(label!)
        
        label!.font = UIFont.boldSystemFont(ofSize: 32)
        label!.textColor = UIColor.white
        label!.textAlignment = .center
    }
    
    
    
}
