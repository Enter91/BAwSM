//
//  RecordedVideosViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordedVideosTableViewCell.h"
#import <SWRevealViewController.h>
@import AVFoundation;
@import MediaPlayer;
@import AssetsLibrary;
#import "RouteViewController.h"

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Kontroler zarządzający widokiem tabeli prezentującej nagrane filmy.
 */
@interface RecordedVideosViewController : UIViewController <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, RecordedVideosTableViewCellDelegate>

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Pasek nawigacyjny
 */
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Tabela prezentująca filmy nagrane aplikacją.
 */
@property (weak, nonatomic) IBOutlet UITableView *videosTableView;

/*!
 *  @Author Michał Czwarnowski
 *
 *  Widok, z którego został uruchomiony RecorderViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, weak) UIViewController *parentView;
@end
