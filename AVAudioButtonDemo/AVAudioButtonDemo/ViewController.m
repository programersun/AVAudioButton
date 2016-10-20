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
#import "AVAudioButtonConfigure.h"

@interface ViewController () <AVAudioButtonDelegate,AVAudioViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) AVAudioButton *AVAudioButton;
@property (nonatomic, strong) NSMutableArray *recorderArray;
@property (assign, nonatomic) NSInteger currentRow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 50)];
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
    
    [self.recorderArray addObject:[NSURL URLWithString:@"http://192.168.1.202:9002/fileAttachs/annex/10310/20161012150838.aac/20161012150838.aac"]];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recorderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static dispatch_once_t onceToken;
    if (self.tableView.contentSize.height >= self.tableView.frame.size.height) {
        dispatch_once(&onceToken, ^{
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height)];
        });
    }
    
    NSString *cellID = @"AVAudioPlayTableViewCell";
    AVAudioPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (indexPath.row % 2 == 0) {
        cell.audioView.playButton.playButtonType = AVAudioPlayButtonTypeLeft;
    } else {
        cell.audioView.playButton.playButtonType = AAVAudioPlayButtonTypeRight;
    }
    cell.audioView.delegate = self;
    
    cell.audioView.contentURL = self.recorderArray[indexPath.row];
    cell.audioView.tag = indexPath.row;
    cell.audioView.indexPath = indexPath;
    if (indexPath.row == _currentRow) {
        [cell.audioView startAnimating];
    } else {
        [cell.audioView stopAnimating];
    }
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        NSFileManager *fileManager = [[NSFileManager alloc]init];
//        
//        
//        if ([[NSString stringWithFormat:@"%@",self.recorderArray[indexPath.row]] hasPrefix:@"http"]) {
//            NSString *urlStr = [NSString stringWithFormat:@"%@",self.recorderArray[indexPath.row]];
//            NSRange range = [urlStr rangeOfString:@"/" options:NSBackwardsSearch];
//            NSString *fileName = [urlStr substringWithRange:NSMakeRange(range.location + 1, urlStr.length - range.location - 1)];
//            NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//            strUrl = [strUrl stringByAppendingPathComponent:@"download"];
//            strUrl = [strUrl stringByAppendingPathComponent:fileName];
//            [fileManager removeItemAtURL:[NSURL URLWithString:strUrl] error:nil];
//
//        } else {
//            [fileManager removeItemAtURL:self.recorderArray[indexPath.row] error:nil];
//        }
//
//        [self.recorderArray removeObjectAtIndex:indexPath.row];  //删除数组里的数据
//        
//        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    }
//}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - AVAudioButtonDelegate
- (void)successAVAudioButtonDelegate:(NSURL *)recorderUrl success:(BOOL)success{
    if (success) {
        _currentRow = -1;
        [self.recorderArray addObject:recorderUrl];
        [self.tableView reloadData];
        if (self.tableView.contentSize.height >= self.tableView.frame.size.height) {
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height)];
        }
    }
}

- (void)cancelAVAudioButtonDelegate {
    NSLog(@"cancel");
}

#pragma mark - AVAudioViewDelegate
- (void)audioViewDidStartPlaying:(AVAudioView *)audioView
{
    if (audioView.tag != _currentRow) {
        _currentRow = audioView.tag;
    } else {
        _currentRow = -1;
    }
}

- (void)audioViewDidEndPlaying:(AVAudioView *)audioView {
    _currentRow = -1;
    [self.tableView reloadData];
}

- (void)audioPlayBtnLongPass:(AVAudioView *)audioView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        if ([[NSString stringWithFormat:@"%@",self.recorderArray[audioView.tag]] hasPrefix:@"http"]) {
            NSString *urlStr = [NSString stringWithFormat:@"%@",self.recorderArray[audioView.tag]];
            NSRange range = [urlStr rangeOfString:@"/" options:NSBackwardsSearch];
            NSString *fileName = [urlStr substringWithRange:NSMakeRange(range.location + 1, urlStr.length - range.location - 1)];
            NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            strUrl = [strUrl stringByAppendingPathComponent:@"download"];
            strUrl = [strUrl stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtURL:[NSURL URLWithString:strUrl] error:nil];
        } else {
            [fileManager removeItemAtURL:self.recorderArray[audioView.tag] error:nil];
        }
        [self.recorderArray removeObjectAtIndex:audioView.tag];  //删除数组里的数据
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:audioView.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
