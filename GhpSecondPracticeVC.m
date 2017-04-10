//
//  GhpSecondPracticeVC.m
//  公务员
//
//  Created by 高鸿鹏 on 16/9/5.
//  Copyright © 2016年 医教园. All rights reserved.
//

#import "GhpSecondPracticeVC.h"
#import "GhpSectionView.h"
#import "GhpThirdCell.h"
#import "UIView+Ghp.h"
@interface GhpSecondPracticeVC ()
<UITableViewDataSource,
UITableViewDelegate,
GhpSectionViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *sectionsArray; //section数组
@property (nonatomic,strong)NSMutableArray *rowsArray;  //row数组
@property (nonatomic,assign)NSInteger openNumber;    //选中那一个section 用于展开收起

@end

@implementation GhpSecondPracticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"按模块";
    self.openNumber = 999;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.sectionsArray.count == 0) {
        return 1;
    }
    return self.sectionsArray.count+7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sectionsArray.count == 0) {
        return 10;
    }
    
    for (UIView *view in self.tableView.subviews) {
        if ([view isKindOfClass:[GhpSectionView class]]) {
            GhpSectionView *sectionView = (GhpSectionView *)view;
            if (sectionView.tag == section+10) {
                if (section == self.openNumber) {
                    [sectionView.leftImg setImage:[UIImage imageNamed:@"shuzhankai_"]];
                }else{
                    [sectionView.leftImg setImage:[UIImage imageNamed:@"zahnkai_"]];
                }
            }
        }
    }
    
    
    if (section == self.openNumber) {
        return 3;
    }
    
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 10;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 10);
        view.backgroundColor = COLOR_DEFAULTVIEW;
        return view;
    }
    
    GhpSectionView *mySectionView = [GhpSectionView initWithNib];
    mySectionView.frame = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 55);
    mySectionView.delegate = self;
    mySectionView.section = section;
    mySectionView.tag = section+10;
    mySectionView.titleLab.text = [NSString stringWithFormat:@"lable%ld",section];
    return mySectionView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    
    GhpThirdCell *cell = (GhpThirdCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [GhpThirdCell initWithNib];
    }
    //两种cell样式
    if (self.sectionsArray.count == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = RRR(250);
        cell.titleLeft.constant += 25;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didSelectSectionViewWithSection:(NSInteger)section
{

    NSMutableArray *insertArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < 3; i ++) {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:i inSection:section];
        [insertArray addObject:newPath];
    }
    
    [self.tableView beginUpdates];
    //self.openNumber = 999; 表示所有section 都处于收起状态
    if (section == self.openNumber && self.openNumber != 999) { //选中已经展开的
        self.openNumber = 999;
        [self.tableView deleteRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        return;
    }
    
    [self.tableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationFade];
    
    NSMutableArray *deleteArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    /*
     如果self.openNumber =999  表示所有section都处于收起状态 这时如果delete 会奔溃
     */
    if (self.openNumber !=999) {
        
        for (int i = 0; i < 3; i ++) {
            NSIndexPath *newPath = [NSIndexPath indexPathForRow:i inSection:self.openNumber];
            [deleteArray addObject:newPath];
        }
        //收起之前大的section
        [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
    }
    
    self.openNumber = section;
    
    [self.tableView endUpdates];
    
}

#pragma mark get
- (UITableView *)tableView
{
    if (!_tableView) {
        
        if ([[UIDevice currentDevice].systemVersion intValue] < 8) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT) style:UITableViewStylePlain];
        }else{
            
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-64) style:UITableViewStylePlain];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    
    return _tableView;
    
}


- (NSMutableArray *)rowsArray
{
    if (!_rowsArray) {
        _rowsArray = [[NSMutableArray alloc]init];
    }
    
    return _rowsArray;
}

- (NSMutableArray *)sectionsArray
{
    if (!_sectionsArray) {
        _sectionsArray = [[NSMutableArray alloc]initWithCapacity:0];
        [_sectionsArray addObject:@""];
    }
    return _sectionsArray;
}

@end
