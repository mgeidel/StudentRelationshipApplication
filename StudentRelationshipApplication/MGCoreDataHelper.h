//
//  MGCoreDataHelper.h
//  MGCoreDataHelper
//
//  Created by mac on 06.08.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface MGCoreDataHelper : NSObject

//Klassenmethode (+)
+ (NSString*) directoryForDatabaseFilename;
+ (NSString*) databaseFilename;

//getter
+ (NSManagedObjectContext*) managedObjectContext;

//Methode liefert ein Objekt zurück. es wird eine Klasse übergeben. der Content soll dann in managedObjectContext eingefügt werden
+ (id) insertManagedObjectOfClass: (Class) aClass inManagedObjectContext: (NSManagedObjectContext*) managedObjectContext;
//liefert yes o no
+ (BOOL) saveManagedObjectContext: (NSManagedObjectContext*) managedObjectContext;

+ (NSArray*) fetchEntitiesForClass: (Class) aClass withPredicate: (NSPredicate*) predicate inManagedObjectContext: (NSManagedObjectContext*) managedObjectContext;

+ (BOOL) performFetchOnFetchedResultsController: (NSFetchedResultsController*) fetchedResultsController;

@end
