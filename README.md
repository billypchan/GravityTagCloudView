# GravityTagCloudView
A tag cloud view with gravity for iOS. It is a rewritten version of https://github.com/zhangao0086/DKTagCloudView in swift 3 and more options are included.

Fill some bugs in the iPhone SE screen:

<img src="https://raw.githubusercontent.com/billypchan/GravityTagCloudView/master/doc/tagsOfbugs.png" width="200" height="400" />

Playground example:

![PNG](https://raw.githubusercontent.com/billypchan/GravityTagCloudView/master/doc/playground.png)

///TODO: gif

///TODO: example for no gravity, random font size


## How To Get Started

### Installation with CocoaPods

Edit your Podfile and add DKTagCloudView, (TODO add to offical pod spec):

``` bash
source 'https://github.com/billypchan/BCPodSpecs.git'

pod 'GravityTagCloudView', '~> 0.1.0'
```

Add `import GravityTagCloudView` to the top of classes that will use it.  
#### Create instances (Also supports xib/storyboard) :

``` Swift
let gravityTagCloudView = GravityTagCloudView()

gravityTagCloudView.frame = CGRect(x: 0, y: 0, width: 360, height: 200)

self.view.addSubview(gravityTagCloudView)

```

#### Setup items:

If you want the size of the label is propertional to their weight, please set labelSizeType properties to kWeighted and assign  array to titleWeights:

``` Swift
gravityTagCloudView.labelSizeType = .weighted
gravityTagCloudView.titleWeights = [["title":"elephant", "weight":10],
                                    ["title":"cow", "weight":7],
                                    ["title":"horse", "weight":7],
                                    ["title":"dog", "weight":5],
                                    ["title":"cat", "weight":3],
                                    ["title":"rat", "weight":1],
                                    ["title":"mouse", "weight":1],
                                    ]
```

#### Generates:

``` Swift
gravityTagCloudView.generate()
```

#### Callback

``` Swift
gravityTagCloudView.tagClickBlock = { title, tag -> Void in       
  print("tag =\(tag), title=\(title)")
}
```

#### Customized:

``` Swift

/**
 *  Label size option. Defautls to random.
 */
public var labelSizeType : LabelSizeType = .random

/**
 *  Gravity enabled?
 */
public var isGravity : Bool = true

/**
 *  Min font size. Defautls to 14.
 */
public var minFontSize : Float = 14

/**
 *  Max font size. Defaults to 60.
 */
public var maxFontSize : Float = 60

/**
 *  Random text colors with default list
 */
public var randomColors = [UIColor.black, UIColor.cyan, UIColor.purple, UIColor.orange, UIColor.red, UIColor.yellow, UIColor.lightGray, UIColor.gray, UIColor.green]
```

## License
This code is distributed under the terms and conditions of the <a href="https://github.com/zhangao0086/DKTagCloudView/master/LICENSE">MIT license</a>.
