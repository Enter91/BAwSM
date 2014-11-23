//
//  TutorialViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TutorialViewControllerDelegate <NSObject>

- (void)didEndTutorial;

@end

@interface TutorialViewController : UIViewController <UINavigationControllerDelegate>

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *iPhoneImageView;

@property (strong, nonatomic) UILabel *permissionTitle;
@property (strong, nonatomic) UILabel *permissionDescription;
@property (strong, nonatomic) UIButton *permissionButton;

@property (nonatomic, assign) id delegate;
@end
