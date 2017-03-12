//
//  ViewController.swift
//  GravityTagCloudViewDemo
//
//  Created by chan bill on 26/2/2017.
//  Copyright © 2017 chan bill. All rights reserved.
//
//  TODO: create UI for switch between tests

import UIKit
import GravityTagCloudView

class ViewController: UIViewController {
    @IBOutlet weak var gravityTagCloudView: GravityTagCloudView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Test tag gesture */
        
        gravityTagCloudView.tagClickBlock = { label, title, tag -> Void in
            label.textColor = UIColor.darkGray
        }

        /* Test 0: happy case with random size*/
//        testRandomFontSize()
        
        /* Test 1: happy case */
        testWeightFontSize()
        
        /* Test 2: adding a lot of labels in 3 calls, expect can not put them all in the view (~203 labels added in iPhone 5) */
//        testFillTheViewWithLabels()
        
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    /*
     override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }
     */
    
    func testRandomFontSize() {
        gravityTagCloudView.labelSizeType = .random
        gravityTagCloudView.titles = ["elephant", "cow", "horse", "dog", "cat", "rat"]
        gravityTagCloudView.generate(labelCreatedHandler:{ label in
            /* label added = 4~24 */
            //            print("label added:\(label)")
        })
    }
    
    func testWeightFontSize() {
        gravityTagCloudView.labelSizeType = .weighted
        gravityTagCloudView.titleWeights = [["title":"elephant", "weight":10],
                                            ["title":"cow", "weight":7],
                                            ["title":"horse", "weight":7],
                                            ["title":"dog", "weight":5],
                                            ["title":"cat", "weight":3],
                                            ["title":"rat", "weight":1],
                                            ["title":"mouse", "weight":1],
        ]
        
        gravityTagCloudView.generate()
    }

    func testFillTheViewWithLabels() {
        var array = [[String:Any]]()
        
        for i in 1...1000 {
            array.append(["title":"bug\(i)", "weight":100])
        }
        
        gravityTagCloudView.labelSizeType = .weighted
        gravityTagCloudView.titleWeights = array
        
        var totalAdded = 0
        /* ~ 196~205 labels added*/
        gravityTagCloudView.generate(completionHandler:{ finish, numLabelAdded in
            print("finish=\(finish), label added = \(numLabelAdded)")
            /* fill the tag after the tags fell*/
            totalAdded += numLabelAdded
            self.delayWithSeconds(10) {
                self.gravityTagCloudView.generate(totalAdded, cleanBeforeGenerate:false, labelCreatedHandler:nil, completionHandler:{ finish, numLabelAdded in
                    /* label added = 43~55 */
                    print("finish=\(finish), label added = \(numLabelAdded)")
                    totalAdded += numLabelAdded
                    self.delayWithSeconds(10) {
                        self.gravityTagCloudView.generate(totalAdded, cleanBeforeGenerate:false, labelCreatedHandler:nil, completionHandler:{ finish, numLabelAdded in
                            /* label added = 4~24 */
                            print("finish=\(finish), label added = \(numLabelAdded)")
                        })
                    }
                })
            }
        })
    }
}

