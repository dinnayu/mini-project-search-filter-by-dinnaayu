//
//  FilterPageController.swift
//  mini-project-search-filter
//
//  Created by Dinna Ayu Karunniawati on 9/19/18.
//  Copyright © 2018 Dinna Ayu Karunniawati. All rights reserved.
//

import UIKit
import SwiftRangeSlider

protocol FilterPageControllerDalegate {
    func dataFromFilter(minRange: Int, maxRange: Int, isWholeSale: Bool)
}

class FilterPageController: UIViewController {

    @IBOutlet weak var wholeSaleSwitch: UISwitch!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    var DEFAULT_MINRANGE = 100
    var DEFAULT_MAXRANGE = 8000000
    
    var minRange: Int = 100
    var maxRange: Int = 8000000
    var isWholeSale: Bool = false
    var delegate: FilterPageControllerDalegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyButton.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.3, alpha: 1)
        self.rangeSlider.lowerValue = Double(DEFAULT_MINRANGE)
        self.rangeSlider.upperValue = Double(DEFAULT_MAXRANGE)
        self.rangeSlider.updateLabelPositions()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func rangeSliderAction(_ slider: RangeSlider) {
        self.minRange = Int(slider.lowerValue)
        self.maxRange = Int(slider.upperValue)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func wholeSaleButton(_ wholeSaleSwitch: UISwitch) {
        self.isWholeSale = wholeSaleSwitch.isOn
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        self.minRange = DEFAULT_MINRANGE
        self.maxRange = DEFAULT_MAXRANGE
        self.rangeSlider.lowerValue = Double(DEFAULT_MINRANGE)
        self.rangeSlider.upperValue = Double(DEFAULT_MAXRANGE)
        self.rangeSlider.updateLabelPositions()
    }
    
    @IBAction func applyButtonClick(_ sender: Any) {
        delegate?.dataFromFilter(minRange: self.minRange, maxRange: self.maxRange, isWholeSale: self.isWholeSale)
        self.dismiss(animated: true, completion: nil)
    }
}
