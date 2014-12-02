//
//  DetailViewController.swift
//  MenuSlider
//
//  Created by Dennis Fedorko on 11/16/14.
//  Copyright (c) 2014 Dennis F. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{

    let pageIndexIndicator = PageIndexIndicator()
    let backgroundImageView = UIImageView()
    let contentPagingView = UIView()
    let portraitPhotoImageView = UIImageView()
    
    var detailPages:NSMutableArray = []
    let pageVC = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options:  nil)
    var currentIndex = 0
    
    ////////////////////////////////////
    ///////VIEW RATIO CONSTANTS/////////////////////
    
    //weight by percentage of height
    let BACKGROUND_IMAGE_VIEW_HEIGHT:CGFloat = 0.4
    let CONTENT_PAGING_VIEW_HEIGHT:CGFloat = 0.6
    let PORTRAIT_IMAGE_SIZE:CGFloat = 0.15
    let PAGE_INDICATOR_HEIGHT:CGFloat = 0.05
    
    //weight by percentage of width
    let PAGE_INDICATOR_WIDTH:CGFloat = 0.6
    
    ///////VIEW RATIO CONSTANTS/////////////////////
    ///////////////////////////////////
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        setUpViews()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pageWasSwitched:", name: "PageWasSwitched", object: nil)
        
        pageVC.view.frame = CGRectMake(0, 0, self.contentPagingView.frame.width, self.contentPagingView.frame.height)
        
        self.contentPagingView.addSubview(pageVC.view)
        
        setUpPages()
        
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.setViewControllers([self.detailPages.objectAtIndex(0)], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        addChildViewController(pageVC)
        pageVC.didMoveToParentViewController(self)
        
    }
    
    func setUpViews(){
        
        let viewHeight:CGFloat = self.view.frame.size.height
        let viewWidth:CGFloat = self.view.frame.size.width
        
        //background image view
        self.backgroundImageView.frame = CGRectMake(0, 0, viewWidth, BACKGROUND_IMAGE_VIEW_HEIGHT * viewHeight)
        self.backgroundImageView.backgroundColor = UIColor.redColor()
        self.backgroundImageView.userInteractionEnabled = true
        
        //content view
        self.contentPagingView.frame = CGRectMake(0, self.backgroundImageView.frame.size.height, viewWidth,CONTENT_PAGING_VIEW_HEIGHT * viewHeight)
        
        //dining image portrait view
        self.portraitPhotoImageView.frame = CGRectMake(0, 0, PORTRAIT_IMAGE_SIZE * viewHeight, PORTRAIT_IMAGE_SIZE * viewHeight)
        self.portraitPhotoImageView.center = backgroundImageView.center
        self.portraitPhotoImageView.backgroundColor = UIColor.blueColor()
        
        //detail pages container view
        self.pageIndexIndicator.frame = CGRectMake(0, 0, PAGE_INDICATOR_WIDTH * viewWidth, PAGE_INDICATOR_HEIGHT * viewHeight)
        self.pageIndexIndicator.center = CGPointMake(self.backgroundImageView.center.x, self.backgroundImageView.frame.size.height - self.pageIndexIndicator.frame.size.height/2.0)
        self.pageIndexIndicator.userInteractionEnabled = true
        
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(contentPagingView)
        self.backgroundImageView.addSubview(portraitPhotoImageView)
        self.backgroundImageView.addSubview(pageIndexIndicator)
        
    }
    
    func setUpPages(){
        
        let locationVC = DiningLocationDetailViewController()
        locationVC.view.frame = pageVC.view.frame
        
        let menuVC = DiningMenuDetailViewController()
        menuVC.view.frame = pageVC.view.frame
        
        
        detailPages.addObject(locationVC)
        detailPages.addObject(menuVC)
        
        
    }
    // MARK: - User Input Handling
    
    func pageWasSwitched(notification:NSNotification)
    {
        var index:Int = notification.object as Int
        var direction =  UIPageViewControllerNavigationDirection.Reverse
        if (index > self.currentIndex) {
            direction = UIPageViewControllerNavigationDirection.Forward
        }
        self.pageVC.setViewControllers([self.detailPages.objectAtIndex(index)], direction:direction, animated: true, completion: nil)
        self.currentIndex = index
        
    }
    
    
    // MARK: - Page Navigation
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let index =  self.detailPages.indexOfObject(viewController)
        
        if (index >= self.detailPages.count - 1) {
            // we're at the end of the _pages array
            return nil
        }
        // return the next page's view controller
        return (self.detailPages.objectAtIndex(index + 1) as UIViewController)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
       
        let index =  self.detailPages.indexOfObject(viewController)
        
        if (index <= 0) {
            // we're at the end of the _pages array
            return nil
        }
        // return the previous page's view controller
        return (self.detailPages.objectAtIndex(index - 1) as UIViewController)

    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        
        let newController = pendingViewControllers.first as UIViewController
        let index = self.detailPages.indexOfObject(newController)
        
        self.pageIndexIndicator.didScrollToIndex(anIndex: index, animationDuration: 0.2)
        self.currentIndex = index

        
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        if(!completed)
        {
            let newController = previousViewControllers.first as UIViewController
            let index = self.detailPages.indexOfObject(newController)
            
            self.pageIndexIndicator.didScrollToIndex(anIndex: index, animationDuration: 0.01)
            self.currentIndex = index

        }
        
    }
   /*
    - (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    SJJeanViewController* controller = [pendingViewControllers firstObject];
    self.nextIndex = [self indexOfViewController:controller];
    
    }
    
    - (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if(completed){
    
    self.currentIndex = self.nextIndex;
    
    }
    
    self.nextIndex = 0;
    
    }*/
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
