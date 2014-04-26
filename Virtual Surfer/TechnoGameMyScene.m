//
//  TechnoGameMyScene.m
//  Virtual Surfer
//
//  Created by Luis Alberto Lamadrid on 4/25/14.
//  Copyright (c) 2014 Luis Alberto Lamadrid. All rights reserved.
//

#import "TechnoGameMyScene.h"

@implementation TechnoGameMyScene {
    //FLAG TO KNOW IF OBJECT SHOULD MOVE
    BOOL shouldMove;
    BOOL shouldMoveRight;
    BOOL shouldMoveLeft;
    //flag for detecting when to move
    NSTimeInterval lastMoveTime;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //Setting black background color
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        //Creating ship
        SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"Ship"];
        ship.position = CGPointMake(self.frame.size.width/2, 50.0);
        ship.name     = @"Ship";
        ship.size     = CGSizeMake(60, 64);
        
        //Declaring a transparent color
        UIColor *transparent = [UIColor clearColor];
        
        //Making the movement control nodes (left & right)
        CGSize size_Left        = CGSizeMake(self.frame.size.width/2, self.frame.size.height);
        SKSpriteNode *left_Pad  = [SKSpriteNode spriteNodeWithColor:transparent size:size_Left];
        left_Pad.position       = CGPointMake(self.frame.size.width/4, self.frame.size.height/2);
        left_Pad.name           = @"Left";
        
        CGSize size_Right       = CGSizeMake(self.frame.size.width/2, self.frame.size.height);
        SKSpriteNode *right_Pad = [SKSpriteNode spriteNodeWithColor:transparent size:size_Right];
        right_Pad.position      = CGPointMake(3*(self.frame.size.width)/4, self.frame.size.height/2);
        right_Pad.name          = @"Right";
        
        [self addChild:ship];
        [self addChild:left_Pad];
        [self addChild:right_Pad];
    }
    return self;
}

-(void)selectNodeForTouch:(CGPoint)touchLocation{
    //Checks touched control (left or right)
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    SKSpriteNode *ship        = (SKSpriteNode *)[self childNodeWithName:@"Ship"];
    
    if ([touchedNode.name isEqualToString:@"Left"]) {
        shouldMoveLeft = YES;
        SKAction *tilt_Left = [SKAction rotateByAngle:0.4 duration:0.2];
        [ship runAction:tilt_Left];
    }
    else if ([touchedNode.name isEqualToString:@"Right"]){
        shouldMoveRight = YES;
        SKAction *tilt_Right = [SKAction rotateByAngle:-0.4 duration:0.2];
        [ship runAction:tilt_Right];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    lastMoveTime = HUGE_VAL;
    for (UITouch *touch in touches) {
        shouldMove = YES;
        UITouch *touch = [touches anyObject];
        CGPoint positionInScene = [touch locationInNode:self];
        [self selectNodeForTouch:positionInScene];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    SKSpriteNode *ship        = (SKSpriteNode *)[self childNodeWithName:@"Ship"];
    shouldMove = NO;
    shouldMoveLeft = NO;
    shouldMoveRight = NO;
    
    //resets the rotation of the ship to the front
    if (ship.zRotation>0) {
        SKAction *tilt_Right = [SKAction rotateByAngle:-0.4 duration:0.2];
        [ship runAction:tilt_Right];
    }
    else {
        SKAction *tilt_Left = [SKAction rotateByAngle:0.4 duration:0.2];
        [ship runAction:tilt_Left];
    }
}

static CGFloat kSpriteVelocity = 170;

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    SKSpriteNode *ship        = (SKSpriteNode *)[self childNodeWithName:@"Ship"];
    
    NSTimeInterval elapsed = currentTime - lastMoveTime;
    lastMoveTime = currentTime;
    if (elapsed > 0 && shouldMove) {
        CGFloat offset = kSpriteVelocity * elapsed;
        CGPoint position = ship.position;
        if (shouldMoveRight && ship.position.x < self.frame.size.width-30) {
            position.x += offset;
        }
        else if (shouldMoveLeft && ship.position.x > 30){
            position.x -= offset;
        }
        ship.position = position;
    }
    
    //SKAction *recover_Axis = [SKAction rotateByAngle:0.3 duration:0.2];
    //[ship runAction:recover_Axis];
}

/*
 -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 
 SKNode *player = [self childNodeWithName:@"player"];
 
 UITouch *touch = [touches anyObject];
 CGPoint positionInScene = [touch locationInNode:self];
 
 // Determine speed
 int minDuration = 2.0;
 int maxDuration = 4.0;
 int rangeDuration = maxDuration - minDuration;
 int actualDuration = (arc4random() % rangeDuration) + minDuration;
 
 // Create the actions
 SKAction * actionMove = [SKAction moveTo:CGPointMake(player.position.x, 50.0);
 duration:1;]
 [player runAction:actionMove];
 
 }*/

@end