//
//  MGTableViewController.m
//  StudentRelationshipApplication
//
//  Created by mac on 08.08.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import "MGTableViewController.h"

//Aufnahme eines privaten Interface, da UIBarButtonItems nach außen nicht sichtbar sein sollen
@interface MGTableViewController () <UISearchBarDelegate>
@property (nonatomic, strong) UIBarButtonItem *barButtonItemEdit;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemDone;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemCancel;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemSearch;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemAdd;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemDelete;
@property (nonatomic, strong) UISearchBar *searchBar;


@end

@implementation MGTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Barbuttonitems initialisieren
    //initWithBarButtonSystemItem:UIBarButtonSystemItemAdd Standardicon -> für Add verwenden. target:self -> Ziel ist der MGTableVieController
    self.barButtonItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(barButtonItemAddPressed:)];
    self.barButtonItemCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barButtonItemCancelPressed:)];
    self.barButtonItemDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(barButtonItemDeletePressed:)]; //Trash statt Delete (UIBarButtonSystemItem)
    self.barButtonItemEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(barButtonItemEditPressed:)];
    self.barButtonItemSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(barButtonItemSearchPressed:)];
    self.barButtonItemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(barButtonItemDonePressed:)];
    
    //Hier werden die RightBarButtonItems gesetzt
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.barButtonItemEdit, self.barButtonItemSearch, nil];
    
    //Hier wird die Toolbar aufgebaut (Hinzufügen, Löschen ... )
    //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] -> Spacer, der Deletbutton vom Addbutton trennt
    self.toolbarItems = [NSArray arrayWithObjects:self.barButtonItemDelete,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],self.barButtonItemAdd, nil];
    
    //Toolbar schwärzen und leicht transparent machen
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    //Aufbau der Searchbar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleBlackOpaque;
    self.searchBar.showsCancelButton = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //Speicher nach Beendigung freigeben
    self.barButtonItemAdd = nil;
    self.barButtonItemCancel = nil;
    self.barButtonItemDone = nil;
    self.barButtonItemSearch = nil;
    self.barButtonItemDelete = nil;
    self.barButtonItemEdit = nil;
    self.searchBar = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections. Ruft Methode fetchedResultsController aus StudentsTableVieController auf, in der Sektionen ausgelesen werden
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section. Ruft Methode fetchedResultsController aus StudentsTableVieController auf, in der Sektionen ausgelesen werden u liefert Anzahl der Zeilen in einer bestimmten Sektion
    return [[[self.fetchedResultsController sections] objectAtIndex:section ] numberOfObjects];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



#pragma mark - barButtonItems

//Implementierung des Editbuttons (was passiert nach drücken)
- (void)barButtonItemEditPressed: (id) sender
{
    //Toolbar animiert einblenden
    [self.navigationController setToolbarHidden:NO animated:YES];
    //Tableview in Editing-Status versetzen
    [self.tableView setEditing:YES animated:YES];
    //Rightbarbuttonitems setzen mit animierten Wechsel (Lupe und Done Button)
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.barButtonItemDone, self.barButtonItemSearch, nil] animated:YES];
    //Abbruchbutton setzen
    [self.navigationItem setLeftBarButtonItem:self.barButtonItemCancel animated:YES];
}

//Implementierung des Donebuttons (was passiert nach drücken)
- (void)barButtonItemDonePressed: (id) sender
{
    //Toolbar animiert ausblenden
    [self.navigationController setToolbarHidden:YES animated:YES];
    //Tableview in Normal-Status versetzen
    [self.tableView setEditing:NO animated:YES];
    //Rightbarbuttonitems setzen mit animierten Wechsel von Done zu Edit
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.barButtonItemEdit, self.barButtonItemSearch, nil] animated:YES];
    //Cancelbutton ausblenden
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

//Implementierung des Cancelbuttons (was passiert nach drücken)
- (void)barButtonItemCancelPressed: (id) sender
{
    //Toolbar animiert ausblenden
    [self.navigationController setToolbarHidden:YES animated:YES];
    //Tableview in Normal-Status versetzen
    [self.tableView setEditing:NO animated:YES];
    //Rightbarbuttonitems setzen mit animierten Wechsel von Done zu Edit
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.barButtonItemEdit, self.barButtonItemSearch, nil] animated:YES];
    //Cancelbutton ausblenden
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

//Implementierung des Addbuttons (was passiert nach drücken)
- (void)barButtonItemAddPressed: (id) sender
{
    
}

//Implementierung des Deletebuttons (was passiert nach drücken)
- (void)barButtonItemDeletePressed: (id) sender
{
    
}

//Implementierung des Searchbuttons (was passiert nach drücken)
- (void)barButtonItemSearchPressed: (id) sender
{
    //Prüfen, ob Searchbar schon da ist
    if(self.tableView.tableHeaderView == nil) {
        //Searchbar wird Bildschirm angepasst dargestellt
        [self.searchBar sizeToFit];
        //Searchbar im Header platzieren
        self.tableView.tableHeaderView = self.searchBar;
        //Tabelle auf der ersten Zeile dynamisch unterhalb der Searchbar platzieren,wenn Lupe geklickt wird
        [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:NO];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        //Eingabe aus Searchbar löschen. Zuzüglich wird vermieden, dass Tabelle nach oben springt wenn Searchbar wieder ausgeblendet wird
        self.searchBar.text = nil;
        //IOS5 Bug beheben: löschen der Eingabe auch nach Wechseln der Views
        //[self searchBar:self.searchBar textDidChange:nil];
        
        //Feststellen,ob Searchbar sichtbar (ist TableHeaderView sichtbar?)
        if (self.tableView.contentOffset.y <= self.tableView.tableHeaderView.frame.size.height) {
            //Searchbar animiert ausblenden
            [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:YES];
            //dispatch_after erzeugt ein Delay. Hier wird mit 0.5sek nach Ausblenden der Searchbar auch die Eingabetastatur entfernt
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.tableView.tableHeaderView = nil;
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            });
        } else {
            //Wenn Searchbar nicht sichtbar war (man ist zb in  Zeile 50), springt Tabelle beim Einblenden. Dies wird hier vermieden
            CGFloat yOffset = self.tableView.contentOffset.y - self.tableView.tableHeaderView.frame.size.height;
            self.tableView.tableHeaderView = nil;
            [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
        }
        
    }
}



#pragma mark - must be overloaded methods

//NSFetchedResultsControllerDelegate im header setzen!!!
- (NSFetchedResultsController *) fetchedResultsController
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}



#pragma mark - NSFetchedResultsController methods

/*
 Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
 subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
 with information from a managed object at the given index path in the fetched results controller.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
@end
