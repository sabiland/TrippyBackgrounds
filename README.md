# TrippyBackgrounds - iOS

For the recent iOS game I am developing I wrote a simple helper class for my game to generate totaly random image for a *scene background*. I think the outcome is really nice and useful for backgrounds, textures, etc.

So I've uploaded a sample SpriteKit project if anyone would be interested to use it.

Class responsible for creating image is

```swift
SabilandTB.swift
```

Usage (generated image is **SQUARE** -> *max(width, height)*)

```swift
// NOTE: WIDTH and HEIGHT must be >= 1.0
let generator = SabilandTB(width: 500.0, height: 200.0)
let trippyImage = generator.SabilandTrippyBackground
```

Example how to use it in a SpriteKit game as a background image

```swift
let background = SKNode()
background.addChild(SKSpriteNode(texture: SKTexture(CGImage: trippyImage.CGImage!)))
background.position = CGPointMake(MasterSKView.frame.midX, MasterSKView.frame.midY)
self.addChild(background)
```

Examples of *fully-randomly-generated* images. These are just **a few examples**.

![Alt text](http://i.imgur.com/9jq9YwQ.png)

![Alt text](http://i.imgur.com/2eZpnHQ.png)

![Alt text](http://i.imgur.com/lpkcXjk.png)

![Alt text](http://i.imgur.com/X8KuFgi.png)

![Alt text](http://i.imgur.com/il3HiB9.png)

![Alt text](http://i.imgur.com/Ynn7VRf.png)

![Alt text](http://i.imgur.com/1wxFGTR.png)

![Alt text](http://i.imgur.com/wKWQPU7.png)

![Alt text](http://i.imgur.com/m3AwCYh.png)

![Alt text](http://i.imgur.com/n9DNufN.png)

![Alt text](http://i.imgur.com/JuNRyxx.png)
