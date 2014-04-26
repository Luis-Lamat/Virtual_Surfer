//
//  TechnoGameMyScene.m
//  Virtual Surfer
//
//  Created by Luis Alberto Lamadrid on 4/25/14.
//  Copyright (c) 2014 Luis Alberto Lamadrid. All rights reserved.
//

#import "TechnoGameMyScene.h"
#import "TechnoGamePortalNode.h"

@implementation TechnoGameMyScene {
     //FLAG TO KNOW IF OBJECT SHOULD MOVE
     BOOL shouldMove;
     BOOL shouldMoveRight;
     BOOL shouldMoveLeft;
     //flag for detecting when to move
     NSTimeInterval lastMoveTime;
     
     // Layered Nodes
     SKNode *_backgroundNode;
     SKNode *_midgroundNode;
     SKNode *_foregroundNode;
     SKNode *_hudNode;
     
     // Player
     //SKNode *_player;
     
     // Tap To Start node
     SKSpriteNode *_tapToStartNode;
}

//- (SKNode *) createPlayer
//{
//     SKNode *playerNode = [SKNode node];
//     [playerNode setPosition:CGPointMake(self.frame.size.width/2, 50.0)];
//     playerNode.name = @"Ship";
//     SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Ship"];
//     //sprite.name = @"Ship";
//     sprite.size   = CGSizeMake(60, 64);
//     [playerNode addChild:sprite];
//     
//     // 1
//     playerNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
//     // 2
//     playerNode.physicsBody.dynamic = NO;
//     // 3
//     //playerNode.physicsBody.allowsRotation = NO;
//     // 4
//     playerNode.physicsBody.restitution = 1.0f;
//     playerNode.physicsBody.friction = 0.0f;
//     playerNode.physicsBody.angularDamping = 0.0f;
//     playerNode.physicsBody.linearDamping = 0.0f;
//     
//     return playerNode;
//}

-(id)initWithSize:(CGSize)size {
     if (self = [super initWithSize:size]) {
          /* Setup your scene here */
          
          //Setting black background color
          self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
          _backgroundNode = [self createBackgroundNode];
          // Foreground
          _foregroundNode = [SKNode node];
          
          // HUD
          _hudNode = [SKNode node];
          
          // Tap to Start
          _tapToStartNode = [SKSpriteNode spriteNodeWithImageNamed:@"TapToStart"];
          _tapToStartNode.position = CGPointMake(160, 180.0f);

          //Creating ship
          SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"Ship"];
          ship.position = CGPointMake(self.frame.size.width/2, 50.0);
          ship.name     = @"Ship";
          ship.size     = CGSizeMake(60, 64);
          
          //Declaring a transparent color
          UIColor *transparent = [UIColor clearColor];
          
          
          // Add a portal
          TechnoGamePortalNode *portal = [self createPortalAtPosition:CGPointMake(160, 220)];
          
          //Making the movement control nodes (left & right)
          CGSize size_Left        = CGSizeMake(self.frame.size.width/2, self.frame.size.height);
          SKSpriteNode *left_Pad  = [SKSpriteNode spriteNodeWithColor:transparent size:size_Left];
          left_Pad.position       = CGPointMake(self.frame.size.width/4, self.frame.size.height/2);
          left_Pad.name           = @"Left";
          
          CGSize size_Right       = CGSizeMake(self.frame.size.width/2, self.frame.size.height);
          SKSpriteNode *right_Pad = [SKSpriteNode spriteNodeWithColor:transparent size:size_Right];
          right_Pad.position      = CGPointMake(3*(self.frame.size.width)/4, self.frame.size.height/2);
          right_Pad.name          = @"Right";
          
          [self addChild:_backgroundNode];
          [self addChild:_foregroundNode];
          [self addChild:_hudNode];
          //// Add the player
          //_player = [self createPlayer];
          //[_foregroundNode addChild:_player];
          [_foregroundNode addChild:portal];
          [self addChild:ship];
          [_hudNode addChild:_tapToStartNode];
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
     
     // 2
     // Remove the Tap to Start node
     [_tapToStartNode removeFromParent];
     
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

- (SKNode *) createBackgroundNode
{
     // 1
     // Create the node
     SKNode *backgroundNode = [SKNode node];
     
     // 2
     // Go through images until the entire background is built
     for (int nodeCount = 0; nodeCount < 20; nodeCount++) {
          // 3
          NSString *backgroundImageName = [NSString stringWithFormat:@"Background%02d", nodeCount+1];
          SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:backgroundImageName];
          // 4
          node.anchorPoint = CGPointMake(0.5f, 0.0f);
          node.position = CGPointMake(160.0f, nodeCount*64.0f);
          // 5
          [backgroundNode addChild:node];
     }
     
     // 6
     // Return the completed background node
     return backgroundNode;
}

- (TechnoGamePortalNode *) createPortalAtPosition:(CGPoint)position
{
     // 1
     TechnoGamePortalNode *node = [TechnoGamePortalNode node];
     [node setPosition:position];
     [node setName:@"NODE_PORTAL"];
     
     // 2
     SKSpriteNode *sprite;
     sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Star"];
     [node addChild:sprite];
     
     // 3
     node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
     
     // 4
     node.physicsBody.dynamic = NO;
     
     return node;
}

@end