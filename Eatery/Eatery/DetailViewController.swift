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

    @IBOutlet var pageIndexIndicator: PageIndexIndicator!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var contentPagingView: UIView!
    @IBOutlet var portraitPhotoImageView: UIImageView!
    
    var detailPages:NSMutableArray = []
    let pageVC = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options:  nil)
    var currentIndex = 0
    
    ////////////////////////////////////
    ///////TEST DATA/////////////////////
    let location: CLLocation = CLLocation(latitude: 50, longitude: 50)
    let name:String = "Appel Commons"
    let summary: String = "A great place to eat for freshmen"
    let paymentMethods: [String] = ["Cash","Swipe","BRB"]
    let hours: [String] = ["7:30am-10:00pm"]
    let id: String = "APPELID"
    ///////TEST DATA/////////////////////
    ///////////////////////////////////
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
    
    func setUpPages(){
        
        let locationVC = LocationInfoTableViewController(nibName: "LocationInfoTableViewController", bundle: nil)
        locationVC.view.frame = pageVC.view.frame
        
        let menuVC = MenuInfoTableViewController(nibName: "MenuInfoTableViewController", bundle: nil)
        menuVC.view.frame = pageVC.view.frame
        
        let photoVC = DiningPhotosViewController(nibName: "DiningPhotosViewController", bundle: nil)
        photoVC.view.frame = pageVC.view.frame
        
        detailPages.addObject(locationVC)
        detailPages.addObject(menuVC)
        detailPages.addObject(photoVC)
        
        
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
