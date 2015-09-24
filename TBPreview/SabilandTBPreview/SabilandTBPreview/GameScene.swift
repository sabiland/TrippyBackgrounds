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
     
        
        /*let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.addChild(SKSpriteNode(texture: SKTexture(CGImage: image.CGImage!)))
        
        
        self.GameBackground = DodgieCommon.createTextureFromShapeNode(Background2(), masterSKView: self.MasterSKView)
        self.GameBackground.zPosition = -1.0
        self.GameBackground.position = MasterBordersCenter

        
        */
        
    }
    
    private func createTextureFromShapeNode(input:SKNode) -> SKSpriteNode
    {
        return SKSpriteNode(texture: MasterView.textureFromNode(input))
    }
    
}
