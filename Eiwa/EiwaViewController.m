//
//  EiwaViewController.m
//  EIWA
//  メインとなるクラス。辞書機能。
//  Created by 菅澤 英司 on 2012/12/25.
//  Copyright (c) 2012年 菅澤 英司. All rights reserved.
//


#import "EiwaViewController.h"
#import "DictionaryDB.h"
#import "Word.h"
#import "MeanDetailView.h"
#import "WordInputField.h"

//各種設定
#define KEYBOARD_HEIGHT 216    //キーボードの高さ
#define WORDINPUT_WIDTH 220    //入力欄
#define WORDINPUT_HEIGHT 32
#define ROW_HEIGHT 60          //リストの縦の大きさ
#define TABLE_WORDLABEL_TAG 1  //英単語表示のラベル番号
#define TABLE_MEANLABEL_TAG 2  //英単語の意味表示のラベル番号

@interface EiwaViewController ()


@property (nonatomic, retain) UITableView*        wordListView;      // 英単語検索結果結果リスト
@property (nonatomic, retain) WordInputField*     inputField;        // 調べたい単語入力欄
@property (nonatomic, retain) MeanDetailView*     detailView;        // 単語の意味の詳細表示
@property (nonatomic, retain) DictionaryDB*       dictionay;         // 英和辞典を読み込む
@property (nonatomic, retain) NSMutableArray*     words;             // 検索結果の単語一覧
@property (nonatomic )        CGPoint             touchBeginPoint;   // ユーザのフリックが開始した位置


@end

@implementation EiwaViewController

@synthesize wordListView,inputField,detailView,dictionay, words;


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    
    dictionay = [[DictionaryDB alloc] init];
	words     = [[NSMutableArray alloc] initWithCapacity:0];

    
    //入力欄の初期化
    CGRect display= [[UIScreen mainScreen] bounds];  //ディスプレイのサイズ
    CGRect rectInput = CGRectMake(5, display.size.height-KEYBOARD_HEIGHT-WORDINPUT_HEIGHT,
                                  WORDINPUT_WIDTH, WORDINPUT_HEIGHT);    //キーボードの丁度上に入力欄を設置
    inputField = [[WordInputField  alloc]initWithFrame:rectInput];
    inputField.delegate = self;
    [inputField becomeFirstResponder];
    [inputField addTarget:self action:@selector(wordInput:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:inputField];
    [self.view addSubview:inputField.inputLabel];  //カーソルを消すためにここでadd
   
    
    //単語一覧の初期化　
    [self loadTableView];       
    
}


//テーブルビュー初期化
- (void)loadTableView
{
    CGRect display= [[UIScreen mainScreen] bounds];  //ディスプレイサイズ
    
    wordListView = [[UITableView alloc] init];
    wordListView.frame = CGRectMake(0, 0, display.size.width,  //入力欄の丁度上へ配置
                                 display.size.height-KEYBOARD_HEIGHT-WORDINPUT_HEIGHT-10);
    wordListView.dataSource = self;
    wordListView.delegate = self;
    wordListView.separatorColor = [UIColor clearColor];
    wordListView.backgroundColor = [UIColor blackColor];
    wordListView.rowHeight = ROW_HEIGHT;
    
    wordListView.transform = CGAffineTransformMakeRotation(M_PI); //下から上に反転
    
    //スクロールバーを右寄せに
    static CGFloat innerOffset = 9.0;
    UIEdgeInsets insets = UIEdgeInsetsMake(
                                           0.0, // top
                                           0.0, // left
                                           0.0, // bottom
                                           CGRectGetWidth(wordListView.frame) - innerOffset // right
                                           );
    wordListView.scrollIndicatorInsets = insets;
    
    
    if([words count]==0){
        wordListView.hidden = true;  //単語リストが1件もなければ表示しない
    }
    
    [self.view addSubview:wordListView];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //セクション数
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //行数 単語数分ある。（ただし上限はSQLで既定）
    return [words count];
}

//単語リストの表示
- (UITableViewCell *)tableView:(UITableView *)paramTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    static NSString *CellIdentifier = @"Cell";
    
    UILabel *wordLabel;
    UILabel *meanLabel;
    
    UITableViewCell *cell = [paramTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {  //セルの初期化
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.transform = CGAffineTransformMakeRotation(-M_PI); //下から上に反転 (リストをしたから表示するため)
        
        CGRect display= [[UIScreen mainScreen] bounds];  //ディスプレイサイズ
        
        //単語表示
        wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0,
                                                              display.size.width*2/5-10, ROW_HEIGHT)];
        wordLabel.tag = TABLE_WORDLABEL_TAG;
        wordLabel.backgroundColor = [UIColor blackColor];
        wordLabel.textColor = [UIColor whiteColor];
        wordLabel.font =[UIFont fontWithName:@"HiraMinProN-W6" size:20];
        wordLabel.adjustsFontSizeToFitWidth =YES;                             //単語が長い場合fontサイズ縮小

        //単語の意味表示
        meanLabel = [[UILabel alloc] initWithFrame:CGRectMake(display.size.width*2/5, 0,
                                                              display.size.width, ROW_HEIGHT)]; //右の2/5を意味表示エリアに
        meanLabel.tag = TABLE_MEANLABEL_TAG;  
        meanLabel.backgroundColor = [UIColor clearColor]; //背景透過
        meanLabel.textColor = [UIColor grayColor];
        meanLabel.font =[UIFont fontWithName:@"HiraMinProN-W3" size:14];
        
        [cell.contentView addSubview:wordLabel];
        [cell.contentView addSubview:meanLabel];
    }
    else{
        //再読み込みするだけ
        wordLabel = (UILabel *)[cell.contentView viewWithTag:TABLE_WORDLABEL_TAG]; 
        meanLabel = (UILabel *)[cell.contentView viewWithTag:TABLE_MEANLABEL_TAG];
    }
    
    //セルに表示する内容
    Word* thisWord = [words objectAtIndex:indexPath.row];
    
    wordLabel.text = thisWord.word;
    meanLabel.text = thisWord.mean;
            
    return cell;
}



//テキスト入力。１文字でも入力されたら辞書検索する。
-(void)wordInput:(id)sender {
    
    [detailView closeMeanDetail]; //意味詳細を開いてたら閉じる
    
    UITextField *txt = (UITextField *)sender; //入力された文字を取り出す
    
    NSLog(@"TextField changed:%@",txt.text);
    
    NSString *inputText = txt.text;
    
    //もし文字列が空になっていたら、パスワード入力欄でのbackspaceで全削除されているので、１文字削除に手動で置き換える
    if(inputText.length==0&&inputField.inputWord.length>=2){
        inputText = [inputField.inputWord substringToIndex:inputField.inputWord.length-1];
    }
    
    if(inputText.length>20){                         //長すぎたら文字を切る。最大１２文字まで
        inputText = [inputText substringToIndex:20];
    }
    
    //入力されたワードを入力欄にセット。この際にまたwordInputが呼ばれて無限ループになるので、一旦targetから外す
    [txt removeTarget:self action:@selector(wordInput:) forControlEvents:UIControlEventEditingChanged];

    [inputField setInputText:inputText];  //入力欄に文字セット
    
    [txt    addTarget:self action:@selector(wordInput:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    if(inputField.inputWord.length>=2){                      //2文字以上入力があれば辞書検索
        NSLog(@"searching..:%@",inputField.inputWord);
        
        words = [dictionay searchWords:inputField.inputWord];
        
        NSLog(@"hit words:%d",[words count]);
        
    }
    else{
        
        //0-1文字しか入力されていなければリストをクリア
        words     = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    
    if([words count]==0){
        wordListView.hidden = true;  //単語リストが1件もなければ表示しない
    }
    else{
        wordListView.hidden = false;
    }
    
    [wordListView reloadData];//単語リストを再表示
}





//セルが選択されたときの処理
- (void)tableView:(UITableView *)paramTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [paramTableView deselectRowAtIndexPath:indexPath animated:YES]; 
    
    Word *selectedWord = words[indexPath.row];
    
    //いま表示されている単語をタッチしたら閉じるだけにする
    if([detailView.wordLabel.text isEqualToString:selectedWord.word]&&
       detailView.frame.origin.x < self.view.frame.size.width){
        
       [detailView closeMeanDetail]; //意味詳細が開いてたら閉じる処理
        
    }
    else{ 
        [self showWordDetail:selectedWord.word meanDetail:selectedWord.mean]; //選択された単語の意味を開く
    }
}

//英単語の意味詳細表示
-(void)showWordDetail:(NSString*)wordTitle meanDetail:(NSString*)meanDetail
{
    int DETAIL_X     = 100; //詳細表示の開始位置
    int DETAIL_WIDTH = self.view.frame.size.width-DETAIL_X; //詳細表示の横幅
    

    
    // 遷移先UIViewを画面外に生成
    if(detailView == nil){
        
        detailView = [[MeanDetailView alloc]initWithFrame:CGRectMake(self.view.frame.size.width + 1, 0,
                                                         DETAIL_WIDTH, wordListView.frame.size.height)];

        detailView.nextResponderMeanDetailView = self;  //タッチされた時の処理をこのクラスに移譲
        [self.view addSubview:detailView];
    }
    else{
        [detailView closeMeanDetail];  //作成済みなら画面外に移動させておく
    }
    
    [detailView showMeanDetail:wordTitle meanDetail:meanDetail X:DETAIL_X];


}

//キーボードのDONEボタンが押された時 入力をクリアする
- (BOOL)textFieldShouldReturn:(UITextField *)returnText {
    [self clearField];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView  //単語リストがスクロールされた時
{
    [detailView closeMeanDetail]; //意味詳細が開いてたら閉じる
}

//バックグラウンドから再開した時の処理。入力をクリアする
-(void)applicationWillEnterForeground  
{
    [self clearField];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField //クリアボタンが押されたら全てクリア
{   
    [inputField setInputWord:@""];
    return YES;
}


//入力内容をクリアする処理
-(void)clearField
{
    [detailView closeMeanDetail]; //意味詳細が開いてたら閉じる
    
    //入力欄・結果をクリアする
    [inputField setInputText:@""];

    words     = [[NSMutableArray alloc] initWithCapacity:0];
    wordListView.hidden = true;
    
    [wordListView reloadData];
    
}


//フリックされた時の処理  意味詳細を閉じる判断に利用
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touchBegan = [touches anyObject];
    self.touchBeginPoint = [touchBegan locationInView: detailView];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touchEnded = [touches anyObject];
    CGPoint touchEndPoint = [ touchEnded locationInView: detailView];
    NSInteger distanceHorizontal = ABS( touchEndPoint.x - self.touchBeginPoint.x );
    NSInteger distanceVertical = ABS( touchEndPoint.y - self.touchBeginPoint.y );

    
    if ( distanceHorizontal > distanceVertical ) {
        if ( touchEndPoint.x > self.touchBeginPoint.x ) {
            //NSLog(@"RIGHT Flick");
            [detailView closeMeanDetail]; //意味詳細が開いてたら閉じる(画面上どこを右フリックしてもいいものとする）
        } else {
            //NSLog(@"LEFT Flick");
        }
    } else {
        if ( touchEndPoint.y > self.touchBeginPoint.y ) {
            //NSLog(@"DOWN Flick");
        } else {
            //NSLog(@"UP Flick");
        }
    }
}

@end
