//
//  ViewController.m
//  AVAudioButtonDemo
//
//  Created by 孙瑞 on 16/10/14.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "AVAudioButton.h"
#import "AVAudioPlayTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "AVAudioView.h"

@interface ViewController () <AVAudioButtonDelegate,AVAudioViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) AVAudioButton *AVAudioButton;
@property (nonatomic, strong) NSMutableArray *recorderArray;
@property (nonatomic, strong) UITableView *tableView;
@property (retain, nonatomic) AVAudioPlayer *avPlay;
@property (assign, nonatomic) NSInteger currentRow;

@end

@implementation ViewController

- (NSMutableArray *)recorderArray {
    if (_recorderArray == nil) {
        _recorderArray = [NSMutableArray array];
    }
    return _recorderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.AVAudioButton = [[AVAudioButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 80, [UIScreen mainScreen].bounds.size.height - 50, 160, 40)];
    self.AVAudioButton.backgroundColor = [UIColor redColor];
    self.AVAudioButton.delegate = self;
    [self.view addSubview:self.AVAudioButton];
    
    [self loadDocumentFile];
    
    _currentRow = -1;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 50)];
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadDocumentFile {
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    strUrl = [strUrl stringByAppendingPathComponent:@"recorder"];
    NSURL *directorURL = [NSURL URLWithString:strUrl];
    if ([[NSFileManager defaultManager] fileExistsAtPath:strUrl]) {
        NSArray *key = [NSArray arrayWithObject:NSURLIsDirectoryKey];
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:directorURL includingPropertiesForKeys:key options:0 errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
            return YES;
        }];
        
        [self.recorderArray removeAllObjects];
        for (NSURL *url in enumerator) {
            NSError *error;
            NSNumber *isDirectory = nil;
            if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            }
            else if (![isDirectory boolValue])
            {
                [self.recorderArray addObject:url];  // 获取的音频存到数组
            }
        }
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recorderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height)];
    });
    NSString *cellID = @"AVAudioPlayTableViewCell";
    AVAudioPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AVAudioPlayTableViewCell alloc] init];
        [cell setRestorationIdentifier:@"AVAudioPlayTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row % 3 == 0) {
        cell.audioView.playButton.playButtonType = AVAudioPlayButtonTypeLeft;
    } else {
        cell.audioView.playButton.playButtonType = AAVAudioPlayButtonTypeRight;
    }

    cell.audioView.contentURL = self.recorderArray[indexPath.row];
    cell.audioView.tag = indexPath.row;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        [fileManager removeItemAtURL:self.recorderArray[indexPath.row] error:nil];
        
        [self.recorderArray removeObjectAtIndex:indexPath.row];  //删除数组里的数据
        
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.avPlay.playing) {
//        [self.avPlay stop];
////        return;
//    }
//
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorderArray[indexPath.row] error:nil];
//    self.avPlay = player;
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    NSError *err = nil;
//    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
//    [self.avPlay play];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

#pragma mark - AVAudioButtonDelegate
- (void)successAVAudioButtonDelegate:(NSURL *)recorderUrl success:(BOOL)success{
    if (success) {
        [self.recorderArray addObject:recorderUrl];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height)];
    }
}

- (void)cancelAVAudioButtonDelegate {
    NSLog(@"cancel");
}

- (void)audioViewDidStartPlaying:(AVAudioView *)audioView
{
    _currentRow = audioView.tag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
