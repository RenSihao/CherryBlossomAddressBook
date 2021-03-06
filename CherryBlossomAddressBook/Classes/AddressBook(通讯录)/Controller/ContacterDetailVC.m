//
//  ContacterDetailVC.m
//  CherryBlossomAddressBook
//
//  Created by RenSihao on 16/4/8.
//  Copyright © 2016年 XuJiajia. All rights reserved.
//

#import "ContacterDetailVC.h"
#import "ContacterAvatarCell.h"
#import "ContacterDetailChangeVC.h"
#import "ContacterSexPopView.h"
#import "ImageScaleViewController.h"

#define SectionHeaderHeight 14.f
#define ButtonWidth 100.f
#define ButtonHeight 100.f

@interface ContacterDetailVC ()
<
ContacterAvatarCellDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
MFMessageComposeViewControllerDelegate
>

/**
 *  发短信按钮
 */
@property (nonatomic, strong) UIButton *messageBtn;
/**
 *  打电话按钮
 */
@property (nonatomic, strong) UIButton *callBtn;

/**
 *  发短信 - 弹出控制器
 */
@property (nonatomic, strong) UIAlertController *alertController;
/**
 *  联系人模型
 */
@property (nonatomic, strong) ContacterModel *contacterModel;

/**
 *  联系人信息标题
 */
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ContacterDetailVC

#pragma mark - init

- (instancetype)initWithContacterModel:(ContacterModel *)model
{
    if (self = [super init])
    {
        _contacterModel = model;
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"联系人详情";
    
    [self.view addSubview:self.messageBtn];
    [self.view addSubview:self.callBtn];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat padding = 35;
    
    self.messageBtn.frame = CGRectMake(0, self.tableView.contentSize.height + (self.titleArray.count-1)*SectionHeaderHeight, ButtonWidth, ButtonHeight);
    self.messageBtn.x = padding;
    
    self.callBtn.frame = CGRectMake(0, self.messageBtn.y, ButtonWidth, ButtonHeight);
    self.callBtn.x = SCREEN_WIDTH - padding - ButtonWidth;
}


#pragma mark - lazyload

- (NSArray *)titleArray
{
    if(!_titleArray)
    {
        _titleArray = [NSArray array];
        _titleArray = @[@[@"头像", @"姓名"],
                        @[@"备注名", @"性别"],
                        @[@"电话", @"地址"]];
    }
    return _titleArray;
}
- (UIButton *)messageBtn
{
    if (!_messageBtn)
    {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _messageBtn.layer.cornerRadius = ButtonWidth / 2;
        _messageBtn.layer.masksToBounds = YES;
        _messageBtn.titleLabel.font = [UIFont fontWithName:kDefaultBoldFontFamilyName size:23];
        
        [_messageBtn setTitle:@"Message" forState:UIControlStateNormal];
        [_messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [_messageBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor] cornerRadius:0] forState:UIControlStateNormal];
        
        [_messageBtn addTarget:self action:@selector(didClickMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}
- (UIButton *)callBtn
{
    if (!_callBtn)
    {
        _callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _callBtn.layer.cornerRadius = ButtonWidth / 2;
        _callBtn.layer.masksToBounds = YES;
        _callBtn.titleLabel.font = [UIFont fontWithName:kDefaultBoldFontFamilyName size:23];
        
        [_callBtn setTitle:@"Call" forState:UIControlStateNormal];
        [_callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_callBtn setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor] cornerRadius:0] forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(didClickCall) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.titleArray[section];
    return sectionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*************** 头部 第0组 ******************/
    if(indexPath.section == ContacterSectionTypeTop)
    {
        //头像
        if(indexPath.row == 0)
        {
            static NSString *reuseID = @"HeaderCell";
            ContacterAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if(!cell)
            {
                cell = [[ContacterAvatarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            cell.delegate = self;
            [cell updateWithUserModel:_contacterModel];
            return cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *reuseID = @"NameCell";
            BaseSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if(!cell)
            {
                cell = [[BaseSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            cell.position = BaseSimpleCellBGPositionBottom;
            cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
            cell.detailTextLabel.text = _contacterModel.name;
            return cell;
        }
    }
    /*************** 中间 第1组 ******************/
    else if(indexPath.section == ContacterSectionTypeMid)
    {
        //备注名
        if(indexPath.row == 0)
        {
            static NSString *reuseID = @"NickNameCell";
            BaseSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if(!cell)
            {
                cell = [[BaseSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            cell.position = BaseSimpleCellBGPositionTop;
            cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
            cell.detailTextLabel.text = _contacterModel.nickName;
            return cell;
        }
        //性别
        else if (indexPath.row == 1)
        {
            static NSString *reuseID = @"SexCell";
            BaseSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if(!cell)
            {
                cell = [[BaseSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            cell.position = BaseSimpleCellBGPositionBottom;
            cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
            //非男即女
            NSString *sex = @"";
            NSLog(@"%ld", _contacterModel.sex);
            switch (_contacterModel.sex) {
                case ABSexMan:
                    sex = @"男";
                    break;
                case ABSexWomen:
                    sex = @"女";
                    break;
                case ABSexUnknow:
                    sex = @"未知";
                    break;
                default:
                    break;
            }
            cell.detailTextLabel.text = sex;
            return cell;
        }
    }
    /*************** 底部 第2组 ******************/
    else if (indexPath.section == ContacterSectionTypeBottom)
    {
        //电话
        if(indexPath.row == 0)
        {
            static NSString *reuseID = @"PhoneCell";
            BaseSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if(!cell)
            {
                cell = [[BaseSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            cell.position = BaseSimpleCellBGPositionTop;
            cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
            cell.detailTextLabel.text = _contacterModel.phone;
            return cell;
        }
        //地址
        else if (indexPath.row == 1)
        {
            static NSString *reuseID = @"AddressCell";
            BaseSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if (!cell)
            {
                cell = [[BaseSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            cell.position = BaseSimpleCellBGPositionBottom;
            cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
            cell.detailTextLabel.text = _contacterModel.address;
            return cell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == ContacterSectionTypeTop && indexPath.row == 0)
    {
        return [ContacterAvatarCell cellHeight];
    }
    else
    {
        return [BaseSimpleCell cellHeight];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == ContacterSectionTypeTop)
    {
        return 0.f;
    }
    else
    {
        return 14.f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击状态还原
    deselectRowWithTableView(tableView);
    /************** 头 **************/
    if(indexPath.section == ContacterSectionTypeTop)
    {
        //头像
        if(indexPath.row == 0)
        {
            UIAlertController *changeAvatar = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getPhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }];
            UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //判断是否支持相机
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    [self getPhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                }
                else
                {
                    [self getPhotoWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                }
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [changeAvatar addAction:takePhoto];
            [changeAvatar addAction:choosePhoto];
            [changeAvatar addAction:cancel];
            [self presentViewController:changeAvatar animated:YES completion:nil];
            
        }
        //姓名
        else if (indexPath.row == 1)
        {
            [self cellIndexPath:indexPath ContacterDetailChangeType:ContacterDetailChangeName];
        }
    }
    /************** 中间 **************/
    else if(indexPath.section == ContacterSectionTypeMid)
    {
        //备注
        if(indexPath.row == 0)
        {
            [self cellIndexPath:indexPath ContacterDetailChangeType:ContacterDetailChangeNickName];
        }
        //性别
        else if (indexPath.row == 1)
        {
            ContacterSexPopView *sexPopView = [[ContacterSexPopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withContacterModel:_contacterModel];
            [self.tableView addSubview:sexPopView];
        }
    }
    /************** 底部 **************/
    else if (indexPath.section == ContacterSectionTypeBottom)
    {
        //电话
        if(indexPath.row == 0)
        {
            [self cellIndexPath:indexPath ContacterDetailChangeType:ContacterDetailChangePhone];
        }
        //地址
        else if(indexPath.row == 1)
        {
            [self cellIndexPath:indexPath ContacterDetailChangeType:ContacterDetailChangeAddress];
        }
    }
}
#pragma mark - UserProfileHeaderCellDelegate

- (void)didClickAvatarImageView:(UIImageView *)avatarImageView
{
    ImageScaleViewController *scaleVC = [[ImageScaleViewController alloc] initWithImageView:avatarImageView];
    [scaleVC setModalPresentationStyle:UIModalPresentationFullScreen];
    [scaleVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:scaleVC animated:YES completion:nil];
}

#pragma mark - 修改头像调用系统相机和系统相册

- (void)getPhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

/**
 *  获取照片
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType;      // an NSString (UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    __block UIImage *photoImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //此处存储照片
    [self saveAvatarImageToLocalDocument:photoImg];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

/**
 *  保存照片到本地document文件夹
 *
 *  @param photoImg 照片
 */
- (void)saveAvatarImageToLocalDocument:(UIImage *)photoImg
{
    NSLog(@"%@", _contacterModel.avatarPath);
    //获取头像图片保存路径 真机的document路径每次启动都是变化的 所以无法保存 即联系人模型的avatarpath没用
    NSString *avatarPath = AvatarPathWithContacterID(_contacterModel.contacterID);
    
    //把图片转成NSData类型的数据来保存文件
    NSData *data = nil;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(photoImg))
    {
        //返回为png图像。
        data = UIImagePNGRepresentation(photoImg);
    }
    else
    {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(photoImg, 1.0);
    }
    
    //写入文件
    if ([[NSFileManager defaultManager] createFileAtPath:avatarPath contents:data attributes:nil])
    {
        //保存联系人信息 写入数据库
        if ([[DataBaseManager shareInstanceDataBase] successOpenDataBaseType:ContacterDataBase])
        {
            if ([[DataBaseManager shareInstanceDataBase] successUpdateContacterModle:_contacterModel])
            {
                [SVProgressHUD showSuccessWithStatus:@"保存头像成功！"];
                ContacterModel *contacterModel = [[DataBaseManager shareInstanceDataBase] getContacterModelOfContacterID:_contacterModel.contacterID];
                if (contacterModel)
                {
                    _contacterModel = contacterModel;
                    [self.tableView reloadData];
                }
            }
        }
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            [SVProgressHUD showSuccessWithStatus:@"发送成功！"];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [SVProgressHUD showErrorWithStatus:@"发送失败！"];
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            [SVProgressHUD showErrorWithStatus:@"取消发送！"];
            break;
        default:
            break;
    }
}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - 点击cell跳转封装方法
/**
 *  修改用户资料，点击不同cell跳转
 *
 *  @param indexPath  cell 的indexPath
 *  @param changeType cell 的种类
 */
- (void)cellIndexPath:(NSIndexPath *)indexPath ContacterDetailChangeType:(ContacterDetailChangeType)changeType
{
    ContacterDetailChangeVC *contacterChangeVC = [[ContacterDetailChangeVC alloc] initWithContacterModel:_contacterModel];
    
    //使用block给 ContacterDetailChangeVC 传值
    switch (changeType) {
        case ContacterDetailChangeName:
        {
            [contacterChangeVC prepareCellTitle:self.titleArray[indexPath.section][indexPath.row]
                                CellContentInfo:_contacterModel.name
                 ContacterDetailChangeNameBlock:^(NSString *newNickName) {
            }];
        }
            break;
        case ContacterDetailChangeNickName:
        {
            [contacterChangeVC prepareCellTitle:self.titleArray[indexPath.section][indexPath.row]
                                CellContentInfo:_contacterModel.nickName
                  ContacterDetailChangeNickNameBlock:^(NSString *newName) {
            }];
        }
            break;
        case ContacterDetailChangePhone:
        {
            [contacterChangeVC prepareCellTitle:self.titleArray[indexPath.section][indexPath.row]
                                CellContentInfo:_contacterModel.phone
                ContacterDetailChangePhoneBlock:^(NSString *newWeChatAccount) {
            }];
        }
            break;
        case ContacterDetailChangeAddress:
        {
            [contacterChangeVC prepareCellTitle:self.titleArray[indexPath.section][indexPath.row]
                                CellContentInfo:_contacterModel.address
              ContacterDetailChangeAddressBlock:^(NSString *newStoreName) {
            }];
        }
        default:
            break;
    }
    
    [self.navigationController pushViewController:contacterChangeVC animated:YES];
}
- (UIAlertController *)alertController
{
    if (!_alertController)
    {
        _alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发送给：%@", _contacterModel.name] message:@"短信" preferredStyle:UIAlertControllerStyleAlert];
        
        /* 给 UIAlertController 添加动作按钮 */
        
        //取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"cancel");
            //从广播中心移除该条通知
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        }];
        
        //确定按钮
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"default");
            //从广播中心移除该条通知
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            //调用发短信
            UITextField *accountTextField = _alertController.textFields[0];
            [self showMessageView:@[_contacterModel.phone] title:_contacterModel.name body:accountTextField.text];
            
        }];
        
        
        cancelAction.enabled = YES;
        defaultAction.enabled = NO;
        
        //添加 只添加取消和默认两个按钮，效果和三个全部添加不同
        [_alertController addAction:cancelAction];
        [_alertController addAction:defaultAction];
        
        
        /* 给UIAlertController 添加输入框 */
        __weak typeof(self) weakSelf = self;
        //添加账号输入框
        [_alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"短信内容";
            //增加一条广播
            [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(accountTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        }];
        
        
    }
    return _alertController;
}

/**
 *  监听短信输入框
 *
 *  @param notification
 */
- (void)accountTextFieldDidChange:(NSNotification *)notification
{
    if (_alertController)
    {
        //textFields 和 actions 是数组
        UITextField *accountTextField = _alertController.textFields[0];
        UIAlertAction *cancelAction = _alertController.actions[0];
        UIAlertAction *defaultAction = _alertController.actions[1];
        
        defaultAction.enabled = accountTextField.text.length > 0;
    }
}



#pragma mark - 打电话 发短信

- (void)didClickMessage
{
    if ([_contacterModel.phone isMobileNumber])
    {
        [self presentViewController:self.alertController animated:YES completion:nil];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"非法号码！"];
    }
    
}
- (void)didClickCall
{
    if ([[AppManager sharedInstance] callPhoneWithPhoneNumber:_contacterModel.phone])
    {
        NSLog(@"调用系统打电话成功！");
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"非法号码！"];
    }
}

#pragma mark - 通知相关

- (void)addNotificationObservers
{
    [super addNotificationObservers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotificationContacterChange:) name:kNotificationContacterChange object:nil];
}
- (void)removeNotificationObservers
{
    [super removeNotificationObservers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveNotificationContacterChange:(NSNotification *)noti
{
    if ([[DataBaseManager shareInstanceDataBase] successOpenDataBaseType:ContacterDataBase])
    {
        if ([[DataBaseManager shareInstanceDataBase] getContacterModelOfContacterID:_contacterModel.contacterID])
        {
            _contacterModel = [[DataBaseManager shareInstanceDataBase] getContacterModelOfContacterID:_contacterModel.contacterID];
            [self.tableView reloadData];
        }
    }
}

@end


#pragma mark  - 地址cell

@interface ContacterAddressCell ()

@property (nonatomic, strong) ContacterModel *contacterModel;
@property (nonatomic, strong) UIView *line;
@end

@implementation ContacterAddressCell

+ (CGFloat)cellHeight
{
    return 140;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.remarkTV];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)updateWithContact:(ContacterModel *)contact
{
    _contacterModel = contact;
    [self.remarkTV setText:_contacterModel.address.length > 0 ? _contacterModel.address : @"暂无信息"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.remarkTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.mas_equalTo(self.contentView);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (UITextView *)remarkTV
{
    if(!_remarkTV)
    {
        _remarkTV = [[UITextView alloc] init];
        [_remarkTV setUserInteractionEnabled:NO];
        [_remarkTV setFont:[UIFont fontWithName:kDefaultRegularFontFamilyName size:16.0]];
        [_remarkTV setTextColor:kColorTextMain];
    }
    return _remarkTV;
}
- (UIView *)line
{
    if (!_line)
    {
        _line = [UIView new];
        _line.backgroundColor = [UIColor grayColor];
        _line.alpha = 0.3;
    }
    return _line;
}

@end





