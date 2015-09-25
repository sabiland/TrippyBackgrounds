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
                swap(&self[index], &self[newIndex])
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
    
    class func randomBetween(min: Int, var max: Int, includeMax:Bool = false) -> Int
    {
        // NOTE: !!! SPECIAL CASE, THIS MUST BE THIS WAY - SO SELECTING RANDOM NUMBER OF 1-LENGTH ARRAY WOULD WORK!
        if min == max
        {
            return min
        }
        
        if max <= min
        {
            max = min + 1
        }
        
        if includeMax
        {
            max += 1
        }
        
        return randomBetweenMinMax(UInt32(min), max: UInt32(max))
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
        BackRect = CGRectMake(0.0, 0.0, BackDimensionMax, BackDimensionMax)
        setupBackground()
    }
    
    private func getDynamicAlphaSetting() -> CGFloat
    {
        return 0.1 + (Helper.random01CGFloat() * 0.3)
    }
    
    private func getDynamicRandomColor() -> UIColor
    {
        return Helper.getRandomColor(getDynamicAlphaSetting())
    }
    
    // NOTE: Harder alpha
    private func setRandomStroke2(ctx:CGContextRef)
    {
        Helper.getRandomColor(0.4 + (Helper.random01CGFloat() * 0.5)).setStroke()
        
        if Helper.fiftyFifty()
        {
            setRandomShadow(ctx)
        }
    }
    
    private func setRandomStroke(ctx:CGContextRef)
    {
        getDynamicRandomColor().setStroke()
        
        if Helper.fiftyFifty()
        {
            setRandomShadow(ctx)
        }
    }
    
    private func setRandomFill(ctx:CGContextRef)
    {
        getDynamicRandomColor().setFill()
        
        if Helper.fiftyFifty()
        {
            setRandomShadow(ctx)
        }
    }
    
    // NOTE: Lighter alpha
    private func setRandomFillLighter(ctx:CGContextRef)
    {
        Helper.getRandomColor(0.1 + (Helper.random01CGFloat() * 0.2)).setFill()
        
        if Helper.fiftyFifty()
        {
            setRandomShadow(ctx)
        }
    }
    
    // NOTE: Harder alpha
    private func setRandomFill2(ctx:CGContextRef)
    {
        Helper.getRandomColor(0.4 + (Helper.random01CGFloat() * 0.5)).setFill()
        
        if Helper.fiftyFifty()
        {
            setRandomShadow(ctx)
        }
    }
    
    private func setRandomLineWidth(ctx:CGContextRef)
    {
        CGContextSetLineWidth(ctx, 1.0 + (Helper.random01CGFloat() * FactorLineWidthMax))
    }
    
    private func setRandomShadow(ctx:CGContextRef)
    {
        CGContextSetShadow(ctx, CGSizeMake(Helper.random01CGFloat() * FactorShadowSettingMax, Helper.random01CGFloat() * FactorShadowSettingMax), Helper.random01CGFloat() * FactorShadowSettingMax)
    }
    
    // NOTE: First layer
    private func drawFirstLayer(ctx:CGContextRef)
    {
        let step:CGFloat = BackDimensionMax / CGFloat(Helper.randomBetween(Int(FactorLinesStepperMin), max: Int(FactorLinesStepperMax), includeMax: false))
        
        setRandomStroke2(ctx)
        setRandomLineWidth(ctx)
        for var i = BackRect.minX; i <= BackRect.maxX; i += step
        {
            CGContextMoveToPoint(ctx, i, BackRect.minY)
            CGContextAddLineToPoint(ctx, i, BackRect.maxY)
        }
        CGContextStrokePath(ctx)
        
        setRandomStroke2(ctx)
        setRandomLineWidth(ctx)
        for var j = BackRect.minY; j <= BackRect.maxY; j += step
        {
            CGContextMoveToPoint(ctx, BackRect.minX, j)
            CGContextAddLineToPoint(ctx, BackRect.maxX, j)
        }
        CGContextStrokePath(ctx)
    }
    
    private func drawSingleTriangle(ctx:CGContextRef, _ p1:CGPoint, _ p2:CGPoint, _ p3:CGPoint)
    {
        if Helper.fiftyFifty()
        {
            setRandomFill2(ctx)
        }
        else
        {
            setRandomFill(ctx)
        }
        
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, p1.x, p1.y)
        CGContextAddLineToPoint(ctx, p2.x, p2.y)
        CGContextAddLineToPoint(ctx, p3.x, p3.y)
        CGContextClosePath(ctx)
        CGContextFillPath(ctx)
        
        if Helper.fiftyFifty()
        {
            setRandomStroke2(ctx)
            setRandomLineWidth(ctx)
            
            CGContextBeginPath(ctx)
            CGContextMoveToPoint(ctx, p1.x, p1.y)
            CGContextAddLineToPoint(ctx, p2.x, p2.y)
            CGContextAddLineToPoint(ctx, p3.x, p3.y)
            CGContextClosePath(ctx)
            CGContextStrokePath(ctx)
        }
    }
    
    private func drawTriangles(ctx:CGContextRef)
    {
        drawSingleTriangle(
            ctx,
            CGPointMake(BackRect.minX, BackRect.minY),
            CGPointMake(BackRect.minX, BackRect.maxY),
            CGPointMake(BackRect.maxX, BackRect.maxY))
        
        if Helper.fiftyFifty()
        {
            // Another shifted
            drawSingleTriangle(
                ctx,
                CGPointMake(BackRect.maxX, BackRect.minY),
                CGPointMake(BackRect.minX, BackRect.maxY),
                CGPointMake(BackRect.maxX, BackRect.maxY))
        }
        
        if Helper.fiftyFifty()
        {
            // Another mixed
            drawSingleTriangle(
                ctx,
                CGPointMake(BackRect.minX, BackRect.minY),
                CGPointMake(BackRect.midX, BackRect.midY),
                CGPointMake(BackRect.maxX, BackRect.minY))
        }
    }
    
    private func blackHolesRandomizations(ctx:CGContextRef, randomize1:Bool, randomize2:Bool, randomize3:Bool, randomize4:Bool)
    {
        if randomize1
        {
            setRandomShadow(ctx)
        }
        
        if randomize2
        {
            setRandomLineWidth(ctx)
        }
        
        if randomize3
        {
            if Helper.fiftyFifty()
            {
                setRandomStroke(ctx)
            }
            else
            {
                setRandomStroke2(ctx)
            }
        }
        
        if randomize4
        {
            setRandomFillLighter(ctx)
        }
    }
    
    private func getPossibleBlackHoleOffsetForTranslate() -> CGFloat
    {
        return Helper.fiftyFiftyOnePlusMinus() * Helper.random01CGFloat() * FactorMaxPossibleblackHoleOffsetForTranslate
    }
    
    // Black hole variant
    private func drawBlackHoleLayerOne(ctx:CGContextRef)
    {
        let blackHolerFactor:CGFloat = 1.0 + (Helper.random01CGFloat() * 0.5)
        let properBlackHole = Helper.fiftyFifty()
        
        if Helper.fiftyFifty()
        {
            setRandomStroke(ctx)
        }
        else
        {
            setRandomStroke2(ctx)
        }
        
        setRandomFillLighter(ctx)
        setRandomLineWidth(ctx)
        
        let howMany = Helper.randomBetween(FactorBlackHoleMin, max: FactorBlackHoleMax, includeMax: false)
        var holes:[CGRect] = []
        var step:CGFloat = (BackDimensionMax / 2.0) / CGFloat(howMany)
        let centerOut = Helper.fiftyFifty()
        let outOrInFactor:CGFloat = centerOut ? -1.0 : 1.0
        var start:CGFloat = centerOut ? (BackDimensionMax / 2.0) : step
        
        for _ in 0..<howMany
        {
            holes.append(CGRectInset(BackRect, start, start))
            
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
            holes = holes.reverse()
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
                    blackHolesRandomizations(ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
                    
                    CGContextSaveGState(ctx)
                    CGContextTranslateCTM(ctx, getPossibleBlackHoleOffsetForTranslate(), getPossibleBlackHoleOffsetForTranslate())
                    CGContextFillEllipseInRect(ctx, h)
                    CGContextStrokeEllipseInRect(ctx, h)
                    CGContextRestoreGState(ctx)
                }
                
            }
            else
            {
                for h in holes
                {
                    blackHolesRandomizations(ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
                    
                    CGContextFillEllipseInRect(ctx, h)
                    CGContextStrokeEllipseInRect(ctx, h)
                }
            }
        }
        else
        {
            if Helper.fiftyFifty()
            {
                // NOTE: Squares rotated!
                let angleRotate:CGFloat = (2.0 * CGFloat(M_PI)) / CGFloat(holes.count)
                let centerBack = CGPointMake(BackRect.midX, BackRect.midY)
                
                CGContextSaveGState(ctx)
                CGContextTranslateCTM(ctx, centerBack.x, centerBack.y)
                
                for h in holes
                {
                    blackHolesRandomizations(ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
                    
                    let r = CGRectMake(h.minX - centerBack.x, h.minY - centerBack.y, h.width, h.height)
                    CGContextFillRect(ctx, r)
                    CGContextStrokeRect(ctx, r)
                    CGContextRotateCTM(ctx, angleRotate)
                }
                
                CGContextRestoreGState(ctx)
            }
            else
            {
                for h in holes
                {
                    blackHolesRandomizations(ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
                    
                    CGContextFillRect(ctx, h)
                    CGContextStrokeRect(ctx, h)
                }
            }
        }
    }
    
    private func drawBlackHole(ctx:CGContextRef)
    {
        let angle:CGFloat = CGFloat((M_PI * 2.0)) / CGFloat(Helper.randomBetween(FactorBlackHoleMin, max: FactorBlackHoleMax, includeMax: false))
        let randomize = Helper.fiftyFifty()
        let randomize2 = Helper.fiftyFifty()
        
        if Helper.fiftyFifty()
        {
            setRandomStroke(ctx)
        }
        else
        {
            setRandomStroke2(ctx)
        }
        setRandomLineWidth(ctx)
        
        let centerBack = CGPointMake(BackRect.midX, BackRect.midY)
        let howLong:CGFloat = CGFloat(M_PI) * 2.0
        var start:CGFloat = 0.0
        
        CGContextSaveGState(ctx)
        CGContextTranslateCTM(ctx, centerBack.x, centerBack.y)
        
        let startPoint = CGPointMake(BackRect.minX - centerBack.x, BackRect.minY - centerBack.y)
        let endPoint = CGPointMake(BackRect.maxX - centerBack.x, BackRect.maxY - centerBack.y)
        
        while start <= howLong
        {
            if randomize
            {
                setRandomShadow(ctx)
            }
            
            if randomize2
            {
                setRandomLineWidth(ctx)
            }
            
            CGContextRotateCTM(ctx, angle)
            CGContextBeginPath(ctx)
            CGContextMoveToPoint(ctx, startPoint.x, startPoint.y)
            CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y)
            CGContextStrokePath(ctx)
            start += angle
        }
        CGContextRestoreGState(ctx)
    }
    
    // NOTE: First layer variant
    private func drawFirstLayerVariant(ctx:CGContextRef)
    {
        let angle:CGFloat = CGFloat((M_PI * 2.0)) / CGFloat(Helper.randomBetween(FactorLinesAnglesMin, max: FactorLinesAnglesMax, includeMax: false))
        let randomize = Helper.fiftyFifty()
        let randomize2 = Helper.fiftyFifty()
        
        if Helper.fiftyFifty()
        {
            setRandomStroke(ctx)
        }
        else
        {
            setRandomStroke2(ctx)
        }
        setRandomLineWidth(ctx)
        
        let centerBack = CGPointMake(BackRect.midX, BackRect.midY)
        let howLong:CGFloat = CGFloat(M_PI) * 2.0
        var start:CGFloat = 0.0
        
        CGContextSaveGState(ctx)
        CGContextTranslateCTM(ctx, centerBack.x, centerBack.y)
        
        let startPoint = CGPointMake(BackRect.minX - centerBack.x, BackRect.minY - centerBack.y)
        let endPoint = CGPointMake(BackRect.maxX - centerBack.x, BackRect.maxY - centerBack.y)
        
        while start <= howLong
        {
            if randomize
            {
                setRandomShadow(ctx)
            }
            
            if randomize2
            {
                setRandomLineWidth(ctx)
            }
            
            CGContextRotateCTM(ctx, angle)
            CGContextBeginPath(ctx)
            CGContextMoveToPoint(ctx, startPoint.x, startPoint.y)
            CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y)
            CGContextStrokePath(ctx)
            start += angle
        }
        
        CGContextRestoreGState(ctx)
    }
    
    private func drawCirclesOrSquaresOverlay(ctx:CGContextRef)
    {
        let circles = Helper.fiftyFifty()
        
        for _ in 0..<Helper.randomBetween(1, max: FactorInsidersOverlays, includeMax: true)
        {
            if Helper.fiftyFifty()
            {
                setRandomStroke(ctx)
            }
            else
            {
                setRandomStroke2(ctx)
            }
            
            setRandomLineWidth(ctx)
            setRandomFill(ctx)
            let inset:CGFloat = (BackRect.width / 2.1) - (Helper.random01CGFloat() * (BackRect.width / 5.0))
            
            let r = CGRectInset(BackRect, inset, inset)
            
            if circles
            {
                CGContextFillEllipseInRect(ctx, r)
                CGContextStrokeEllipseInRect(ctx, r)
            }
            else
            {
                CGContextFillRect(ctx, r)
                CGContextStrokeRect(ctx, r)
            }
        }
    }
    
    private func drawFullRectLayer(ctx:CGContextRef)
    {
        setRandomFill(ctx)
        CGContextFillRect(ctx, BackRect)
    }
    
    private func drawSpace(ctx:CGContextRef)
    {
        let angle:CGFloat = CGFloat((M_PI * 2.0)) / CGFloat(Helper.randomBetween(FactorBlackHoleMin2, max: FactorBlackHoleMax2, includeMax: false))
        
        if Helper.fiftyFifty()
        {
            setRandomStroke(ctx)
        }
        else
        {
            setRandomStroke2(ctx)
        }
        
        setRandomFillLighter(ctx)
        setRandomLineWidth(ctx)
        
        let centerBack = CGPointMake(BackRect.midX, BackRect.midY)
        let howLong:CGFloat = CGFloat(M_PI) * 2.0
        var start:CGFloat = 0.0
        
        CGContextSaveGState(ctx)
        CGContextTranslateCTM(ctx, centerBack.x, centerBack.y)
        
        let startPoint = CGPointMake(BackRect.minX - centerBack.x, BackRect.minY - centerBack.y)
        let endPoint = CGPointMake(BackRect.maxX - centerBack.x, BackRect.maxY - centerBack.y)
        let controlPointX:CGFloat = BackRect.minX + (Helper.random01CGFloat() * BackRect.width)
        let controlPointY:CGFloat = BackRect.minY + (Helper.random01CGFloat() * BackRect.height)
        let controlPoint = CGPointMake(controlPointX - centerBack.x, controlPointY - centerBack.y)
        
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
                blackHolesRandomizations(ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
            }
            
            CGContextRotateCTM(ctx, angle)
            CGContextBeginPath(ctx)
            CGContextMoveToPoint(ctx, startPoint.x, startPoint.y)
            CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y)
            
            if drawFillStroke
            {
                CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
            }
            else
            {
                CGContextStrokePath(ctx)
            }
            
            start += angle
        }
        
        fullRandomize = Helper.fiftyFifty()
        drawFillStroke = !drawFillStroke
        start = 0.0
        
        let megaCurves = Helper.fiftyFifty()
        let megaMiddlePoint = CGPointMake(centerBack.x - centerBack.x, centerBack.y - centerBack.y)
        let controlPointX2:CGFloat = BackRect.minX + (Helper.random01CGFloat() * BackRect.width)
        let controlPointY2:CGFloat = BackRect.minY + (Helper.random01CGFloat() * BackRect.height)
        let controlPoint2 = CGPointMake(controlPointX2 - centerBack.x, controlPointY2 - centerBack.y)
        
        while start <= howLong
        {
            if fullRandomize
            {
                blackHolesRandomizations(ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3, randomize4: randomize4)
            }
            
            CGContextRotateCTM(ctx, angle)
            CGContextBeginPath(ctx)
            
            if megaCurves
            {
                CGContextMoveToPoint(ctx, startPoint.x, startPoint.y)
                CGContextAddQuadCurveToPoint(ctx, controlPoint.x, controlPoint.y, megaMiddlePoint.x, megaMiddlePoint.y)
                CGContextAddQuadCurveToPoint(ctx, controlPoint2.x, controlPoint2.y, endPoint.x, endPoint.y)
            }
            else
            {
                CGContextMoveToPoint(ctx, startPoint.x, startPoint.y)
                CGContextAddQuadCurveToPoint(ctx, controlPoint.x, controlPoint.y, endPoint.x, endPoint.y)
            }
            
            if drawFillStroke
            {
                CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
            }
            else
            {
                CGContextStrokePath(ctx)
            }
            
            start += angle
        }
        CGContextRestoreGState(ctx)
    }
    
    private func carpetsRandomizations(ctx:CGContextRef, randomize1:Bool, randomize2:Bool, randomize3:Bool)
    {
        if randomize1
        {
            setRandomShadow(ctx)
        }
        
        if randomize2
        {
            setRandomLineWidth(ctx)
        }
        
        if randomize3
        {
            if Helper.fiftyFifty()
            {
                setRandomStroke(ctx)
            }
            else
            {
                setRandomStroke2(ctx)
            }
        }
    }
    
    
    // NOTE: Carpets
    private func drawCarpet(ctx:CGContextRef)
    {
        let step:CGFloat = BackDimensionMax / CGFloat(Helper.randomBetween(Int(FactorLinesStepperMin), max: Int(FactorLinesStepperMax), includeMax: false))
        var carpets:[[CGPoint]] = []
        
        for var i = BackRect.minX; i <= BackRect.maxX; i += step
        {
            carpets.append([CGPointMake(i, BackRect.minY), CGPointMake(i, BackRect.maxY)])
        }
        
        for var j = BackRect.minY; j <= BackRect.maxY; j += step
        {
            carpets.append([CGPointMake(BackRect.minX, j), CGPointMake(BackRect.maxX, j)])
        }
        
        // NOTE: !!! RANDOM SHUFFLE POINTS
        carpets.shuffle()
        
        setRandomStroke2(ctx)
        setRandomLineWidth(ctx)
        
        let fullRandomize = Helper.fiftyFifty()
        let randomize1 = Helper.fiftyFifty()
        let randomize2 = Helper.fiftyFifty()
        let randomize3 = Helper.fiftyFifty()
        
        for carpetPair in carpets
        {
            if fullRandomize
            {
                carpetsRandomizations(ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3)
            }
            
            CGContextMoveToPoint(ctx, carpetPair[0].x, carpetPair[0].y)
            CGContextAddLineToPoint(ctx, carpetPair[1].x, carpetPair[1].y)
            CGContextStrokePath(ctx)
        }
    }
    
    // NOTE: Matrix
    private func drawMatrix(ctx:CGContextRef)
    {
        let step:CGFloat = BackDimensionMax / CGFloat(Helper.randomBetween(Int(FactorLinesStepperMin), max: Int(FactorLinesStepperMax), includeMax: false))
        var matrixStart:[CGPoint] = []
        var matrixEnd:[CGPoint] = []
        
        for var i = BackRect.minX; i <= BackRect.maxX; i += step
        {
            matrixStart.append(CGPointMake(i, BackRect.minY))
            matrixEnd.append(CGPointMake(i, BackRect.maxY))
        }
        
        for var j = BackRect.minY; j <= BackRect.maxY; j += step
        {
            matrixStart.append(CGPointMake(BackRect.minX, j))
            matrixEnd.append(CGPointMake(BackRect.maxX, j))
        }
        
        // NOTE: !!! RANDOM SHUFFLE POINTS
        matrixStart.shuffle()
        matrixEnd.shuffle()
        
        setRandomStroke2(ctx)
        setRandomLineWidth(ctx)
        
        let fullRandomize = Helper.fiftyFifty()
        let randomize1 = Helper.fiftyFifty()
        let randomize2 = Helper.fiftyFifty()
        let randomize3 = Helper.fiftyFifty()
        
        for i in 0..<matrixStart.count
        {
            if fullRandomize
            {
                carpetsRandomizations(ctx, randomize1: randomize1, randomize2: randomize2, randomize3: randomize3)
            }
            
            CGContextMoveToPoint(ctx, matrixStart[i].x, matrixStart[i].y)
            CGContextAddLineToPoint(ctx, matrixEnd[i].x, matrixEnd[i].y)
            CGContextStrokePath(ctx)
        }
    }
    
    private func addRandomFinalMix(ctx:CGContextRef)
    {
        switch Helper.randomBetween(0, max: 4, includeMax: true)
        {
        case 0:
            
            drawTriangles(ctx)
            
        case 1:
            
            drawCirclesOrSquaresOverlay(ctx)
            
        case 2:
            
            drawTriangles(ctx)
            drawCirclesOrSquaresOverlay(ctx)
            
        case 3:
            
            drawCirclesOrSquaresOverlay(ctx)
            drawTriangles(ctx)
            
        default:
            
            ()
            
        }
    }
    
    private func setupBackground()
    {
        UIGraphicsBeginImageContext(BackRect.size)
        let ctx = UIGraphicsGetCurrentContext()
        setRandomShadow(ctx!)
        Helper.getRandomColor().setFill()
        CGContextFillRect(ctx, BackRect)
        
        switch Helper.randomBetween(0, max: 4, includeMax: true)
        {
            
        case 0:
            
            drawMatrix(ctx!)
            addRandomFinalMix(ctx!)
            
        case 1:
            
            drawCarpet(ctx!)
            addRandomFinalMix(ctx!)
            
        case 2:
            
            drawSpace(ctx!)
            addRandomFinalMix(ctx!)
            
        case 3:
            
            drawBlackHole(ctx!)
            drawBlackHoleLayerOne(ctx!)
            
            if Helper.fiftyFifty()
            {
                drawTriangles(ctx!)
            }
            
        default:
            
            if Helper.fiftyFifty()
            {
                drawFirstLayerVariant(ctx!)
            }
            else
            {
                drawFirstLayer(ctx!)
            }
            
            if Helper.fiftyFifty()
            {
                drawTriangles(ctx!)
                drawCirclesOrSquaresOverlay(ctx!)
            }
            else
            {
                // Reversed
                drawCirclesOrSquaresOverlay(ctx!)
                drawTriangles(ctx!)
            }
            
        }
        
        SabilandTrippyBackground = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
}
