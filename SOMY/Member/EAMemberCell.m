//
//  EAMemberCell.m
//  SOMY
//
//  Created by easaa on 9/10/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAMemberCell.h"

@implementation EAMemberCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor colorwithHexString:@"#3f3f3f"];
    self.selectImage.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
