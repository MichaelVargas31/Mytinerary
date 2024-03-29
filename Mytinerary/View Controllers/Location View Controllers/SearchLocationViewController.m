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
    
    self.searchBar.showsCancelButton = true;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocationCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCellTableViewCell" forIndexPath:indexPath];
    
    Location *location = self.results[indexPath.row];
    
    cell.location = location;
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

# pragma - search bar

- (BOOL)searchBar:(UISearchBar *)searchBar shoulkladChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    return true;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self GoogleAPIImplementation:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma - Google API

-(void)GoogleAPIImplementation:(NSString *)query {
    
    NSLog(@"%@", self.searchBar.text);
    
    NSString *base = @"https://maps.googleapis.com/maps/api/place/textsearch/json?";
    // Getting the api key from the keys file
    NSString * path = [NSBundle.mainBundle pathForResource:@"Keys" ofType:@"plist"];
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *apiKey = keys[@"googleSearchApiKey"];
    NSString *qString = [NSString stringWithFormat:@"input=%@&inputtype=textquery&fields=name,formatted_address,geometry,type&key=%@",self.searchBar.text,apiKey];
    
    qString = [qString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[base stringByAppendingString:qString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          
            NSArray *locations = [responseDictionary valueForKeyPath: @"results"];
            self.results = [Location initWithDictionaries:locations];
            
            [self.tableView reloadData];
        }
        else {
            NSLog(@"error fetching locations: %@", error);
        }
    }];;
    [task resume];
}

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
