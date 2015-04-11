//
//  ViewController+AssociatedObject.m
//  AssociatedObject
//
//  Created by George Wu on 4/11/15.
//  Copyright © 2015 George Wu. All rights reserved.
//

#import "ViewController+AssociatedObject.h"
#import <objc/runtime.h>

@implementation ViewController (AssociatedObject)

// Tell the compiler that setter and getter would be implemented manually.
@dynamic associatedObject;

- (void)setAssociatedObject:(id)object {
	
	/*
	 Q: Where is the object been stored?
	 A: Mostly where is been created, NSString in static, NSMutableString in heap, for instance.
	 
	 Q: How it's been located?
	 A: By a two-step hash with the address of object and the `key`. `ObjectAssociationMap` keeps track of all the associations of an object, while `AssociationsHashMap` - a global singleton, keeps track of all the `ObjectAssociationMap`s of objects.
	 
	 Q: What's `objc_AssociationPolicy`?
	 A: Corresponds to property attribute:
		* OBJC_ASSOCIATION_ASSIGN ~ @property (assign)
		* OBJC_ASSOCIATION_RETAIN_NONATOMIC ~ @property (nonatomic, strong)
		* OBJC_ASSOCIATION_COPY_NONATOMIC ~ @property (nonatomic, copy)
		* OBJC_ASSOCIATION_RETAIN ~ @property (atomic, strong)
	 */
	
	// set the associated object via key
	objc_setAssociatedObject(self, @selector(associatedObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObject {
	
	// retrieve the associated object via key
	return objc_getAssociatedObject(self, _cmd);
}

@end
