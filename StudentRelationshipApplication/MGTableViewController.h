//
//  MGTableViewController.h
//  StudentRelationshipApplication
//
//  Created by mac on 08.08.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MGTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

- (NSFetchedResultsController *) fetchedResultsController;

@end
