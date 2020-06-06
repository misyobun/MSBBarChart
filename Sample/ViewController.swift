//
//  ViewController.swift
//  Sample
//
//  Created by NaotoTakahashi
//  Copyright © 2020 msb. All rights reserved.
//

import UIKit
import MSBBarChart

class ViewController: UIViewController {
    @IBOutlet weak var barChart: MSBBarChartView!
    @IBOutlet weak var barChart2: MSBBarChartView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.barChart.setOptions([.yAxisTitle("成長"), .yAxisNumberOfInterval(10)])
        self.barChart.assignmentOfColor =  [0.0..<0.14: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), 0.14..<0.28: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), 0.28..<0.42: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), 0.42..<0.56: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), 0.56..<0.70: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), 0.70..<1.0: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)]
        self.barChart.setDataEntries(values: [12,24,36,48,60,72,84,96])
        self.barChart.setXAxisUnitTitles(["繊維","IT","鉄鋼","繊維","リテール","不動産","人材派遣","銀行"])
        self.barChart.start()
        
        self.barChart2.isHiddenLabelAboveBar = true
        self.barChart2.setOptions([.yAxisTitle("売上"), .xAxisUnitLabel("月")])
        self.barChart2.assignmentOfColor =  [0.0..<0.14: #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), 0.14..<0.28: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), 0.28..<0.42: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), 0.42..<0.56: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), 0.56..<0.70: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), 0.70..<1.0: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
        self.barChart2.setDataEntries(values: [16,32,64,128,256,512,1024,2048])
        self.barChart2.start()
    }

}

