//
//  MainGameView.m
//  FishyModule
//
//  Created by Pranav on 01/07/16.
//  Copyright © 2016 Pranav. All rights reserved.
//

#import "MainGameView.h"

#import "BubbleGameScoreBoardViewController.h"
#import "BubbleBubble.h"

MainGameView *game;
BubbleBubble *bubble;
NSMutableArray *allTimers;
float myTime;
CGRect myFrame;
UIImageView *background, *topBarImageView;
int tagCounter, life, fishesLeft, score;
//UILabel *scoreCounter;
UIViewController *vc;
UILabel *timeLabel;
float totalSeconds;

@implementation MainGameView

+ (MainGameView *)startFishyGame:(CGRect)frame viewController:(UIViewController *)viewController{
    game = [[MainGameView alloc]initWithFrame:frame];
    vc = viewController;
    allTimers = [[NSMutableArray alloc]init];
    [game setUserInteractionEnabled:YES];
    UITapGestureRecognizer *bubbleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkBubbleTap:)];
    [game addGestureRecognizer:bubbleTap];
//    scoreCounter = [[UILabel alloc]initWithFrame:CGRectMake(game.frame.origin.x+20, game.frame.origin.y+30, 100, 20)];
//    lifeCounter = [[UILabel alloc]initWithFrame:CGRectMake(game.frame.size.width-120, game.frame.origin.y+30, 100, 20)];
    myFrame = frame;
    background = [[UIImageView alloc]initWithFrame:frame];
    [background setImage:[UIImage imageNamed:@"bg_game_2x.png"]];
    background.contentMode = UIViewContentModeScaleToFill;
    [game addSubview:background];
    CGRect topBarImageFrame = CGRectMake(0, 0, frame.size.width, frame.size.width/5.55);
    topBarImageView = [[UIImageView alloc] initWithFrame:topBarImageFrame];
    [topBarImageView setImage:[UIImage imageNamed:@"splash_fish_bg_2x.png"]];
    [game addSubview:topBarImageView];
    [game bringSubviewToFront:topBarImageView];
    [self createFishImageViews];
    CGRect timeLabelFrame = CGRectMake(frame.size.width - 75, 20, 60, 25);
    timeLabel = [[UILabel alloc] initWithFrame:timeLabelFrame];
    [timeLabel setBackgroundColor:[UIColor colorWithRed:111.0/255 green:63.0/255 blue:22.0/255 alpha:1.0]];
    timeLabel.layer.cornerRadius = 5;
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setFont:timeLabel.font];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [game addSubview:timeLabel];
//    [scoreCounter setTextAlignment:NSTextAlignmentCenter];
//    [lifeCounter setTextAlignment:NSTextAlignmentCenter];
//    [game addSubview:scoreCounter];
//    [game addSubview:lifeCounter];
    tagCounter = 1;
    fishesLeft = 5;
    life = 3;
    score = 0;
    totalSeconds = 0;
//    [scoreCounter setText:[NSString stringWithFormat:@"Score: %d",score]];
//    [lifeCounter setText:[NSString stringWithFormat:@"Life: %d",life]];
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(placeBubbles:)
                                   userInfo:nil
                                    repeats:YES];
    return game;
}

+ (void)createFishImageViews
{
    for (int i = 0; i < 5; i++)
    {
        CGFloat width = myFrame.size.width/12.8;
        CGFloat height = width/1.92;
        CGFloat distance = width + 10;
        CGRect frame = CGRectMake(10+distance*i , 20, width ,height );
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setTag:(i+1)*100];
        [imageView setImage:[UIImage imageNamed:@"splash_fish_unfill_3x.png"]];
        [game addSubview:imageView];
    }
}

- (void)updateFishImageView
{
    NSInteger fishTag = (5 - fishesLeft) * 100;
    if (fishTag) {
        UIImageView *imageView = [game viewWithTag:fishTag];
        [imageView setImage:[UIImage imageNamed:@"splash_fish_fill_3x.png"]];
    }
    
}

+ (void)calledEveryHalfASecond
{
    totalSeconds += 0.5;
    int seconds = totalSeconds;
    int minute = seconds/60;
    int second = seconds % 60;
    [timeLabel setText:[NSString stringWithFormat:@"%d.%d",minute,second]];
}

+ (void)placeBubbles:(NSTimer *)timer{
    [self calledEveryHalfASecond];
    [allTimers addObject:timer];
    CGFloat buffX = arc4random_uniform(myFrame.size.width*0.667)+(myFrame.size.width/9);
    bubble = [[BubbleBubble alloc]initWithFrame:CGRectMake(buffX, myFrame.size.height-40, 70, 70)];
    [bubble setUserInteractionEnabled:NO];
    bubble.type = arc4random_uniform(4)+1;
    switch (bubble.type) {
        case 1:
            bubble.image = [UIImage imageNamed:@"fish_1.png"];
            break;
        case 2:
            bubble.image = [UIImage imageNamed:@"crab.png"];
            break;
        case 3:
            bubble.image = [UIImage imageNamed:@"cockrach.png"];
            break;
        case 4:
            bubble.image = [UIImage imageNamed:@"blue_diamond.png"];
            break;
        default:
            break;
    }
    [bubble setTag:tagCounter];
    [game insertSubview:bubble belowSubview:topBarImageView];
    tagCounter++;
    [game animateBubbles:bubble];
}

- (void)animateBubbles:(BubbleBubble *)myImage{
    CGPoint point = CGPointMake(myImage.frame.origin.x, myImage.frame.origin.y+myImage.frame.size.height);
    CGPoint nextPoint, controlPoint;
    CGFloat buffer = myFrame.size.height/5;
    nextPoint = CGPointMake(point.x, point.y - buffer);
    controlPoint = CGPointMake(point.x - (arc4random_uniform(3)+25), (point.y + nextPoint.y)/2);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    [path addQuadCurveToPoint:nextPoint controlPoint:controlPoint];
    for (int i=1; i<=4; i++) {
        point = nextPoint;
        nextPoint = CGPointMake(point.x, point.y - buffer);
        controlPoint = CGPointMake(point.x + (arc4random_uniform(10)+20), (point.y + nextPoint.y)/2);
        [path addQuadCurveToPoint:nextPoint controlPoint:controlPoint];
    }
    [CATransaction begin];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 4.0;
    animation.path = path.CGPath;
    [CATransaction setCompletionBlock:^{[myImage removeFromSuperview];}];
    [myImage.layer addAnimation:animation forKey:@"myPathAnimation"];
    [CATransaction commit];
}

+ (void)checkBubbleTap:(UITapGestureRecognizer *)tapGesture{
    CGPoint touchPoint = [tapGesture locationInView:game];
    CALayer *fishLayer;
    for (UIView *buff in game.subviews) {
        if ([buff isKindOfClass:[BubbleBubble class]]) {
            BubbleBubble *bufferBubble = (BubbleBubble *)buff;
            fishLayer = [bufferBubble.layer presentationLayer];
            if ([fishLayer hitTest:touchPoint]) {
                [game bubbleTouched:bufferBubble];
                [game addSubview:background];
                [game sendSubviewToBack:background];
            }
        }
    }
}

- (void)bubbleTouched:(BubbleBubble *)bubblezz{
    [bubblezz removeFromSuperview];
    switch (bubblezz.type) {
        case 1:
            score += 10;
            fishesLeft -= 1;
            [self fishFly:bubblezz];
            [self messagePopUp:bubblezz.type];
            break;
        
        case 2:
        case 3:
            score -= 5;
            life -= 1;
            [self messagePopUp:bubblezz.type];
            break;
        case 4:
            score += 5;
            [self messagePopUp:bubblezz.type];
            break;
            
        default:
            break;
    }
    
    [self updateFishImageView];
    if(fishesLeft == 0){
        [self performSelector:@selector(gameOver)
                   withObject:nil
                   afterDelay:1];
    }
    
}

- (void)gameOver{
    UIView *finalScreen = [[UIView alloc]initWithFrame:myFrame];
    UIImageView *endEffects = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"game_complete_screen_3x.png"]];
    [finalScreen addSubview:background];
    UIView *subViewRemove;
    
    for (subViewRemove in game.subviews) {
        [subViewRemove removeFromSuperview];
    }
    
    endEffects.frame = CGRectMake(0, 0, myFrame.size.width, myFrame.size.width*1.4);
    endEffects.center = game.center;
    [endEffects setContentMode:UIViewContentModeScaleAspectFill];
    [finalScreen addSubview:endEffects];
    
    //        UILabel *gameOver = [[UILabel alloc]initWithFrame:CGRectMake(game.center.x-52, endEffects.center.y-50, 150, 40)];
    UILabel *finalScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(game.center.x-80, endEffects.center.y-50, 160, 40)];
    UILabel *finalTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(game.center.x-70, endEffects.center.y-10, 140, 40)];
    UIButton *scoreBoardButton = [[UIButton alloc]initWithFrame:CGRectMake(game.center.x+10, endEffects.center.y+(endEffects.frame.size.height*0.33), 100, 36)];
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(game.center.x-110, endEffects.center.y+(endEffects.frame.size.height*0.33), 100, 36)];
    UIButton *fbButton = [[UIButton alloc]initWithFrame:CGRectMake(game.center.x+10, endEffects.center.y+70, 100, 36)];
    UIButton *twitterButton = [[UIButton alloc]initWithFrame:CGRectMake(game.center.x-110, endEffects.center.y+70, 100, 36)];
    
    [scoreBoardButton setBackgroundImage:[UIImage imageNamed:@"score_bt_2x.png"] forState:UIControlStateNormal];
    [scoreBoardButton addTarget:vc action:@selector(displayScoreBoard) forControlEvents:UIControlEventTouchUpInside];
    [scoreBoardButton setTitle:@"Score" forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_2x.png"] forState:UIControlStateNormal];
    [closeButton addTarget:vc action:@selector(closeGame) forControlEvents:UIControlEventTouchUpInside];
    [fbButton setBackgroundImage:[UIImage imageNamed:@"close_2x.png"] forState:UIControlStateNormal];
    [fbButton addTarget:vc action:@selector(fbButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [twitterButton setBackgroundImage:[UIImage imageNamed:@"close_2x.png"] forState:UIControlStateNormal];
    [twitterButton addTarget:vc action:@selector(twitterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [finalScreen addSubview:scoreBoardButton];
    [finalScreen addSubview:closeButton];
    [finalScreen addSubview:fbButton];
    [finalScreen addSubview:twitterButton];
    
    
    //        [gameOver setText:@"GAME OVER"];
    //        gameOver.font = [gameOver.font fontWithSize:21.0];
    //        [finalScreen addSubview:gameOver];
    [finalScoreLabel setText:@"Fishes Freed: 5"];
    [finalTimeLabel setText:[NSString stringWithFormat:@"Time: %@",timeLabel.text]];
    
    [finalScoreLabel setTextAlignment:NSTextAlignmentCenter];
    [finalScoreLabel setFont:[UIFont fontWithName:@"Sen-ExtraBold" size:20]];
    [finalTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [finalTimeLabel setFont:[UIFont fontWithName:@"Sen-ExtraBold" size:20]];
    
    [finalScreen addSubview:finalTimeLabel];
    [finalScreen addSubview:finalScoreLabel];
    [game addSubview:finalScreen];
    
    for (id timer in allTimers) {
        [timer invalidate];
    }
}



- (void)messagePopUp:(int)messageType{
    int messageShown = arc4random_uniform(3)+1;
    UIImageView *messageView = [[UIImageView alloc]initWithFrame:CGRectMake(game.center.x-150, game.center.y-140, 350, 230)];
    switch (messageType) {
        case 1:
            messageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"message1_%d.png",messageShown]];
            break;
        case 2:
        case 3:
            messageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"message2_%d.png",messageShown]];
            break;
        case 4:
            messageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"message4_%d.png",messageShown]];
            break;
        default:
            break;
    }
    [game addSubview:messageView];
    [UIView animateWithDuration:1.0
                     animations:^{messageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);}
                     completion:^(BOOL finished){[messageView removeFromSuperview];}];
}

- (void)fishFly:(BubbleBubble *)winFish{
    [winFish setImage:[UIImage imageNamed:@"splash_fish_fill.png"]];
    [game addSubview:winFish];
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{winFish.transform = CGAffineTransformTranslate(winFish.transform, game.frame.size.width, 0);}
                     completion:^(BOOL done){[winFish removeFromSuperview];}];
}

@end
