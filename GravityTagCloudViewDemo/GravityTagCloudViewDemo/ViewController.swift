//
//  ViewController.swift
//  GravityTagCloudViewDemo
//
//  Created by chan bill on 26/2/2017.
//  Copyright © 2017 chan bill. All rights reserved.
//

import UIKit
import GravityTagCloudView

class ViewController: UIViewController {
    @IBOutlet weak var gravityTagCloudView: GravityTagCloudView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gravityTagCloudView.labelSizeType = .weighted
        
        /* Test 1: happy case */
         gravityTagCloudView.titleWeights = [["title":"elephant", "weight":10],
         ["title":"cow", "weight":7],
         ["title":"horse", "weight":7],
         ["title":"dog", "weight":5],
         ["title":"cat", "weight":3],
         ["title":"rat", "weight":1],
         ["title":"mouse", "weight":1],
         ]
         
         gravityTagCloudView.generate()
        
        /* Test 2: adding a lot of labels in 3 calls, expect can not put them all in the view (~203 labels added in iPhone 5) */
        
        var array = [[String:Any]]()
        
        for i in 1...1000 {
            array.append(["title":"bug\(i)", "weight":100])
        }
        
        gravityTagCloudView.titleWeights = array
        
        var totalAdded = 0
        /* ~ 196~205 labels added*/
        gravityTagCloudView.generate(completionHandler:{ finish, numLabelAdded in
            print("finish=\(finish), label added = \(numLabelAdded)")
            /* fill the tag after the tags fell*/
            totalAdded += numLabelAdded
            self.delayWithSeconds(10) {
                self.gravityTagCloudView.generate(totalAdded, labelCreatedHandler:nil, completionHandler:{ finish, numLabelAdded in
                    /* label added = 43~55 */
                    print("finish=\(finish), label added = \(numLabelAdded)")
                    totalAdded += numLabelAdded
                    self.delayWithSeconds(10) {
                        self.gravityTagCloudView.generate(totalAdded, labelCreatedHandler:nil, completionHandler:{ finish, numLabelAdded in
                            /* label added = 4~24 */
                            print("finish=\(finish), label added = \(numLabelAdded)")
                        })
                    }
                })
            }
        })
        
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
    
    
}

