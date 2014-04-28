//
//  VWWMasterViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWMasterViewController.h"
#import "VWWDetailViewController.h"
#import "VWWImagesViewController.h"
#import "VWWAlbumsViewController.h"
#import "VWWAccountViewController.h"

static NSString *VWWMasterViewControllerTitleKey = @"title";
static NSString *VWWMasterViewControllerViewControllerKey = @"viewController";
static NSString *VWWMasterViewControllerSegueKey = @"segue";

static NSString *VWWSegueMasterToImages = @"VWWSegueMasterToImages";
static NSString *VWWSegueMasterToAlbums = @"VWWSegueMasterToAlbums";
static NSString *VWWSegueMasterToAccount = @"VWWSegueMasterToAccount";

@interface VWWMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation VWWMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Imgur";
    
    [self addChildViewControllers];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:VWWSegueMasterToAlbums]){
        
    } else if([[segue identifier] isEqualToString:VWWSegueMasterToImages]){
        
    } else if([[segue identifier] isEqualToString:VWWSegueMasterToAccount]){
        
    }
}

#pragma mark Private methods


- (void)insertNewObject:(NSDictionary*)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


-(void)addChildViewControllers{

    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }

    
    VWWAlbumsViewController *albumsViewController = [[VWWAlbumsViewController alloc]init];
    NSDictionary *albums = @{VWWMasterViewControllerTitleKey : @"Albums",
                             VWWMasterViewControllerViewControllerKey : albumsViewController,
                             VWWMasterViewControllerSegueKey : VWWSegueMasterToAlbums};
    [_objects addObject:albums];

    VWWImagesViewController *imagesViewController = [[VWWImagesViewController alloc]init];
    NSDictionary *images = @{VWWMasterViewControllerTitleKey : @"Images",
                             VWWMasterViewControllerViewControllerKey : imagesViewController,
                             VWWMasterViewControllerSegueKey : VWWSegueMasterToImages};
    [_objects addObject:images];


    VWWAccountViewController *accountViewController = [[VWWAccountViewController alloc]init];
    NSDictionary *account = @{VWWMasterViewControllerTitleKey : @"Account",
                              VWWMasterViewControllerViewControllerKey : accountViewController,
                              VWWMasterViewControllerSegueKey : VWWSegueMasterToAccount};
    [_objects addObject:account];

}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = _objects[indexPath.row];
    NSString *title = object[VWWMasterViewControllerTitleKey];
    cell.textLabel.text = title;
    return cell;
}


#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *object = _objects[indexPath.row];
    NSString *segue = object[VWWMasterViewControllerSegueKey];
    [self performSegueWithIdentifier:segue sender:self];
}



@end
