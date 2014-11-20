//
//  PageIndexIndicator.swift
//  MenuSlider
//
//  Created by Dennis Fedorko on 11/16/14.
//  Copyright (c) 2014 Dennis F. All rights reserved.
//

import UIKit

class PageIndexIndicator: UIView {
    
    //Constants to change
    let sections = ["Info","Menu","Photos"]
    let menuBackgroundColor = UIColor.whiteColor()
    let menuButtonColorNormal = UIColor.grayColor()
    let menuButtonColorSelected = UIColor.redColor()
    let indicatorColor = UIColor.redColor()
    
    
    var spacing: CGFloat = 20
    var buttons:NSMutableArray = []
    var initialized = false
    var currentIndex = 0
    
    
    // MARK: -Initialize
    
    lazy var indicatior:UIImageView = {
        let x = self.spacing as CGFloat
        let y = self.frame.size.height * 0.85 as CGFloat
        let width = (self.frame.size.width - (CGFloat(2 * self.sections.count) * self.spacing))/CGFloat(self.sections.count)
        let height = self.frame.size.height * 0.15
        var imageView = UIImageView(frame: CGRectMake(x, y, width, height))
        imageView.backgroundColor = self.indicatorColor
        return imageView
        
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        
    }
    
    
    init(frame: CGRect, numberOfSections sections: Int, spacing space: Int) {
        super.init(frame: frame)
        self.spacing = CGFloat(space)
        self.backgroundColor = UIColor.blueColor()
        self.addSubview(self.indicatior)
        
    }
    
    override func layoutSubviews() {
        if(!initialized)
        {
            self.backgroundColor = self.menuBackgroundColor
            self.addButtonsToView()
            self.addSubview(self.indicatior)
            self.initialized = true
            
        }
    }
    
    // MARK: -Handle User Input

    
    func addButtonsToView(){
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        let buttonWidth = self.frame.size.width/CGFloat(self.sections.count)
        let buttonHeight = self.frame.size.height
        for section in sections
        {
            var button = UIButton(frame: CGRectMake(x, y, buttonWidth, buttonHeight))
            button.setTitle(section, forState: UIControlState.Normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.textAlignment = NSTextAlignment.Center
            button.titleLabel?.font = UIFont.systemFontOfSize(16)
            if self.buttons.count == 0
            {
                button.setTitleColor(self.menuButtonColorSelected, forState: UIControlState.Normal)

            }else{
                button.setTitleColor(self.menuButtonColorNormal, forState: UIControlState.Normal)
            }
            button.addTarget(self, action: "indicatorButtonWasTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            self.buttons.addObject(button)
            
            
            self.addSubview(button)
            x += buttonWidth
        }
        
        
    }
    
    func indicatorButtonWasTapped(sender: UIButton)
    {
        let index = self.buttons.indexOfObject(sender)
        self.didScrollToIndex(anIndex: index, animationDuration: 0.2)
        NSNotificationCenter.defaultCenter().postNotificationName("PageWasSwitched", object: self.currentIndex)
        
    }
    
   
    func didScrollToIndex(anIndex index: Int, animationDuration duration:Double){
        var indicatorFrame = self.indicatior.frame
        indicatorFrame.origin.x = (indicatorFrame.size.width * CGFloat(index)) + (CGFloat(index) * self.spacing * 2) + self.spacing
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(NSTimeInterval.abs(duration))
        self.indicatior.frame = indicatorFrame
        UIView.commitAnimations()
        for button in self.buttons
        {
            if (self.buttons.indexOfObject(button) == index){
                button.setTitleColor(self.menuButtonColorSelected, forState: UIControlState.Normal)
            }
            else{
                button.setTitleColor(self.menuButtonColorNormal, forState: UIControlState.Normal)
            }
        }
        self.currentIndex = index
    }
    

}
