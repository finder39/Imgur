This app will let you sign in and browse your assets using Imgur OAuth2 documentation. It is very basic but shows how to interact with a REST API. It currently will let you:
* Log in (See VWWImgurController).
* Log out.
* Persist log in across app instances (unecrypted).
* Browse your first page of images (page size is 50) (See VWWImagesViewController).
* View an image full screen with zooming (See VWWAssetFullscreenRootViewController and VWWAssetFullscreenDataViewController). 
* List your albums (no images currently) (See VWWAlbumsViewController). 

This app also demonstrates:
* Using background queues to make requests without freezing the UI
* Submitting HTTP requests (REST/CRUD)
* Assembling query strings from classes
* Parsing json data
* UICollectionView (datasource, delegate, flow layout). 
* UIPageView
* Custom UIViewController transitions


Some notes about this app. 
* It stores your Imgur credentials unencrypted in NSUserDefaults (VWWUserDefaults). Obviously this would not be good to release to the public. Some solutions to this:
	* Use Keychain to securly store in the system's Keychain. Drawback: If the app is uninstalled, your encrypted credentials remain on the device. 
	* Archive with NSKeyedArchiver. Store in file, NSUserDefaults, iCloud, CoreData, etc...
	* Encrypt using RSA or similar. Store in NSUserDefaults, file, iCloud, CoreData, etc...
* There are stubbed out REST calls for other endpoints listed in the Imgur documentation (See VWWRESTEngine). One could easily extrapolate what exists in VWWRESTEngine, VWWRESTParser, and VWWRESTConfig to support all other Imgur functionality. 
* The JSON parsing should be done in a background queue (See VWWRESTParser). Current calls are paged with up to 50 data structures, and parsing this is fairly fast. You can get away with it on the main thread but there is no reason to run it on the main thread.
* The UIViewController transitions could definitely be prettier, but the point of this app isn't to be pretty (at least in this stage). 
* The master/detail view isn't ideal as you can't see the current detail view. It would be nice to have the detail page move over, but not off the screen. 

