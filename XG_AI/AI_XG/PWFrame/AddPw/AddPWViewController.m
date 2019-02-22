//
//  AddPWViewController.m
//  AI_XG
//
//  Created by jrweid on 2018/6/4.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "AddPWViewController.h"
#import "AddPWView.h"
#import "AddPWInfo.h"
#import "PassWordInfo.h"
#import "UIImage+common.h"
#import "XMGProgressView.h"
#import "XMGWebViewController.h"
#import "photoMsgViewController.h"

#define ORIGINAL_MAX_WIDTH 640

@interface AddPWViewController () <AddPWViewDelegate, XMGActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, photoMsgViewControllerDelegate>
{
    AddPWView * _selfView;
    NSArray   * _dataArray;
}

@property (nonatomic, strong) NSDateFormatter * formatter;

@end

@implementation AddPWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self addSubViews];
}

- (void)setNavigation
{
    self.title = self.info.titleName ?: @"新增";
    
    if (self.info)
    {
        [self setBackItem];
        
        UIBarButtonItem * update = [[UIBarButtonItem alloc] initWithTitle:@"更新" style:0 target:self action:@selector(saveCurrentContentWithUpdate:)];
        self.navigationItem.rightBarButtonItem = update;
    }
    else
    {
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(giveUpToAddPW)];
        self.navigationItem.leftBarButtonItem = left;

        UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:0 target:self action:@selector(saveCurrentContentWithUpdate:)];
        self.navigationItem.rightBarButtonItem = right;
    }
}

- (void)addSubViews
{
    AddPWView * selfView = [[AddPWView alloc] init];
    selfView.delegate = self;
    self.view = _selfView = selfView;
    
    NSArray * titleArray = @[@[@"标题：", @"网址：", @"账户：", @"密码："], @[@"备注："]];
    NSArray * inputArray = nil;
    if (self.info) {
        inputArray = @[@[self.info.titleName, self.info.webSite, self.info.account, self.info.passWord], @[self.info.beiZhu]];
    }
    NSMutableArray * dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        NSArray * section = titleArray[i];
        NSMutableArray * sectionArray = [NSMutableArray array];
        for (NSInteger j = 0; j < section.count; j++) {
            AddPWInfo * info = [[AddPWInfo alloc] init];
            info.editTime = self.info.createTime;
            info.isEdited = self.info.isEdited;
            info.leftTitle = section[j];
            info.titlePlace = [NSString stringWithFormat:@"%@信息~_~", [info.leftTitle substringToIndex:2]];
            info.titleInput = inputArray ? inputArray[i][j] : nil;
            info.imageData = self.info.imageData;
            [sectionArray addObject:info];
        }
        [dataArray addObject:sectionArray];
    }
    [selfView reloadAddPWCellWithArray:_dataArray = dataArray withVC:self];
}

///新增、或者更新
- (void)saveCurrentContentWithUpdate:(UIBarButtonItem *)rightItem
{
    [self.view endEditing:YES];
    NSMutableArray * backArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        NSArray * section = _dataArray[i];
        for (NSInteger j = 0; j < section.count; j++) {
            AddPWInfo * addInfo = section[j];
            if (i == 0 && addInfo.titleInput.length == 0) {
                NSString * string = [NSString stringWithFormat:@"%@不能为空~_~", [addInfo.titlePlace substringToIndex:addInfo.titlePlace.length-3]];
                [UIAlertView showAlertMessage:string andDelay:1.0f];
                return;
            }
            [backArray addObject:addInfo.titleInput ?: @""];
        }
    }
    
    [XMGProgressView showHUDAddedTo:[UIApplication sharedApplication].keyWindow];
    PassWordInfo * info = [[PassWordInfo alloc] init];
    info.titleName = [backArray firstObject];
    info.webSite = backArray[1];
    info.account = backArray[2];
    info.passWord = backArray[3];
    info.beiZhu = [backArray lastObject];
    info.createTime = [self.formatter stringFromDate:[NSDate date]];
    info.typeId = self.info.typeId ?: self.typeId;
    info.pwId = self.info.pwId ?: nowTimestamp;
    info.isEdited = self.info ? 1 : 0;
    UIImage * photoImg = _selfView.photoImg.image;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        info.imageData = UIImagePNGRepresentation(photoImg);
        dispatch_async(dispatch_get_main_queue(), ^{
            [XMGProgressView hideHUDForView:[UIApplication sharedApplication].keyWindow];
            if ([rightItem.title isEqualToString:@"更新"]) {
                if ([FMDB_Tool updateSingleDataWithPassWordInfo:info]) {
                    [self.delegate returnAddedPassWordWithInfo:info withIsEdit:self.info];
                    XMGLog(@"...更新成功...");
                    [super backAction];
                }
                return;
            }
            if ([FMDB_Tool insertSingleDataToDataBaseWithInfo:info]) {
                [self.delegate returnAddedPassWordWithInfo:info withIsEdit:self.info];
                XMGLog(@"...新增成功...");
                [super backAction];
            }
        });
    });
}

- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy年MM月dd HH:mm:ss"];
        _formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    }
    return _formatter;
}

- (void)giveUpToAddPW
{
    [super backAction];
}

#pragma mark - AddPWViewDelegate
- (void)AddPWViewBroserCurrentPhotoWithImage:(UIImage *)image
{
    photoMsgViewController * photo = [[photoMsgViewController alloc] init];
    photo.image = image;
    photo.delegate = self;
    [self.navigationController pushViewController:photo animated:YES];
}
- (void)photoMsgViewControllerDidDeleteCurrentPasswordPhoto
{
    _selfView.photoImg.image = nil;
    _selfView.photoImg.userInteractionEnabled = NO;
}

- (void)AddPWViewSelectPhoto
{
    [self.view endEditing:YES];
    XMGActionSheet * sheet = [[XMGActionSheet alloc] initWithDelegate:self cancelTitle:@"取消" otherTitles:@[@"拍照", @"用户相册"]];
    [sheet showInCurrentView];
}

///1拍照、2相册
- (void)actionSheet:(XMGActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    } else if (buttonIndex == 2) {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) {
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    controller.delegate = self;
    controller.navigationBar.barTintColor = COLOR_HEX_WIDTH_ALPHA(@"#191919", 0.7);
    controller.navigationBar.tintColor = COLOR_HEX(@"#ffffff");
    [controller.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

///取得照片回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage * portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        _selfView.photoImg.image = portraitImg;
        _selfView.photoImg.userInteractionEnabled = YES;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    if (!self.block) return nil;
    UIPreviewAction * action = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        self.block();
    }];
    return @[action];
}

@end
