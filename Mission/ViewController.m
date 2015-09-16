//
//  ViewController.m
//  Mission
//
//  Created by 于　超 on 2015/09/16.
//  Copyright (c) 2015年 于　超. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    __weak IBOutlet UIView *calendarView;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *dayLabel;
    __weak IBOutlet UILabel *missionLabel;
    __weak IBOutlet UIButton *missionButton;
    __weak IBOutlet UIImageView *missionView;
    __weak IBOutlet UILabel *missionMessage;
    __weak IBOutlet UIButton *nextButton;
}

@property (nonatomic) NSDateComponents *comps;

- (IBAction)showMission:(id)sender;
- (IBAction)help:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)reset:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    missionButton.hidden = NO;
    missionView.hidden = YES;
    missionMessage.hidden = YES;
    nextButton.enabled = YES;
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    _comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    
    dateLabel.text = [NSString stringWithFormat:@"%ld.%ld", _comps.year, _comps.month];
    dayLabel.text = [NSString stringWithFormat:@"%ld", _comps.day];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showMission:(id)sender {
    missionButton.hidden = YES;
    missionView.hidden = NO;
    missionMessage.hidden = NO;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"misson" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *key = [NSString stringWithFormat:@"%ld%ld", _comps.month, _comps.day];
    NSString *message = [data objectForKey:key];
    missionMessage.text = message;
}

- (IBAction)help:(id)sender {
}

- (IBAction)next:(id)sender {
    // アニメーション定義開始
    [UIView beginAnimations: @"TransitionAnimation" context:nil];
    // トランジションアニメーションを設定
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView: calendarView cache:YES];
    [UIView setAnimationDuration:0.5];
    // 更新
    [self update];
    // アニメーションを開始
    [UIView commitAnimations];
}

- (IBAction)reset:(id)sender {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    _comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    
    dateLabel.text = [NSString stringWithFormat:@"%ld.%ld", _comps.year, _comps.month];
    dayLabel.text = [NSString stringWithFormat:@"%ld", _comps.day];
    
    missionButton.hidden = NO;
    missionView.hidden = YES;
    missionMessage.hidden = YES;
}

-(void) update {
    missionButton.hidden = NO;
    missionView.hidden = YES;
    missionMessage.hidden = YES;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date =  [calendar dateFromComponents:_comps];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSRange months = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:date];
    if ((int)_comps.day < days.length) {
        _comps.day ++;
    } else {
        if ((int)_comps.month < months.length) {
            _comps.month ++;
            _comps.day = 1;
        } else {
            _comps.year ++;
            _comps.month = 1;
            _comps.day = 1;
        }
    }
    dateLabel.text = [NSString stringWithFormat:@"%ld.%ld", _comps.year, _comps.month];
    dayLabel.text = [NSString stringWithFormat:@"%ld", _comps.day];
}

@end
