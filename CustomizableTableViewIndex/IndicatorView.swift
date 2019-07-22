//
//  IndicatorView.swift
//  CustomizableTableViewIndex
//
//  Created by 王 きん on 2019/07/19.
//

public class IndicatorView: UIView {
    
    private var option: CustomizableTableViewIndexOption = CustomizableTableViewIndexOption()
    private var label: UILabel?
    
    public func prepare(by option: CustomizableTableViewIndexOption? = nil) {
        if let option = option {
            self.option = option
        }
        
        prepareCircleView()
        prepareLabel()
    }
    
    public func configureLabel(by text: String) {
        guard let label = label else { return }
        label.text = text
    }
    
    private func prepareCircleView() {
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        circleView.backgroundColor = option.indicatorBackgroundColor
        circleView.layer.cornerRadius = self.frame.width * 0.5
        self.addSubview(circleView)
        
    }
    
    private func prepareLabel() {
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(label!)
        
        label!.font = option.indicatorFont
        label!.textColor = option.indicatorColor
        label!.textAlignment = .center
    }
    
    
    
}
