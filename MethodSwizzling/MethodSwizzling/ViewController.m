//
//  ViewController.m
//  MethodSwizzling
//
//  Created by George Wu on 3/17/15.
//  Copyright © 2015 George Wu. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

/*
 `+load` is called upon adding the class to Objective-C runtime.
 
 Q: Why not `+initialize`?
 A: It can be in `+initialize` if implements in `dispatch_once`, only `+load` is a better choice because:
	* `+load` always execute and run only once, which reduces the possibility of race conditions.
	* Code `+load` won't be interferred by subclassing or adding category.
 */

// method swizzling should always be done in `+load`
+ (void)load {
	
	static dispatch_once_t onceToken;
	
	// swizzling shall only execute once
	dispatch_once(&onceToken, ^{
		
		Class class = [self class];
		
		/*
		 SEL(selector) represents the name of the method.
		 */
		
		// obtain SEL by string
		SEL originalSelector = @selector(viewWillAppear:);
		SEL swizzledSelector = @selector(gsw_viewWillAppear:);
		
		/*
		 Method is an struct containing SEL, IMP and types
		 IMP represents the implementation of a method, which really is a pointer to the first line of the method.
		 types represents the input variable types of the method.
		 */
		
		// obtain Method by SEL
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
		
		// Try to assign the swizzled method to the original selector.
		// This happens when current class doesn't have a implementation of the name by itself,
		//only inherits it from its superclass.
		BOOL didAddMethod =
		class_addMethod(class,
						originalSelector,
						method_getImplementation(swizzledMethod),
						method_getTypeEncoding(swizzledMethod));
		
		// If the former step succeeded, replace the original selector to swizzled selector.
		if (didAddMethod) {
			class_replaceMethod(class,
								swizzledSelector,
								method_getImplementation(originalMethod),
								method_getTypeEncoding(originalMethod));
		} else {
			
			// If former steps didn't happen,
			//simply let the two Methods switch their implementations.
			method_exchangeImplementations(originalMethod, swizzledMethod);
		}
	});
}

// This becomes the new implementation of `viewWillAppear`
- (void)gsw_viewWillAppear:(BOOL)animated {
	
	// This becomes the original `viewWillAppear` implementation now.
	[self gsw_viewWillAppear:animated];
	
	// This line will execute whenever viewWillAppear method is called on ViewController.
	NSLog(@"Swizzled viewWillAppear: %@", self);
}

@end
