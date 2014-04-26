//
//  TechnoGameMyScene.m
//  Virtual Surfer
//
//  Created by Luis Alberto Lamadrid on 4/25/14.
//  Copyright (c) 2014 Luis Alberto Lamadrid. All rights reserved.
//

#import "TechnoGameMyScene.h"

@implementation TechnoGameMyScene

int score = 0;

-(void) createShip {
    
    if (score == 20) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"20!"
                                                        message:@"awesome"
                                                       delegate:nil
                                              cancelButtonTitle:@"continue"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    SKSpriteNode *ship = [SKSpriteNode  spriteNodeWithImageNamed:@"Ship"];
    
    //Creates a random ship position
    int maxX = CGRectGetMaxX(self.frame);
    float ranX = (arc4random()%maxX) + 1;
    
    int maxY = CGRectGetMaxY(self.frame);
    float ranY = (arc4random()%maxY) + 1;
    
    ship.position = CGPointMake(ranX, ranY);
    ship.size     = CGSizeMake(80, 52);
    ship.name     = @"Ship";
    
    [self addChild:ship];
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1.0];
        
        //Create our score label
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"ArialRoundedMTBold"];
        label.fontSize = 48;
        label.text = @"0";
        label.position = CGPointMake(CGRectGetMidX(self.frame), 40);
        label.color = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        label.name = @"scoreLabel";
        
        [self addChild:label];
        
        [self createShip];
    }
    return self;
}

-(void)selectNodeForTouch:(CGPoint)touchLocation {
    //Checks if a ship was touched
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    if ([[touchedNode name] isEqualToString:@"Ship"]) {
        SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:@"scoreLabel"];
        score++;
        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
        
        SKSpriteNode *ship = (SKSpriteNode *)[self childNodeWithName:@"Ship"];
        ship.name = @"DisabledShip";
        
        SKAction *grow =  [SKAction scaleTo:1.2 duration:0.1];
        SKAction *shrink = [SKAction scaleTo:0 duration:0.07];
        SKAction *removeNode = [SKAction removeFromParent];
        SKAction *seq = [SKAction sequence:@[grow, shrink, removeNode]];
        
        [ship runAction: seq];
        [self createShip];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        //CGPoint location = [touch locationInNode:self];
        UITouch *touch = [touches anyObject];
        CGPoint positionInScene = [touch locationInNode:self];
        [self selectNodeForTouch:positionInScene];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
