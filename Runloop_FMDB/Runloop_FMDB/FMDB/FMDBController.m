//
//  FMDBController.m
//  Runloop_FMDB
//
//  Created by  ZhuHong on 2018/1/3.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "FMDBController.h"
#import "FMDBTools.h"
#import "HGModel.h"

@interface FMDBController ()

@end

@implementation FMDBController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [FMDBTools openDBWithFileName:@"CoderHG.db"];
        }
            break;
        case 1:
        {
            
            [FMDBTools createWithModel:[HGModel new]];
        }
            break;
        case 2:
        {
            HGModel* model = [HGModel new];
            model.name = @"HG";
            model.address = @"TJ";
            [FMDBTools insertDataModel:model];
        }
            break;
            
        case 3:
        {
            HGModel* model = [HGModel new];
            NSMutableArray* querys = [FMDBTools queryTableWithModel:model SQL:nil];
            NSLog(@"%@", querys);
        }
            break;
        case 4:
        {
            [FMDBTools close];
        }
            break;
            
            
            
        default:
            break;
    }
    
    
}

@end
