//
//  SearchLocationViewController.m
//
//
//  Created by samason1 on 7/22/19.
//

#import "SearchLocationViewController.h"
#import "LocationCellTableViewCell.h"
#import "Location.h"

@interface SearchLocationViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>


@end

@implementation SearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCellTableViewCell" forIndexPath:indexPath];
    Location *location = self.results[indexPath.row];
    
    cell.eventName.text = location.name;
    cell.eventAddress.text = location.address;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        Location *location = self.results[indexPath.row];
        [self.delegate didTapLocation:location textField:self.textField];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        NSLog(@"search delegate is null");
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shoulkladChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    return true;
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self GoogleAPIImplementation:searchBar.text];
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [self GoogleAPIImplementation:searchBar.text];
//}

-(void)GoogleAPIImplementation:(NSString *)query {
    NSString *base = @"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?";
    // Getting the api key from the
    NSString * path = [NSBundle.mainBundle pathForResource:@"Keys" ofType:@"plist"];
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *apiKey = keys[@"googleSearchApiKey"];
    NSString *qString = [NSString stringWithFormat:@"input=%@&inputtype=textquery&fields=name,formatted_address,geometry,type&key=%@", query, apiKey];
    
    qString = [qString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[base stringByAppendingString:qString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *locations = [responseDictionary valueForKeyPath: @"candidates"];
            self.results = [Location initWithDictionaries:locations];
            
            [self.tableView reloadData];
        }
    }];;
    [task resume];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (IBAction)onTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
