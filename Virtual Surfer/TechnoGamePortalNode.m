//
//  TechnoGamePortalNode.m
//  Virtual Surfer
//
//  Created by Enrique Marroquin on 4/26/14.
//  Copyright (c) 2014 Luis Alberto Lamadrid. All rights reserved.
//

#import "TechnoGamePortalNode.h"

@implementation TechnoGamePortalNode

- (BOOL) collisionWithShip:(SKNode *)ship
{
    // Remove this portal
    [self removeFromParent];
    
    // The HUD needs updating to show the new portals and score
    return YES;
}


@end
