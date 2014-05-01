This app will let you sign in and browse your assets using Imgur OAuth2 documentation. It is very basic but shows how to interact with a REST API. It currently will let you:
* Log in.
* Log out.
* Persist log in across app instances.
* Browse your first page of images (page size is 50).
* View an image full screen with zooming. 
* List your albums (no images currently). 

This app also demonstrates:
* Using background queues to make requests without freezing the UI
* Submitting HTTP requests (CRUD)
* Assembling query strings from classes
* Parsing json data
* UICollectionView (datasource, delegate, flow layout). 
* UIPageView
* Custom UIViewController transitions


Some notes about this app. 
* It stores your Imgur credentials unencrypted in NSUserDefaults. Obviously this would not be good to release to the public. 
* There are stubbed out REST calls for other endpoints listed in the Imgur documentation. 
* The JSON parsing should probably be done in a background queue. Parsing 50 data structures is fairly fast and you can get away with it on the main thread but any larger requests will cause the UI to freeze briefly. 
* The loading transition for the UIWebView needs some work, but the point of this app isn't to be pretty (at least in this stage). 
* The master/detail view isn't ideal as you can't see the current detail view. It would be nice to have the detail page move over, but not off the screen. 

