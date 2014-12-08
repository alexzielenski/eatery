//
//  DiningLocationDetailViewController.swift
//  MenuSlider
//
//  Created by Dennis Fedorko on 12/1/14.
//  Copyright (c) 2014 Dennis F. All rights reserved.
//

import UIKit
import MapKit

class DiningLocationDetailViewController: UIViewController {

    ////////////////////////////////
    ///VIEW RATIO CONSTANTS/////////
    //weight by percentage of height
    let HOURS_LABEL_HEIGHT:CGFloat = 0.1
    let LOCATION_LABEL_HEIGHT:CGFloat = 0.1
    let DINING_HOURS_VIEW_HEIGHT:CGFloat = 0.3
    let MAP_VIEW_HEIGHT:CGFloat = 0.3
    let DINING_NAME_LABEL_HEIGHT:CGFloat = 0.1
    let PAYMENT_VIEW_HEIGHT:CGFloat = 0.1
    let HOURS_ICON_SIZE:CGFloat = 0.1
    let LOCATION_TIMES_VIEW_HEIGHT:CGFloat = 0.3
    
    //weight by percentage of width
    
    let DINING_HOURS_TEXT_VIEW_WIDTH:CGFloat = 0.9
    let PAYMENT_IMAGE_WIDTH:CGFloat = 0.1
    let PAYMENT_IMAGE_HEIGHT:CGFloat = 0.2
    let PAYMENT_TEXT_WIDTH:CGFloat = 0.4
    let PAYMENT_ICON_CUSHION_SPACE:CGFloat = 0.02
    ////////////////////////////////
    ///////////////////////////////
    
    //VIEWS///////
    let hoursLabel = UILabel()
    let locationLabel = UILabel()
    let hoursIcon = UIImageView()
    let hoursTextView = UITextView()
    let hoursView = UIView()
    let mapView = MKMapView()
    let diningNameLabel = UILabel()
    let paymentView = UIView()
    let paymentLabel = UILabel()
    let paymentIcon1 = UIImageView()
    let paymentIcon2 = UIImageView()
    let paymentIcon3 = UIImageView()
    let paymentIcon4 = UIImageView()
    let paymentIcon5 = UIImageView()
    //////////////
    
    //Colors////////////
    let backgroundColor = UIColor.lightGrayColor()
    let hoursViewColor = UIColor.whiteColor()
    let diningNameLabelColor = UIColor.whiteColor()
    ///////////////////
    
    var diningHall:DiningHall!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.backgroundColor
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUpViews()
        populateViews()
        
    }
    
    func setUpViews()
    {
        let viewHeight:CGFloat = self.view.frame.size.height
        let viewWidth:CGFloat = self.view.frame.size.width
        
        //hours label
        self.hoursLabel.frame = CGRectMake(0, 0, viewWidth, viewHeight * HOURS_LABEL_HEIGHT)
        self.hoursLabel.text = "Hours"
        
        //hours view
        self.hoursView.frame = CGRectMake(0, self.hoursLabel.frame.height, viewWidth, viewHeight * DINING_HOURS_VIEW_HEIGHT)
        self.hoursView.backgroundColor = self.hoursViewColor
        
        //hours icon
        self.hoursIcon.frame = CGRectMake(0, 0, viewHeight * HOURS_ICON_SIZE, viewHeight * HOURS_ICON_SIZE)
        self.hoursIcon.backgroundColor = UIColor.redColor()
        
        //hours text view
        self.hoursTextView.frame = CGRectMake(viewHeight * HOURS_ICON_SIZE, 0, DINING_HOURS_TEXT_VIEW_WIDTH * viewWidth, DINING_HOURS_VIEW_HEIGHT * viewHeight)
        self.hoursTextView.text = "Breakfast\nLunch\nDinner"
        
        //location label
        self.locationLabel.frame = CGRectMake(0, self.hoursView.frame.origin.y + self.hoursView.frame.size.height, viewWidth, LOCATION_LABEL_HEIGHT * viewHeight)
        self.locationLabel.text = "Location"
        
        //map view
        self.mapView.frame = CGRectMake(0, self.locationLabel.frame.origin.y + self.locationLabel.frame.size.height, viewWidth, MAP_VIEW_HEIGHT * viewHeight)
        
        //location title label
        self.diningNameLabel.frame = CGRectMake(0, self.mapView.frame.origin.y + self.mapView.frame.size.height, viewWidth, DINING_NAME_LABEL_HEIGHT * viewHeight)
        self.diningNameLabel.text = "Appel Commons"
        self.diningNameLabel.backgroundColor = self.diningNameLabelColor
        
        
        //payment view
        self.paymentView.frame = CGRectMake(0, self.diningNameLabel.frame.origin.y + self.diningNameLabel.frame.size.height, viewWidth, PAYMENT_VIEW_HEIGHT * viewHeight)
        
        //payment label
        self.paymentLabel.frame = CGRectMake(0, 0, viewWidth * PAYMENT_TEXT_WIDTH , viewHeight * PAYMENT_VIEW_HEIGHT)
        self.paymentLabel.text = "Payment"
        
        //payment icons
        let cushionSpace = PAYMENT_ICON_CUSHION_SPACE * viewWidth
        
        self.paymentIcon1.frame = CGRectMake(self.paymentLabel.frame.size.width, 0, PAYMENT_IMAGE_WIDTH * viewWidth, PAYMENT_IMAGE_HEIGHT * viewHeight)
        self.paymentIcon1.backgroundColor = UIColor.blackColor()
        
        self.paymentIcon2.frame = CGRectMake(cushionSpace + self.paymentIcon1.frame.origin.x + self.paymentIcon1.frame.size.width, 0, PAYMENT_IMAGE_WIDTH * viewWidth, PAYMENT_IMAGE_HEIGHT * viewHeight)
        self.paymentIcon2.backgroundColor = UIColor.blackColor()
        
        self.paymentIcon3.frame = CGRectMake(cushionSpace + self.paymentIcon2.frame.origin.x + self.paymentIcon2.frame.size.width, 0, PAYMENT_IMAGE_WIDTH * viewWidth, PAYMENT_IMAGE_HEIGHT * viewHeight)
        self.paymentIcon3.backgroundColor = UIColor.blackColor()
        
        self.paymentIcon4.frame = CGRectMake(cushionSpace + self.paymentIcon3.frame.origin.x + self.paymentIcon3.frame.size.width, 0, PAYMENT_IMAGE_WIDTH * viewWidth, PAYMENT_IMAGE_HEIGHT * viewHeight)
        self.paymentIcon4.backgroundColor = UIColor.blackColor()
        
        self.paymentIcon5.frame = CGRectMake(cushionSpace + self.paymentIcon4.frame.origin.x + self.paymentIcon4.frame.size.width, 0, PAYMENT_IMAGE_WIDTH * viewWidth, PAYMENT_IMAGE_HEIGHT * viewHeight)
        self.paymentIcon5.backgroundColor = UIColor.blackColor()
        
        
        
        self.view.addSubview(self.hoursLabel)
        self.view.addSubview(self.locationLabel)
        self.view.addSubview(self.hoursView)
        self.hoursView.addSubview(self.hoursIcon)
        self.hoursView.addSubview(self.hoursTextView)
        self.view.addSubview(self.locationLabel)
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.diningNameLabel)
        self.view.addSubview(self.paymentView)
        self.paymentView.addSubview(self.paymentLabel)
        self.paymentView.addSubview(self.paymentIcon1)
        self.paymentView.addSubview(self.paymentIcon2)
        self.paymentView.addSubview(self.paymentIcon3)
        self.paymentView.addSubview(self.paymentIcon4)
        self.paymentView.addSubview(self.paymentIcon5)

    }
    
    func populateViews()
    {
        
        //dining name
//        self.diningNameLabel.text = self.diningHall.name
//        
//        let span = MKCoordinateSpanMake(1, 1)
//        let region = MKCoordinateRegion(center: self.diningHall.location.coordinate, span: span)
//        self.mapView.setRegion(region, animated: false)
        
        //TODO
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
