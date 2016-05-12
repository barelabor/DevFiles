//
//  ChartView.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class ChartView: UIView {

    var graphPoints : [CGPoint] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        print(rect.height)
        // draw the line graph
        
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(context, CGLineCap.Round)
        
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor);
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextBeginPath(context);
        
        //Grid
        /*
        let grid : CGMutablePathRef = CGPathCreateMutable()
        for i in 1..<Int(rect.height / 29 + 1){
            CGPathMoveToPoint(grid, nil, 0, CGFloat(29 * i))
            CGPathAddLineToPoint(grid, nil, rect.width, CGFloat(29 * i));
        }
        
        for i in 1..<Int(rect.width / 29 + 1 ){
            CGPathMoveToPoint(grid, nil, CGFloat(29 * i), 0 )
            CGPathAddLineToPoint(grid, nil, CGFloat(29 * i), rect.height);
        }
        
        CGContextAddPath(context, grid);
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context,UIColor.lightGrayColor().CGColor);
        CGContextStrokePath(context)
         */
        
        // Сhart
        let сhart : CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(сhart, nil, -1, rect.height - 3 )
        CGPathAddLineToPoint(сhart, nil, rect.width/4 , rect.height - 3 );
        CGPathAddCurveToPoint(сhart, nil, rect.width/3 + 40, rect.height - 3, rect.width/2 - 20, 80, rect.width/2, 60 )
        CGPathAddCurveToPoint(сhart, nil, rect.width/2 + 20, 60, rect.width/2 + 40, rect.height - 10, rect.width/3*2+40, rect.height - 3 )
        CGPathAddLineToPoint(сhart, nil, rect.width + 1 , rect.height - 3 );
        CGPathAddLineToPoint(сhart, nil, rect.width + 1 , rect.height + 1  );
        CGPathAddLineToPoint(сhart, nil, -1 , rect.height + 1  );
        CGPathCloseSubpath(сhart);
        
        // Foreground Mountain stroking
        CGContextAddPath(context, сhart);
        CGContextSetLineWidth(context, 3);
        CGContextSetStrokeColorWithColor(context,UIColor.whiteColor().CGColor);
        CGContextStrokePath(context);
    }
}
