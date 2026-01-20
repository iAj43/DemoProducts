# DemoProducts
DemoProducts is a UIKit-based iOS App that displays a list of products from a paginated API.
Selecting a product navigates to a detail screen showing full information.

## Features
* Product list using `UITableView`
* Pagination using API `nextPage`
* Product detail screen
* Loading indicator while fetching data
* Error handling with retry option
* Empty state when no data is returned
* Lazy image loading with caching

## API Used
```
https://fakeapi.net/products?page=0&limit=10&category=electronics
```
* Pagination starts from `page = 0`
* Next page is fetched using `nextPage` from the API response

## Architecture
* UIKit + MVVM
* URLSession for networking
* Codable for JSON parsing
* Clean separation of View, ViewModel, and networking layers


## Testing
* Unit tests for `ProductListViewModel`
* Covers success, pagination, empty response, and error cases
* Uses mocked use case (no real API calls)

## Demo
* Screenshots: **Product List, Product Detail**

  <img width="1179" height="2422" alt="01-DemoProducts" src="https://github.com/user-attachments/assets/7b359277-daef-4785-8d0a-0b753309affd" />
<img width="1179" height="2422" alt="02-DemoProducts" src="https://github.com/user-attachments/assets/e4f39cef-32b3-4e55-8e7f-0e4c589d4e65" />

* Video: Pagination and navigation flow
https://github.com/user-attachments/assets/642ffcfe-35a6-4385-b5a8-50ff810c3cd0

## Author
**Irfan Ajmeri**
