//
//  TestCollectionViewController.m
//  tt
//
//  Created by 姜泽东 on 2017/8/31.
//  Copyright © 2017年 姜泽东. All rights reserved.
//

#import "TestCollectionViewController.h"
#import "TestCollectionViewCell.h"
#import "TModel.h"

@interface TestCollectionViewController ()

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation TestCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3388353203,699301441&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=146867995,2077372826&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1213800578,551109493&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2172765071,1418416153&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2880742772,2852655476&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2909638738,3913989636&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=561277916,3786607033&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=4170419186,2154597461&fm=11&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1649524530,430557330&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=268944007,266420247&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=972586425,1380451962&fm=11&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2982784481,1867693734&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=781741642,3036072029&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3192259488,385001933&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1007684018,3559026253&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=346035120,1311563185&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3841132735,626642319&fm=26&gp=0.jpg",
                       @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=637099997,2540903913&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1838204913,2585681768&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1378268600,3131062296&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3036614520,1770452470&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3404275157,400568051&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3636827795,3869237386&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=317985611,1071138&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2019931304,4137623701&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=448769809,1467606603&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2988426543,952553337&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=268751893,2805695044&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3807715850,2686586385&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2181332669,2198227978&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1862254612,3537983758&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1512131466,3380282489&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2597184389,3297999341&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2943316907,1699263586&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3915677395,2083271492&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2828538072,2910588275&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3927041182,2956063698&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1027390594,969365975&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3572743532,2585574693&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=904911358,3919001147&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1206940988,4072808202&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=87834313,1905567082&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1374620818,4102909270&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=440250785,1560595338&fm=26&gp=0.jpg",
                       @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2925054550,3845959424&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1329385906,2215888925&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=4191102784,1178337445&fm=26&gp=0.jpg",
                       @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=39899850,1446223496&fm=26&gp=0.jpg",
                       @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1822508100,252816704&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2334205822,667646676&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3467772875,1016941908&fm=26&gp=0.jpg",
                       @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2662618655,3490441657&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3505256839,3260418282&fm=26&gp=0.jpg",
                       @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2385089579,4192320481&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1506190116,2031925353&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1194146302,376301441&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2251755654,2616149627&fm=11&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=36078597,262418445&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=4032271087,1490813334&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=726616755,3111007752&fm=11&gp=0.jpg",
                       @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2782919897,498238305&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2753069457,1969738597&fm=26&gp=0.jpg",
                       @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=549887529,3542336857&fm=26&gp=0.jpg"
                       ];
    
    NSMutableArray *mut = [@[] mutableCopy];
    
    for (NSString *url in array) {
        TModel *model = [[TModel alloc] init];
        model.imageUrl = url;
        [mut addObject:model];
    }
    
    _dataArray = mut;

    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGSize size = [[UIScreen mainScreen] bounds].size;
    layout.itemSize = CGSizeMake(size.width/4-3, 80);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    [cell setContentWithModel:_dataArray[indexPath.row]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
