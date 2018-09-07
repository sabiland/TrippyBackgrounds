/*
 Copyright (c) 2015 Marko Sabotin
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit
import SpriteKit

private let FactorLinesStepperMin:CGFloat = 40.0
private let FactorLinesStepperMax:CGFloat = 80.0
private let FactorLinesAnglesMin:Int = 100
private let FactorLinesAnglesMax:Int = 150
private let FactorShadowSettingMax:CGFloat = 5.0
private let FactorLineWidthMax:CGFloat = 10.0
private let FactorInsidersOverlays:Int = 7
private let FactorBlackHoleMin:Int = 10
private let FactorBlackHoleMax:Int = 30
private let FactorMaxPossibleblackHoleOffsetForTranslate:CGFloat = 5.0
private let FactorBlackHoleMin2:Int = 20
private let FactorBlackHoleMax2:Int = 40

extension Array {
    
    mutating func shuffle() {
        if self.isEmpty
        {
            return
        }
        
        for index in 0..<self.count {
            let newIndex = Int(arc4random_uniform(UInt32(self.count-index))) + index
            if index != newIndex
            { // Check if you are not trying to swap an element with itself
                self.swapAt(index, newIndex)
            }
        }
    }
}

class Helper:NSObject
{
    
    class func random01CGFloat() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    class func fiftyFifty() -> Bool
    {
        return random01CGFloat() > 0.5
    }
    
    class func getRandomColor(alpha:CGFloat = 1.0) -> UIColor
    {
        return UIColor(red: Helper.random01CGFloat(), green: Helper.random01CGFloat(), blue: Helper.random01CGFloat(), alpha: alpha)
    }
    
    private class func randomBetweenMinMax(min:UInt32, max:UInt32) -> Int
    {
        var r:Int = Int(min + (arc4random() % (max - min)))
        
        if r < Int(min)
        {
            r = Int(min)
        }
        else if r > Int(max)
        {
            r = Int(max)
        }
        
        return r;
    }
    
    class func randomBetween(min: Int, max: Int, includeMax:Bool = false) -> Int
    {
        // NOTE: !!! SPECIAL CASE, THIS MUST BE THIS WAY - SO SELECTING RANDOM NUMBER OF 1-LENGTH ARRAY WOULD WORK!
        
        var newMax = max
        
        if min == newMax
        {
            return min
        }
        
        if newMax <= min
        {
            newMax = min + 1
        }
        
        if includeMax
        {
            newMax += 1
        }
        
        return randomBetweenMinMax(min: UInt32(min), max: UInt32(newMax))
    }
    
    class func fiftyFiftyOnePlusMinus() -> CGFloat
    {
        let r = random01CGFloat()
        
        if r > 0.5
        {
            return (random01CGFloat() > 0.5 ? 1.0 : -1.0)
        }
        else
        {
            return (random01CGFloat() > 0.5 ? -1.0 : 1.0)
        }
    }
    
}

class SabilandTB: NSObject {
    
    var BackDimensionMax:CGFloat!
    var BackRect:CGRect!
    var SabilandTrippyBackground:UIImage!
    
    init(width:CGFloat, height:CGFloat)
    {
        super.init()
        precondition(width >= 1.0 && height >= 1.0, "WIDTH and HEIGHT must be >= 1.0")
        BackDimensionMax = max(width, height)
        BackRect = CGRect(x: 0.0, y: 0.0, width: BackDimensionMax, height: BackDimensionMax)
        setupBackground()
    }
    
    private func getDynamicAlphaSetting() -> CGFloat
    {
        return 0.1 + (Helper.random01CGFloat() * 0.3)
    }
    
    private func getDynamicRandomColor() -> UIColor
    {
        return Helper.getRandomColor(alpha: getDynamicAlphaSetting())
    }
    
    // NOTE: Harder alpha
    private func setRandomStroke2(ctx:CGContext)
    {
        Helper.getRandomColor(alpha: 0.4 + (Helper.random01CGFloat() * 0.5)).setStroke()
        
        if Helper.fiftyFifty()
        {
            setRandomShadow(ctx: ctx)
        }
    }
    
    private func setRandomStroke(ctx:CGContext)
    {
        getDynamicRandomColor().setStroke()
        
        if Helper.fiftyFifty()
        {
            setRandomShadow(ctx: ctx)
        }
    }
    
    private func setRandomFill(ctx:CGContext)
    {
        getDynamicRandomColor().setFill()
        
        if Helper.fiftyFifty()
        {
            setRandomShadow(ctx: ctx)
        }
    }
    
    // NOTE: Lighter alpha
    private func setRandomFillLighter(ctx:CGContext)
    {
        Helper.getRandomColor(alpha: 0.1 + (Helper.random01CGFloat() * 0.2)).setFill()
        
        if Helper.fiftyFifty()
        {
            setRandomShadow(ctx: ctx)
        }
    }
    
    // NOTE: Harder alpha
    private func setRandomFill2(ctx:CGContext)
    {
        Helper.getRandomColor(alpha: 0.4 + (Helper.random01CGFloat() * 0.5)).setFill()
        
        if Helper.fiftyFifty()
        {
            setRandomShadow(ctx: ctx)
        }
    }
    
    private func setRandomLineWidth(ctx:CGContext)
    {
        ctx.setLineWidth(1.0 + (Helper.random01CGFloat() * FactorLineWidthMax))
    }
    
    private func setRandomShadow(ctx:CGContext)
    {
        ctx.setShadow(offset: CGSize(width: Helper.random01CGFloat() * FactorShadowSettingMax, height: Helper.random01CGFloat() * FactorShadowSettingMax), blur: Helper.random01CGFloat() * FactorShadowSettingMax)
    }
    
    // NOTE: First layer
    private func drawFirstLayer(ctx:CGContext)
    {
        let step:CGFloat = BackDimensionMax / CGFloat(Helper.randomBetween(min: Int(FactorLinesStepperMin), max: Int(FactorLinesStepperMax), includeMax: false))
        
        setRandomStroke2(ctx: ctx)
        setRandomLineWidth(ctx: ctx)
        
        var i = BackRect.minX
        
        while i <= BackRect.maxX {
            ctx.move(to: CGPoint(x: i, y: BackRect.minY))
            ctx.addLine(to: CGPoint(x: i, y: BackRect.maxY))
            i += step
        }
        
        ctx.strokePath()
        
        setRandomStroke2(ctx: ctx)
        setRandomLineWidth(ctx: ctx)
        
        var j = BackRect.minY
        
        while j <= BackRect.maxY {
            ctx.move(to: CGPoint(x: BackRect.minX, y: j))
            ctx.addLine(to: CGPoint(x: BackRect.maxX, y: j))
            j += step
        }
        ctx.strokePath()
    }
    
    private func drawSingleTriangle(ctx:CGContext, _ p1:CGPoint, _ p2:CGPoint, _ p3:CGPoint)
    {
        if Helper.fiftyFifty()
        {
            setRandomFill2(ctx: ctx)
        }
        else
        {
            setRandomFill(ctx: ctx)
        }
        ctx.beginPath()
        ctx.move(to: CGPoint(x: p1.x, y: p1.y))
        ctx.move(to: CGPoint(x: p2.x, y: p2.y))
        ctx.move(to: CGPoint(x: p3.x, y: p3.y))
        ctx.closePath()
        ctx.fillPath()
        
        if Helper.fiftyFifty()
        {
            setRandomStroke2(ctx: ctx)
            setRandomLineWidth(ctx: ctx)
            
            ctx.beginPath()
            ctx.move(to: CGPoint(x: p1.x, y: p1.y))
            ctx.move(to: CGPoint(x: p2.x, y: p2.y))
            ctx.move(to: CGPoint(x: p3.x, y: p3.y))
            ctx.closePath()
            ctx.fillPath()
        }
    }
    
    private func drawTriangles(ctx:CGContext)
    {
        drawSingleTriangle(
            ctx: ctx,
            CGPoint(x: BackRect.minX, y: BackRect.minY),
            CGPoint(x: BackRect.minX, y: BackRect.maxY),
            CGPoint(x: BackRect.maxX, y: BackRect.maxY))
        
        if Helper.fiftyFifty()
        {
            // Another shifted
            drawSingleTriangle(
                ctx: ctx,
                CGPoint(x: BackRect.minX, y: BackRect.minY),
                CGPoint(x: BackRect.minX, y: BackRect.maxY),
                CGPoint(x: BackRect.maxX, y: BackRect.maxY))
        }
        
        if Helper.fiftyFifty()
        {
            // Another mixed
            drawSingleTriangle(
                ctx: ctx,
                CGPoint(x: BackRect.minX, y: BackRect.minY),
                CGPoint(x: BackRect.midX, y: BackRect.midY),
                CGPoint(x: BackRect.maxX, y: BackRect.minY))
        }
    }
    
    private func blackHolesRandomizations(ctx:CGContext, randomize1:Bool, randomize2:Bool, randomize3:Bool, randomize4:Bool)
    {
        if randomize1
        {
            setRandomShadow(ctx: ctx)
        }
        
        if randomize2
        {
            setRandomLineWidth(ctx: ctx)
        }
        
        if randomize3
        {
            if Helper.fiftyFifty()
            {
                setRandomStroke(ctx: ctx)
            }
            else
            {
                setRandomStroke2(ctx: ctx)
            }
        }
        
        if randomize4
        {
            setRandomFillLighter(ctx: ctx)
        }
    }
    
    private func getPossibleBlackHoleOffsetForTranslate() -> CGFloat
    {
        return Helper.fiftyFiftyOnePlusMinus() * Helper.random01CGFloat() * FactorMaxPossibleblackHoleOffsetForTranslate
    }
    
    // Black hole variant
    private func drawBlackHoleLayerOne(ctx:CGContext)
    {
        let blackHolerFactor:CGFloat = 1.0 + (Helper.random01CGFloat() * 0.5)
        let properBlackHole = Helper.fiftyFifty()
        
        if Helper.fiftyFifty()
        {
            setRandomStroke(ctx: ctx)
        }
        else
        {
            setRandomStroke2(ctx: ctx)
        }
        
        setRandomFillLighter(ctx: ctx)
        setRandomLineWidth(ctx: ctx)
        
        let howMany = Helper.randomBetween(min: FactorBlackHoleMin, max: FactorBlackHoleMax, includeMax: false)
        var holes:[CGRect] = []
        var step:CGFloat = (BackDimensionMax / 2.0) / CGFloat(howMany)
        let centerOut = Helper.fiftyFifty()
        let outOrInFactor:CGFloat = centerOut ? -1.0 : 1.0
        var start:CGFloat = centerOut ? (BackDimensionMax / 2.0) : step
        
        for _ in 0..<howMany
        {
            holes.append(BackRect.insetBy(dx: start, dy: start))//CGRectInset(BackRect, start, start))
            
            if properBlackHole
            {
                step *= blackHolerFactor
                start += step * (outOrInFactor)
            }
            else
            {
                start += step * (outOrInFactor)
            }
        }
        
        if centerOut
        {
            holes.reverse()
        }
        
        let randomize1 = Helper.fiftyFifty()
        let randomize2 = Helper.fiftyFifty()
        let randomize3 = Helper.fiftyFifty()
        let randomize4 = Helper.fiftyFifty()
        
        let circles = Helper.fiftyFifty()
        let makeCirclesLittleOffset = Helper.fiftyFifty()
        
        if circles
        {
            if makeCirclesLittleOffset
            {
                for h in holes
                {
                    blackHolesRandomizations(ctx: ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
                    
                    ctx.saveGState()
                    ctx.translateBy(x: getPossibleBlackHoleOffsetForTranslate(), y: getPossibleBlackHoleOffsetForTranslate())
                    ctx.fillEllipse(in: h)
                    ctx.strokeEllipse(in: h)
                    ctx.restoreGState()
                }
                
            }
            else
            {
                for h in holes
                {
                    blackHolesRandomizations(ctx: ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
                    ctx.fillEllipse(in: h)
                    ctx.strokeEllipse(in: h)
                }
            }
        }
        else
        {
            if Helper.fiftyFifty()
            {
                // NOTE: Squares rotated!
                let angleRotate:CGFloat = (2.0 * CGFloat.pi) / CGFloat(holes.count)
                let centerBack = CGPoint(x: BackRect.midX, y: BackRect.midY)
                
                ctx.saveGState()
                ctx.translateBy(x: centerBack.x, y: centerBack.y)
                
                for h in holes
                {
                    blackHolesRandomizations(ctx: ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
                    
                    let r = CGRect(x: h.minX - centerBack.x, y: h.minY - centerBack.y, width: h.width, height: h.height)
                    ctx.fill(r)
                    ctx.stroke(r)
                    ctx.rotate(by: angleRotate)
                }
                
                ctx.restoreGState()
            }
            else
            {
                for h in holes
                {
                    blackHolesRandomizations(ctx: ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
                    ctx.fill(h)
                    ctx.stroke(h)
                }
            }
        }
    }
    
    private func drawBlackHole(ctx:CGContext)
    {
        let angle:CGFloat = CGFloat((CGFloat.pi * 2.0)) / CGFloat(Helper.randomBetween(min: FactorBlackHoleMin, max: FactorBlackHoleMax, includeMax: false))
        let randomize = Helper.fiftyFifty()
        let randomize2 = Helper.fiftyFifty()
        
        if Helper.fiftyFifty()
        {
            setRandomStroke(ctx: ctx)
        }
        else
        {
            setRandomStroke2(ctx: ctx)
        }
        setRandomLineWidth(ctx: ctx)
        
        let centerBack = CGPoint(x: BackRect.midX, y: BackRect.midY)
        let howLong:CGFloat = CGFloat(CGFloat.pi) * 2.0
        var start:CGFloat = 0.0
        
        ctx.saveGState()
        ctx.translateBy(x: centerBack.x, y: centerBack.y)
        
        let startPoint = CGPoint(x: BackRect.minX - centerBack.x, y: BackRect.minY - centerBack.y)
        let endPoint = CGPoint(x: BackRect.maxX - centerBack.x, y: BackRect.maxY - centerBack.y)
        
        while start <= howLong
        {
            if randomize
            {
                setRandomShadow(ctx: ctx)
            }
            
            if randomize2
            {
                setRandomLineWidth(ctx: ctx)
            }
            
            ctx.rotate(by: angle)
            ctx.beginPath()
            ctx.move(to: startPoint)
            ctx.addLine(to: endPoint)
            ctx.strokePath()
            
            start += angle
        }
        ctx.restoreGState()
    }
    
    // NOTE: First layer variant
    private func drawFirstLayerVariant(ctx:CGContext)
    {
        let angle:CGFloat = CGFloat((CGFloat.pi * 2.0)) / CGFloat(Helper.randomBetween(min: FactorLinesAnglesMin, max: FactorLinesAnglesMax, includeMax: false))
        let randomize = Helper.fiftyFifty()
        let randomize2 = Helper.fiftyFifty()
        
        if Helper.fiftyFifty()
        {
            setRandomStroke(ctx: ctx)
        }
        else
        {
            setRandomStroke2(ctx: ctx)
        }
        setRandomLineWidth(ctx: ctx)
        
        let centerBack = CGPoint(x: BackRect.midX,y: BackRect.midY)
        let howLong:CGFloat = CGFloat(CGFloat.pi) * 2.0
        var start:CGFloat = 0.0
        
        ctx.saveGState()
        ctx.translateBy(x: centerBack.x, y: centerBack.y)
        
        let startPoint = CGPoint(x: BackRect.minX - centerBack.x, y: BackRect.minY - centerBack.y)
        let endPoint = CGPoint(x: BackRect.maxX - centerBack.x, y: BackRect.maxY - centerBack.y)
        
        while start <= howLong
        {
            if randomize
            {
                setRandomShadow(ctx: ctx)
            }
            
            if randomize2
            {
                setRandomLineWidth(ctx: ctx)
            }
            
            ctx.rotate(by: angle)
            ctx.beginPath()
            ctx.move(to: startPoint)
            ctx.addLine(to: endPoint)
            ctx.strokePath()
            start += angle
        }
        
        ctx.restoreGState()
    }
    
    private func drawCirclesOrSquaresOverlay(ctx:CGContext)
    {
        let circles = Helper.fiftyFifty()
        
        for _ in 0..<Helper.randomBetween(min: 1, max: FactorInsidersOverlays, includeMax: true)
        {
            if Helper.fiftyFifty()
            {
                setRandomStroke(ctx: ctx)
            }
            else
            {
                setRandomStroke2(ctx: ctx)
            }
            
            setRandomLineWidth(ctx: ctx)
            setRandomFill(ctx: ctx)
            let inset:CGFloat = (BackRect.width / 2.1) - (Helper.random01CGFloat() * (BackRect.width / 5.0))
            
            let r = BackRect.insetBy(dx: inset, dy: inset)//CGRectInset(BackRect, inset, inset)
            
            if circles
            {
                ctx.fillEllipse(in: r)
                ctx.strokeEllipse(in: r)
            }
            else
            {
                ctx.fill(r)
                ctx.stroke(r)
            }
        }
    }
    
    private func drawFullRectLayer(ctx:CGContext)
    {
        setRandomFill(ctx: ctx)
        ctx.fill(BackRect)
    }
    
    private func drawSpace(ctx:CGContext)
    {
        let angle:CGFloat = CGFloat((CGFloat.pi * 2.0)) / CGFloat(Helper.randomBetween(min: FactorBlackHoleMin2, max: FactorBlackHoleMax2, includeMax: false))
        
        if Helper.fiftyFifty()
        {
            setRandomStroke(ctx: ctx)
        }
        else
        {
            setRandomStroke2(ctx: ctx)
        }
        
        setRandomFillLighter(ctx: ctx)
        setRandomLineWidth(ctx: ctx)
        
        let centerBack = CGPoint(x: BackRect.midX, y: BackRect.midY)
        let howLong:CGFloat = CGFloat.pi * 2.0
        var start:CGFloat = 0.0
        
        ctx.saveGState()
        ctx.translateBy(x: centerBack.x, y: centerBack.y)
        
        let startPoint = CGPoint(x: BackRect.minX - centerBack.x, y: BackRect.minY - centerBack.y)
        let endPoint = CGPoint(x: BackRect.maxX - centerBack.x, y: BackRect.maxY - centerBack.y)
        let controlPointX:CGFloat = BackRect.minX + (Helper.random01CGFloat() * BackRect.width)
        let controlPointY:CGFloat = BackRect.minY + (Helper.random01CGFloat() * BackRect.height)
        let controlPoint = CGPoint(x: controlPointX - centerBack.x,y:  controlPointY - centerBack.y)
        
        var drawFillStroke = Helper.fiftyFifty()
        var fullRandomize = Helper.fiftyFifty()
        let randomize1 = Helper.fiftyFifty()
        let randomize2 = Helper.fiftyFifty()
        let randomize3 = Helper.fiftyFifty()
        let randomize4 = Helper.fiftyFifty()
        
        while start <= howLong
        {
            if fullRandomize
            {
                blackHolesRandomizations(ctx: ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
            }
            
            ctx.rotate(by: angle)
            ctx.beginPath()
            ctx.move(to: startPoint)
            ctx.addLine(to: endPoint)
            
            if drawFillStroke
            {
                ctx.drawPath(using: .fillStroke)
            }
            else
            {
                ctx.strokePath()
            }
            
            start += angle
        }
        
        fullRandomize = Helper.fiftyFifty()
        drawFillStroke = !drawFillStroke
        start = 0.0
        
        let megaCurves = Helper.fiftyFifty()
        let megaMiddlePoint = CGPoint(x: centerBack.x - centerBack.x, y: centerBack.y - centerBack.y)
        let controlPointX2:CGFloat = BackRect.minX + (Helper.random01CGFloat() * BackRect.width)
        let controlPointY2:CGFloat = BackRect.minY + (Helper.random01CGFloat() * BackRect.height)
        let controlPoint2 = CGPoint(x: controlPointX2 - centerBack.x, y: controlPointY2 - centerBack.y)
        
        while start <= howLong
        {
            if fullRandomize
            {
                blackHolesRandomizations(ctx: ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
            }
            
            ctx.rotate(by: angle)
            ctx.beginPath()
            
            if megaCurves
            {
                ctx.move(to: startPoint)
                ctx.addQuadCurve(to: megaMiddlePoint, control: controlPoint)
                ctx.addQuadCurve(to: endPoint, control: controlPoint2)
            }
            else
            {
                ctx.move(to: startPoint)
                ctx.addQuadCurve(to: endPoint, control: controlPoint)
            }
            
            if drawFillStroke
            {
                ctx.drawPath(using: .fillStroke)
            }
            else
            {
                ctx.strokePath()
            }
            
            start += angle
        }
        ctx.restoreGState()
    }
    
    private func carpetsRandomizations(ctx:CGContext, randomize1:Bool, randomize2:Bool, randomize3:Bool)
    {
        if randomize1
        {
            setRandomShadow(ctx: ctx)
        }
        
        if randomize2
        {
            setRandomLineWidth(ctx: ctx)
        }
        
        if randomize3
        {
            if Helper.fiftyFifty()
            {
                setRandomStroke(ctx: ctx)
            }
            else
            {
                setRandomStroke2(ctx: ctx)
            }
        }
    }
    
    
    // NOTE: Carpets
    private func drawCarpet(ctx:CGContext)
    {
        let step:CGFloat = BackDimensionMax / CGFloat(Helper.randomBetween(min: Int(FactorLinesStepperMin), max: Int(FactorLinesStepperMax), includeMax: false))
        var carpets:[[CGPoint]] = []
        
        var i = BackRect.minX
        
        while i <= BackRect.maxX {
            carpets.append([CGPoint(x: i, y: BackRect.minY), CGPoint(x: i, y: BackRect.maxY)])
            i += step
        }
        
        var j = BackRect.minY
        
        while j <= BackRect.maxY {
            carpets.append([CGPoint(x: BackRect.minX, y: j), CGPoint(x: BackRect.maxX, y: j)])
            j += step
        }
        
        // NOTE: !!! RANDOM SHUFFLE POINTS
        carpets.shuffle()
        
        setRandomStroke2(ctx: ctx)
        setRandomLineWidth(ctx: ctx)
        
        let fullRandomize = Helper.fiftyFifty()
        let randomize1 = Helper.fiftyFifty()
        let randomize2 = Helper.fiftyFifty()
        let randomize3 = Helper.fiftyFifty()
        
        for carpetPair in carpets
        {
            if fullRandomize
            {
                carpetsRandomizations(ctx: ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3)
            }
            ctx.move(to: carpetPair[0])
            ctx.addLine(to: carpetPair[1])
            ctx.strokePath()
        }
    }
    
    // NOTE: Matrix
    private func drawMatrix(ctx:CGContext)
    {
        let step:CGFloat = BackDimensionMax / CGFloat(Helper.randomBetween(min: Int(FactorLinesStepperMin), max: Int(FactorLinesStepperMax), includeMax: false))
        var matrixStart:[CGPoint] = []
        var matrixEnd:[CGPoint] = []
        
        var i = BackRect.minX
        
        while i <= BackRect.maxX {
            matrixStart.append(CGPoint(x: i, y: BackRect.minY))
            matrixEnd.append(CGPoint(x: i, y: BackRect.maxY))
            i += step
        }
        
        var j = BackRect.minY
        
        while j <= BackRect.maxY {
            matrixStart.append(CGPoint(x: BackRect.minX, y: j))
            matrixEnd.append(CGPoint(x: BackRect.maxX, y: j))
            j += step
        }
        
        // NOTE: !!! RANDOM SHUFFLE POINTS
        matrixStart.shuffle()
        matrixEnd.shuffle()
        
        setRandomStroke2(ctx: ctx)
        setRandomLineWidth(ctx: ctx)
        
        let fullRandomize = Helper.fiftyFifty()
        let randomize1 = Helper.fiftyFifty()
        let randomize2 = Helper.fiftyFifty()
        let randomize3 = Helper.fiftyFifty()
        
        for i in 0..<matrixStart.count
        {
            if fullRandomize
            {
                carpetsRandomizations(ctx: ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3)
            }
            
            ctx.move(to: matrixStart[i])
            ctx.addLine(to: matrixEnd[i])
            ctx.strokePath()
        }
    }
    
    private func addRandomFinalMix(ctx:CGContext)
    {
        switch Helper.randomBetween(min: 0, max: 4, includeMax: true)
        {
        case 0:
            
            drawTriangles(ctx: ctx)
            
        case 1:
            
            drawCirclesOrSquaresOverlay(ctx: ctx)
            
        case 2:
            
            drawTriangles(ctx: ctx)
            drawCirclesOrSquaresOverlay(ctx: ctx)
            
        case 3:
            
            drawCirclesOrSquaresOverlay(ctx: ctx)
            drawTriangles(ctx: ctx)
            
        default:
            
            ()
            
        }
    }
    
    private func setupBackground()
    {
        UIGraphicsBeginImageContext(BackRect.size)
        let ctx = UIGraphicsGetCurrentContext()
        setRandomShadow(ctx: ctx!)
        Helper.getRandomColor().setFill()
        ctx?.fill(BackRect)
        
        switch Helper.randomBetween(min: 0, max: 4, includeMax: true)
        {
            
        case 0:
            
            drawMatrix(ctx: ctx!)
            addRandomFinalMix(ctx: ctx!)
            
        case 1:
            
            drawCarpet(ctx: ctx!)
            addRandomFinalMix(ctx: ctx!)
            
        case 2:
            
            drawSpace(ctx: ctx!)
            addRandomFinalMix(ctx: ctx!)
            
        case 3:
            
            drawBlackHole(ctx: ctx!)
            drawBlackHoleLayerOne(ctx: ctx!)
            
            if Helper.fiftyFifty()
            {
                drawTriangles(ctx: ctx!)
            }
            
        default:
            
            if Helper.fiftyFifty()
            {
                drawFirstLayerVariant(ctx: ctx!)
            }
            else
            {
                drawFirstLayer(ctx: ctx!)
            }
            
            if Helper.fiftyFifty()
            {
                drawTriangles(ctx: ctx!)
                drawCirclesOrSquaresOverlay(ctx: ctx!)
            }
            else
            {
                // Reversed
                drawCirclesOrSquaresOverlay(ctx: ctx!)
                drawTriangles(ctx: ctx!)
            }
            
        }
        
        SabilandTrippyBackground = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
}
