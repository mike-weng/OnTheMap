# OnTheMap

OnTheMap app allows you to share geo-location and some text data with other users; the geo-location will be presented as a pin on the map. Users are able to simply tap on a certain location to create a pin and attach text data. Users are also able to view pins that were created by other users on the same map. This app shows my ability to build software that incorporates networking and frameworks such as MapKit, FacebookSDK, Parse.

he main feature of this application is showing the usage of networking in Swift. I have utilized best practices such as establishing NSURLSession to retrieve and upload json data from the network. I build a custom API client that connects to the Udacity API and also the Parse API. It connects to the APIs and makes POST, GET, PUT, DELETE and Query requests. It does this while utilizing MVC to the full extent in the sense that all API calls are done in the background while the view remains responsive.

By following the MVC design pattern, I abstracted away most of the functionalities into the model classes that allows my View Controllers to be lightweight. 

One of the main problems with networking is the time taken to process queries. For better user experience, the processing of queries should be done in background while allowing the UI to be active. To keep the UI responsive, I used Grand Central Dispatch to run UI Events on the one of three of the Global Queues. Some of the network API calls also happen in a Utility GCD Queue.

## Installation

1. git clone https://github.com/mmmk84512/OnTheMap
2. open OnTheMap.xcodeproj

## Features
- Login using Udacity's authenication API
- POST GET and DELETE Data from Udacity and Parse
- View pins created by other users on the map
- View locations posted by other users in a table view
- Post a geo-location with a link to the network that allows other users to view
- Login (authorize and authenticate) your account through Facebook.

## Project Overview

### Login View

This view is responsible for authorising and authenticating users from their login details. User will be prompted to enter their username and password. Pressing the login button will send a authentication query to the network client for verification. Alternatively, user can press the 'login with facebook' button to use their facebook account for authentication.

### List View

This view consists of all the pins created by other users in a list format. Upon loading the screen, all the data will be retrieved using GET query to the server.

### Map View

### Post View

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request
