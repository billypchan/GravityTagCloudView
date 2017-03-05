////: Playground - noun: a place where people can play
import UIKit
import PlaygroundSupport

import GravityTagCloudView

let gravityTagCloudView = GravityTagCloudView()

gravityTagCloudView.frame = CGRect(x: 0, y: 0, width: 360, height: 200)

let container = UIView(frame: CGRect(x: 0, y: 0, width: 360, height: 200))

/* Test case: tag cloud with 7 tags with weighted size*/
container.addSubview(gravityTagCloudView) ///TODO: gravity not work? Please look at the demo project!

PlaygroundPage.current.liveView = container
PlaygroundPage.current.needsIndefiniteExecution = true

/* Test case: tag cloud with random size */
gravityTagCloudView.labelSizeType = .random
gravityTagCloudView.titles = ["elephant", "cow", "horse", "dog", "cat", "rat"]
gravityTagCloudView.generate(labelCreatedHandler:{ label in
    /* label added = 4~24 */
    print("label added:\(label)")
})

container

gravityTagCloudView.labelSizeType = .weighted
gravityTagCloudView.titleWeights = [["title":"elephant", "weight":10],
                                    ["title":"cow", "weight":7],
                                    ["title":"horse", "weight":7],
                                    ["title":"dog", "weight":5],
                                    ["title":"cat", "weight":3],
                                    ["title":"rat", "weight":1],
                                    ["title":"mouse", "weight":1]
                                    ]
gravityTagCloudView.generate(labelCreatedHandler:{ label in
    /* label added = 4~24 */
    print("label added:\(label)")
})

container


/* Test case: try to create a tag cloud with 100 tags */
var array = [[String:Any]]()
for i in 1...100 {
    array.append(["title":"bug\(i)", "weight":100])
}

gravityTagCloudView.titleWeights = array

gravityTagCloudView.generate(completionHandler:{ finish, numLabelAdded in
    let log = "finish=\(finish), label added = \(numLabelAdded)"
})

/* try to fill the view with bugs! ~ 71~74 tags in the view */
container


