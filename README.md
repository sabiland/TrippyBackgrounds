# TrippyBackgrounds - iOS

For the recent iOS game I am developing I wrote a simple helper class for my game to generate totaly random image (pattern). I think the outcome is really nice and useful for backgrounds, textures, etc.

So I've uploaded a sample SpriteKit project if anyone would be interested to use it.

Class responsible for creating image is

```swift
SabilandTB.swift
```

Usage

```swift
// NOTE: Generated image is SQUARE -> max(width, height)
let generator = SabilandTB(width: 500.0, height: 200.0)
let trippyImage = generator.SabilandTrippyBackground
```

Example how to use it as a SpriteKit background image

```swift
let background = SKNode()
background.addChild(SKSpriteNode(texture: SKTexture(CGImage: trippyImage.CGImage!)))
background.position = CGPointMake(MasterSKView.frame.midX, MasterSKView.frame.midY)
self.addChild(background)
```

