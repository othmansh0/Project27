//
//  ViewController.swift
//  Project27
//
//  Created by othman shahrouri on 10/13/21.
//

/*
 
 
#like Core Animation, Core Graphics sits at a lower technical level than UIKit. This means it doesn't understand classes you know like UIColor and UIBezierPath, so you either need to use their counterparts (CGColor and CGPath respectively), or use helper methods from UIKit that convert between the two
 
#Core Graphics differentiates between creating a path and drawing a path. That is, you can add lines, squares and other shapes to a path as much as you want to, but none of it will do anything until you actually draw the path
 
 #Core Graphics is extremely fast: you can use it for updating drawing in real time, and you'll be very impressed. Core Graphics can work on a background thread – something that UIKit can't do – which means you can do complicated drawing without locking up your user interface
 
 In Core Graphics, a context is a canvas upon which we can draw, but it also stores information about how we want to draw (e.g., what should our line thickness be?) and information about the device we are drawing to.
 -----------------------------------------------------------------------------------------
 Although the UIGraphicsImageRendererContext does have a handful of methods we can call to do basic drawing, almost all the good stuff lies in its cgContext property that gives us the full power of Core Graphics.

 Let's take a look at the five new methods you'll need to use to draw our box:

 1.setFillColor() sets the fill color of our context, which is the color used on the insides of the rectangle we'll draw.
 
 2.setStrokeColor() sets the stroke color of our context, which is the color used on the line around the edge of the rectangle we'll draw.
 
 3.setLineWidth() adjusts the line width that will be used to stroke our rectangle. Note that the line is drawn centered on the edge of the rectangle, so a value of 10 will draw 5 points inside the rectangle and five points outside.
 
 4.addRect() adds a CGRect rectangle to the context's current path to be drawn.
 
 5.drawPath() draws the context's current path using the state you have configured.
 -----------------------------------------------------------------------------------------

 
*/
import CoreGraphics
import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
    }


    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        default:
            break
        }
    }
    
    func drawRectangle() {
        //object that draws images
        //a UIKit class, but it acts as a gateway to and from Core Graphics for UIKit-based apps
        //size 512x512, leaving it with default values for scale and opacity – that means it will be the same scale as the device (e.g. 2x for retina) and transparent
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
      /*
        Creating the renderer doesn’t actually start any rendering – that’s done in the image() method. This accepts a closure as its only parameter, which is code that should do all the drawing. It gets passed a single parameter that I’ve named ctx,which is a reference to a UIGraphicsImageRendererContext to draw to.This is a thin wrapper around another data type called CGContext, which is where the majority of drawing code lives.
         
         
         */
        
        let image = renderer.image { ctx in //takes actions as a closure
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            //since core Graphis is below uikit,so we need to use cgcolor
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            
            //addRect() adds a CGRect rectangle to the context's current path to be drawn
            //add rectangle to our path
            ctx.cgContext.addRect(rectangle)
            
            //fill the rect and the stroke as well
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    
    func drawCircle() {
        //object that draws images
        //a UIKit class, but it acts as a gateway to and from Core Graphics for UIKit-based apps
        //size 512x512, leaving it with default values for scale and opacity – that means it will be the same scale as the device (e.g. 2x for retina) and transparent
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
      /*
        Creating the renderer doesn’t actually start any rendering – that’s done in the image() method. This accepts a closure as its only parameter, which is code that should do all the drawing. It gets passed a single parameter that I’ve named ctx,which is a reference to a UIGraphicsImageRendererContext to draw to.This is a thin wrapper around another data type called CGContext, which is where the majority of drawing code lives.
         
         
         */
        
        let image = renderer.image { ctx in //takes actions as a closure
            //to avoid circle being clipped
            //The rectangle being used to define our circle is the same size as the whole context, meaning that it goes edge to edge – and thus the stroke gets clipped. To fix the problem, change the rectangle to this:
            
            //indents the circle by 5 points on all sides, so the stroke will now look uniform around the entire shape.
            //let rectangle = CGRect(x: 5, y: 5, width: 502, height: 502)//updated
            
            //better solution
            //That adds 5 points of inset on each edge, which has the same result
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            //since core Graphis is below uikit,so we need to use cgcolor
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            
            //addRect() adds a CGRect rectangle to the context's current path to be drawn
            //add rectangle to our path
            ctx.cgContext.addEllipse(in: rectangle)
            
            //fill the rect and the stroke as well
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
}

