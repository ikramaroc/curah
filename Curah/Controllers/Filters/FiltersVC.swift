//
//  FiltersVC.swift
//  Curah
//
//  Created by Netset on 18/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
var sliderValue : Int = 50

@objc public protocol CallbackOnProviderListingScreen {
    func callProviderListingAPI(priceRange:String, paginationIndex:Int)
}

class FiltersVC: UIViewController {
    var objProtocol : CallbackOnProviderListingScreen?
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var btnLowToHigh: UIButton!
    @IBOutlet weak var btnHighToLow: UIButton!
    @IBOutlet weak var movingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnLowToHigh.isSelected = true
        self.setup()
    }
    
    @IBAction func btnApplyAct(_ sender: Any) {
        var priceRange = Param.lowToHigh.rawValue
        if btnHighToLow.isSelected {
            priceRange = Param.highToLow.rawValue
        }
        objProtocol?.callProviderListingAPI(priceRange: priceRange, paginationIndex: 0)
        dismiss(animated: true, completion: nil)
    }
    
    private func setup() {
        rangeSlider.delegate = self
    //  rangeSlider.handleImage = #imageLiteral(resourceName: "range_slide")
        rangeSlider.selectedHandleDiameterMultiplier = 1.0
    //  tblVwHeightConst.constant = 0
        self.setLabelValue(maxValue: CGFloat(sliderValue))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLowToHigh(_ sender: UIButton) {
        self.btnSelection(sender)
           btnSelection(btnHighToLow)

    }
    
    @IBAction func btnHighToLow(_ sender: UIButton) {
        self.btnSelection(sender)
        btnSelection(btnLowToHigh)
       
    }
    
    func btnSelection(_ sender:UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
}

// MARK: - RangeSeekSliderDelegate

extension FiltersVC: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        self.setLabelValue(maxValue: maxValue)
        sliderValue = Int(maxValue)
    }
    
    func setLabelValue(maxValue:CGFloat) {
        let pontValue = self.view.frame.size.width/50
        let value : Int = Int(maxValue)
        let minusValue : CGFloat = 1.0
        movingLabel.frame = CGRect(x: maxValue*(pontValue-minusValue), y: movingLabel.frame.origin.y, width: movingLabel.frame.size.width, height: movingLabel.frame.size.height)
        movingLabel.text = "\(value) miles"
        movingLabel.sizeToFit()
        rangeSlider.selectedMaxValue = maxValue
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
