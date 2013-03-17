//
//  TPCollectionViewController.m
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "TPCollectionViewController.h"
#import "TPCollectionViewCell.h"
@interface TPCollectionViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation TPCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerClass:[TPCollectionViewCell class] forCellWithReuseIdentifier:@"cvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Collection view delegate mathods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.otterArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TPCollectionViewCell *cell = (TPCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    
    NSDictionary *otterDictionary = [self.otterArray objectAtIndex:indexPath.row];
    
    NSString *otterName = [otterDictionary objectForKey:@"siteName"];
    [cell.nameLabel setText:otterName];
    
    NSString *v1 = [otterDictionary objectForKey:@"v1"];
    NSString *v2 = [otterDictionary objectForKey:@"v2"];
    NSString *v3 = [otterDictionary objectForKey:@"v3"];
    NSString *v4 = [otterDictionary objectForKey:@"v4"];
    NSString *v5 = [otterDictionary objectForKey:@"v5"];
    
    cell.imageView.alpha = 0.0f;
    
    if ([v1 isEqualToString:@"P"]) {
        cell.imageView.alpha = 0.25f;
    }
    
    if ([v2 isEqualToString:@"P"]) {
        cell.imageView.alpha = 0.35f;
    }
    
    if ([v3 isEqualToString:@"P"]) {
        cell.imageView.alpha = 0.45f;
    }
    
    if ([v4 isEqualToString:@"P"]) {
        cell.imageView.alpha = 0.5f;
    }
    
    if ([v5 isEqualToString:@"P"]) {
        cell.imageView.alpha = 1.0f;
    }
    
    if ([[otterDictionary objectForKey:@"minkPresent"] isEqualToString:@"Y"]) {
        [cell.imageView setImage:[UIImage imageNamed:@"tombstone"]];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath = %@", indexPath);
    
    
    
}

@end
