//
//  TechnoGameGameObjectNode.m
//  Virtual Surfer
//
//  Created by Enrique Marroquin on 4/26/14.
//  Copyright (c) 2014 Luis Alberto Lamadrid. All rights reserved.
//

#import "TechnoGameGameObjectNode.h"

@implementation TechnoGameGameObjectNode

- (BOOL) collisionWithShip:(SKSpriteNode *)ship
{
    return NO;
}

- (void) checkNodeRemoval:(CGFloat)shipY
{
    if (shipY > self.position.y + 300.0f) {
        [self removeFromParent];
    }
}

@end
