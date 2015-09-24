//
//  GameScene.swift
//  SabilandTBPreview
//
//  Created by Marko Sabotin on 24/09/15.
//  Copyright (c) 2015 Marko Sabotin. All rights reserved.
//

import SpriteKit

private let BackgroundRotatingIntervalMin:Int = 30
private let BackgroundRotatingIntervalMax:Int = 40
private let BackgroundScalingIntervalMin:Int = 3
private let BackgroundScalingIntervalMax:Int = 5

class GameScene: SKScene {
    
    var MasterView:SKView!
    var STB:SKNode!
    
    override func didMoveToView(view: SKView) {
        MasterView = view
        
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 20;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:10.0);
        myLabel.zPosition = 1000.0
        self.addChild(myLabel)
        setNewSabilandTrippyBackground()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        setNewSabilandTrippyBackground()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    private func setNewSabilandTrippyBackground()
    {
        if STB != nil
        {
            STB.removeAllChildren()
            STB.removeAllActions()
            STB.removeFromParent()
        }
        
        let imageEngine = SabilandTB(width: MasterView.frame.width, height: MasterView.frame.height)
        let sprite = SKSpriteNode(texture: SKTexture(CGImage: imageEngine.SabilandTrippyBackground.CGImage!))
        STB = SKNode()
        STB.addChild(createTextureFromShapeNode(sprite))
        STB.zPosition = 100.0
        STB.position = CGPointMake(MasterView.frame.midX, MasterView.frame.midY)
        self.addChild(STB)
        
        // NOTE: Uncomment this for nice simple rotate/scale animation
        /*let rotatingAngle1:CGFloat = Helper.fiftyFiftyOnePlusMinus() * CGFloat(M_PI_2)
        // NOTE: Reverse angle
        let rotatingAngle2:CGFloat = -rotatingAngle1
        
        let backgroundRotatorSequence = SKAction.sequence([
            SKAction.rotateByAngle(rotatingAngle1, duration: NSTimeInterval(CGFloat(Helper.randomBetween(BackgroundRotatingIntervalMin, max: BackgroundRotatingIntervalMax, includeMax: true)))),
            SKAction.rotateByAngle(rotatingAngle2, duration: NSTimeInterval(CGFloat(Helper.randomBetween(BackgroundRotatingIntervalMin, max: BackgroundRotatingIntervalMax, includeMax: true))))
            ])
        let backgroundScaleSequence = SKAction.sequence([
            SKAction.scaleTo(1.2 + (Helper.random01CGFloat() / 3.0), duration: NSTimeInterval(CGFloat(Helper.randomBetween(BackgroundScalingIntervalMin, max: BackgroundScalingIntervalMax, includeMax: true)))),
            SKAction.scaleTo(1.0, duration: NSTimeInterval(CGFloat(Helper.randomBetween(BackgroundScalingIntervalMin, max: BackgroundScalingIntervalMax, includeMax: true))))
            ])
        
        STB.runAction(SKAction.repeatActionForever(backgroundRotatorSequence))
        STB.runAction(SKAction.repeatActionForever(backgroundScaleSequence))*/
    }
    
    private func createTextureFromShapeNode(input:SKNode) -> SKSpriteNode
    {
        return SKSpriteNode(texture: MasterView.textureFromNode(input))
    }
    
}
