//
//  SlidingContainerSliderView.swift
//  SlidingContainerViewController
//

import UIKit

struct SlidingContainerSliderViewAppearance {
    
    var backgroundColor: UIColor
    
    var font: UIFont
    var selectedFont: UIFont
    
    var textColor: UIColor
    var selectedTextColor: UIColor
    
    var outerPadding: CGFloat
    var innerPadding: CGFloat
    
    var selectorColor: UIColor
    var selectorHeight: CGFloat
}

protocol SlidingContainerSliderViewDelegate {
    func slidingContainerSliderViewDidPressed (slidingtContainerSliderView: SlidingContainerSliderView, atIndex: Int)
}

class SlidingContainerSliderView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: Properties
    
    var appearance: SlidingContainerSliderViewAppearance! {
        didSet {
            draw()
        }
    }
    
    var shouldSlide: Bool = true
    
    let sliderHeight: CGFloat = 44
    var titles: [String]!
    
    var labels: [UILabel] = []
    var selector: UIView!
    
    var sliderDelegate: SlidingContainerSliderViewDelegate?
    
    // MARK: Init
    
    init (width: CGFloat, titles: [String]) {
        super.init(frame: CGRect (x: 0, y: 0, width: width, height: sliderHeight))
        self.titles = titles
        
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
        
        
        appearance = SlidingContainerSliderViewAppearance (
            backgroundColor: UIColor(white:1, alpha:0.3),
            
            font: UIFont (name: "HelveticaNeue-Light", size: 15)!,
            selectedFont: UIFont.boldSystemFontOfSize(15),
            
            textColor: UIColor.blackColor(),
            selectedTextColor: UIColor(red : 255/255,green: 255/255,blue: 255/255, alpha :1.0),
            
            outerPadding: 0,
            innerPadding: 10,
            
            selectorColor:UIColor(red : 80/255,green: 168/255,blue: 198/255, alpha :1.0),
            selectorHeight: 2)
        
        draw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Draw
    
    func draw () {
        
        // clean
        if labels.count > 0 {
            for label in labels {
                
                label.removeFromSuperview()
                
                if selector != nil {
                    selector.removeFromSuperview()
                    selector = nil
                }
            }
        }
        
        labels = []
        backgroundColor = appearance.backgroundColor
        
        var labelTag = 0
        var currentX:CGFloat = 0
        
        for title in titles {
        let label = labelWithTitle(title)
        label.frame.origin.x = currentX
        currentX = currentX + (screenSize.width/2)
        
        label.tag = labelTag++
        label.frame.size.width = screenSize.width/2
        label.frame.size.height = 44
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.frame.origin.y = 0
        addSubview(label)
        labels.append(label)
        
        }
        
        let selectorH = appearance.selectorHeight
        selector = UIView (frame: CGRect (x: 0, y: frame.size.height - selectorH, width: 100, height: selectorH))
        selector.backgroundColor = appearance.selectorColor
        addSubview(selector)
        
        contentSize = CGSize (width: currentX, height: frame.size.height)
    }
    
    func labelWithTitle (title: String) -> UILabel {
        
        let label = UILabel (frame: CGRect (x: 0, y: 0, width: 0, height: 0))
        label.text = title
        label.font = appearance.font
        label.textColor = appearance.textColor
        label.textAlignment = .Center
        label.frame.origin.y = 0
        label.addGestureRecognizer(UITapGestureRecognizer (target: self, action: "didTap:"))
        label.userInteractionEnabled = true
        
        return label
    }
    
    
    // MARK: Actions
    
    func didTap (tap: UITapGestureRecognizer) {
        self.sliderDelegate?.slidingContainerSliderViewDidPressed(self, atIndex: tap.view!.tag)
    }
    
    
    // MARK: Men
    func selectItemAtIndex (index: Int) {
        
        // Set Labels
        
        for i in 0..<self.labels.count {
            let label = labels[i]
            
            if i == index {
                
                label.textColor = appearance.selectorColor
                label.font = appearance.selectedFont
                label.textColor = appearance.selectedTextColor
                label.backgroundColor = UIColor(red : 122/255,green: 168/255,blue: 198/255, alpha :1.0)
                // Set selector
                UIView.animateWithDuration(0.3, animations: {
                    [unowned self] in
                    self.selector.frame = CGRect (
                        x: label.frame.origin.x,
                        y: self.selector.frame.origin.y,
                        width: label.frame.size.width,
                        height: self.appearance.selectorHeight)
                    })
                
            } else {
                
                label.textColor = appearance.textColor
                label.font = appearance.font
                label.textColor = appearance.textColor
                label.backgroundColor = UIColor(white:1, alpha:0.3)
            }
        }
    }
}

