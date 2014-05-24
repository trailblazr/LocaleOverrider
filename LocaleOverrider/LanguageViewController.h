//
//  LanguageViewController.h
//  LocaleOverrider
//
//  Created by Lincoln Six Echo on 24.05.14.
//  Copyright (c) 2014 appdoctors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LanguageViewController : UIViewController {

    IBOutlet UISegmentedControl* languageSegementedControl;
    IBOutlet UITextView* loremIpsumTextView;
    IBOutlet UIImageView* localeImage;
    IBOutlet UILabel* warningLabel;
}

@property( nonatomic, retain ) UISegmentedControl* languageSegementedControl;
@property( nonatomic, retain ) UITextView* loremIpsumTextView;
@property( nonatomic, retain ) UIImageView* localeImage;
@property( nonatomic, retain ) UILabel* warningLabel;


@end
