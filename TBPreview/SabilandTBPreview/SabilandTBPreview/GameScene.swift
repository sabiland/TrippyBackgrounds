//
//  GameScene.swift
//  SabilandTBPreview
//
//  Created by Marko Sabotin on 24/09/15.
//  Copyright (c) 2015 Marko Sabotin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var MasterView:SKView!
    var STB:SKNode!
    
    override func didMoveToView(view: SKView) {
        MasterView = view
        
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 40;
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
            STB.removeFromParent()
        }
        
        let imageEngine = SabilandTB(width: MasterView.frame.width, height: MasterView.frame.height)
        let sprite = SKSpriteNode(texture: SKTexture(CGImage: imageEngine.SabilandTrippyBackground.CGImage!))
        STB = SKNode()
        STB.addChild(createTextureFromShapeNode(sprite))
        STB.zPosition = 100.0
        STB.position = CGPointMake(MasterView.frame.midX, MasterView.frame.midY)
        self.addChild(STB)
    }
    
    private func createTextureFromShapeNode(input:SKNode) -> SKSpriteNode
    {
        return SKSpriteNode(texture: MasterView.textureFromNode(input))
    }
    
}
