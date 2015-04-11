//
//  ViewController.m
//  AssociatedObject
//
//  Created by George Wu on 4/11/15.
//  Copyright © 2015 George Wu. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+AssociatedObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.associatedObject = @"I am officially associated.";
	
	NSLog(@"%@", self.associatedObject);
}

@end
