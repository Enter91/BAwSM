//
//  RecordedVideosViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import "RecordedVideosViewController.h"

@interface RecordedVideosViewController ()

@end

@implementation RecordedVideosViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _videosArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_videosTableView setRowHeight:80.0];
    [_videosTableView setEstimatedRowHeight:80.0];
    
    [self listFileAtPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"singleVideoCell";
    RecordedVideosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleVideoCell"];
    
    if (cell == nil) {
        cell = [[RecordedVideosTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videosArray.count;
}

-(NSArray *)listFileAtPath
{
    int count;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path =[documentsDirectory stringByAppendingPathComponent:@"/iCarTools"];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

@end
