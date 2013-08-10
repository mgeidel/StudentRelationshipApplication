//
//  MGCoreDataHelper.m
//  MGCoreDataHelper
//
//  Created by mac on 06.08.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import "MGCoreDataHelper.h"

@implementation MGCoreDataHelper

+ (NSString*) directoryForDatabaseFilename
{
    //hängt an den directorypfad noch das libary/private ...
    //in diesem verzeichnis ist dann die Datenbank zu finden
    return [NSHomeDirectory() stringByAppendingString:@"/Library/Private Documents"];
}

+ (NSString*) databaseFilename
{
   //Filename zurückgeben
    return @"database.sqlite";
}

+ (NSManagedObjectContext*) managedObjectContext
{
    //Gebrauchsmuster (Pattern):ist Objekt schon einmal initialisiert u bereits vorhanden,dann gib es zurück.
    static NSManagedObjectContext *managedObjectContext;
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    //Deglaration einer Errorvariable
    NSError *error;
    
    //Verzeichnis für die databasefile suchen u ggf erzeugen
    //Aufruf der Klassenmethode directoryForDatabase muss mit vorangestellter Klasse MGCoreDataHelper erfolgen
    //withIntermediateDirectories:YES -> es sollen alle verzeichnisse, die zum ziel führen mit erzeugt werden.falls pfad wächst.
    //attributes:nil -> keine zusätzl. Attribute mit übergeben
    //error:&error -> schreibt fehler in die variable error
    [[NSFileManager defaultManager] createDirectoryAtPath:[MGCoreDataHelper directoryForDatabaseFilename] withIntermediateDirectories:YES attributes:nil error:&error];
    
    //Fehlerausgabe und Abbruch, falls die ersten Schritte nicht funktioniert haben
    if (error) {
        NSLog(@"Fehler: %@", error.localizedDescription);
        return nil;
    }
    
    //Aufruf des Directory an Stelle des 2.@ -> [MGCoreDataHelper directoryForDatabaseFilename]
    //Aufruf des Filename an Stelle des 3.@ -> [MGCoreDataHelper databaseFilename]
    //path sieht dann ungefähr so aus: .../Library/Private Documents/database.sqlite
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MGCoreDataHelper directoryForDatabaseFilename], [MGCoreDataHelper databaseFilename]];

    NSURL *url = [NSURL fileURLWithPath:path];
    //NSLog(@"Daten gespeichert in: %@", url);

    //ManagedObjectModel von allen Modelldateien beziehen, die man im Projekt definiert hat (nicht bloß einer). in diesem Projekt gibt es nur eins (DataModel.xcdatamodeld)
    NSManagedObjectModel *managedModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedModel];
    
    if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        NSLog(@"Fehler: %@", error.localizedDescription);
        return nil;
    }
    
    NSManagedObjectContext *managedContext = [[NSManagedObjectContext alloc] init];
    managedContext.persistentStoreCoordinator = storeCoordinator;
        NSLog(@"url %@",url);
    return managedContext;

}

+ (id) insertManagedObjectOfClass: (Class) aClass inManagedObjectContext: (NSManagedObjectContext*) managedObjectContext
{
    //NSManagedObject sind die Objekte, die in der Datenbank gespeichert werden können. basiert auf einerNSEntityDescription (also einer Beschreibung des Objekts).
    //insertNewObjectForEntityForName benötigter Name der Entität wird über NSStringFromClass (aClass) bereitgestellt.letztendlich wird es dann in den managedObjectContext eingefügt
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass (aClass) inManagedObjectContext:managedObjectContext];
    return managedObject;
}

//hier wird das objekt in der DB persistiert
+ (BOOL) saveManagedObjectContext: (NSManagedObjectContext*) managedObjectContext
{
    NSError *error;
    if (! [managedObjectContext save:&error]) {
        NSLog(@"Fehler: %@", error.localizedDescription);
        return NO;
    }
    return YES;
}

//Zugriff auf Datenbank mit erzeugung eines arrays
+ (NSArray*) fetchEntitiesForClass: (Class) aClass withPredicate: (NSPredicate*) predicate inManagedObjectContext: (NSManagedObjectContext*) managedObjectContext
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Zuweisung,was gefetcht werden soll
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(aClass) inManagedObjectContext:managedObjectContext];
    //Zuweisung, um welche Entity es sich handelt
    fetchRequest.entity = entityDescription;
    //ist eine Art Suchfilter. bei predicate nil. wird alles gefunden
    fetchRequest.predicate = predicate;
    
    //Alle Items aus managedObjectContext
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Fehler: %@", error.localizedDescription);
        return nil;
    }
    return items;
}

+ (BOOL) performFetchOnFetchedResultsController: (NSFetchedResultsController*) fetchedResultsController
{
    //Wenn der performFetch des fetchedResultsController mit der Adresse &error nicht funktioniert hat, dann setze Fehler
    NSError *error;
    if(! [fetchedResultsController performFetch:&error] ) {
        NSLog(@"Fehler: %@",error.localizedDescription);
        return NO;
    }
    return YES;
}

@end
