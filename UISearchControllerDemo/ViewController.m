//
//  ViewController.m
//  UISearchControllerDemo
//
//  Created by 张艳楠 on 2016/11/5.
//  Copyright © 2016年 zhang yannan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>
@property(strong,nonatomic) UISearchController *searchController;
@property(strong,nonatomic) UITableView *tableView;
//数据源
@property (strong,nonatomic) NSMutableArray  *dataList;

@property (strong,nonatomic) NSMutableArray  *searchList;
@end

@implementation ViewController
#pragma mark 搜索控制器的懒加载
-(UISearchController *)searchController{
    if (!_searchController) {
        _searchController=[[UISearchController alloc]init];
    }
    return _searchController;
}
#pragma mark 表格的懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"搜索控制器";
    // Do any additional setup after loading the view, typically from a nib.
    _dataList=[NSMutableArray array];
    _searchList=[NSMutableArray array];
    //产生100个数字加三个随机字母
    for (int i=0; i<=100; i++) {
        NSString *testString=[[NSString alloc]init];
        testString=[NSString stringWithFormat:@"%d%@",i,[self shuffledAlphabet]];
        [self.dataList addObject:testString];
    };
    [self setControllers];
}
#pragma mark 设置搜索控制器的属性
-(void)setControllers{
    //表格的创建
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen  mainScreen].bounds.size.width ,[UIScreen  mainScreen].bounds.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //UISearchController的创建
    //创建UISearchController
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater= self;
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    self.searchController.dimsBackgroundDuringPresentation = YES;
    //搜索时，背景变模糊
    self.searchController.obscuresBackgroundDuringPresentation = YES;
    //隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.searchController.searchBar.frame.size.width, 44.0);
    
    //添加到searchBar到tableView的header
    self.tableView.tableHeaderView=self.searchController.searchBar;
    [self.view addSubview:self.tableView];
    
}
#pragma mark 产生100个数字加三个随机字母
- (NSString *)shuffledAlphabet {
        NSMutableArray * shuffledAlphabet = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
        
        NSString *strTest = [[NSString alloc]init];
        for (int i=0; i<3; i++) {
            int x = arc4random() % 25;
            strTest = [NSString stringWithFormat:@"%@%@",strTest,shuffledAlphabet[x]];
        }
        
        return strTest;
}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }
}
//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    //如果searchController处于活跃状态，表格显示的数据为self.searchList
    if (self.searchController.active) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    else{
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    return cell;
}
#pragma mark 更新表格的显示结果
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"---updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}
#pragma mark - UISearchControllerDelegate代理

//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
//    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
//    NSLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
//    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
//    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
//    NSLog(@"presentSearchController");
}

@end
