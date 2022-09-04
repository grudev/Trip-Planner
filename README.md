
## Table of contents
* [General info](#general-info)
* [Technical task](#technical-task)
* [Technologies](#technologies)
* [Setup](#setup)

## General info
This project is a technical task that aims to demonstrate a scalable architecture for a real project.

## Technical task

*Trip Planner*
 
Write an app that helps users select the most convenient route between our destinations. 
 
Download and parse information from: 

```https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connect ions.json``` 
 
The JSON contains a list of flight connections with the relative price and position. 
The user should be able to select ​any​ departure city and ​any​ destination city available (even if a ​direct connection​ between the two cities is not available) 
The purpose of this app is to find the cheapest route​	 between the two cities that the​	 user select and to show the total price in a label in the same page 
Use coordinates available in the JSON to show the cheapest selected route on a​	 map  
BONUS: To select the cities use a text field with autocomplete (from the list of the available cities you get from the JSON) 
 
*Instructions: *
Write the app thinking about code reusability and SOLID principles -	Don’t pay too much attention to UI/UX, use standard UI elements instead. 
Code in the latest version of Swift
Use iOS SDK version of your choice. 
Don’t use any 3rd party tools/frameworks but, you can use any Apple provided libraries. 
Return Xcode project, zipped or uploaded to your Github and few words about your code. 
Do Test-driven Development and write meaningful unit tests 
Please note that we have different datasets for testing and we expect that your app still works with different cities and/or prices 

	
## Technologies
Project is created with:
* Swift version 5
* Xcode 13.4.1

Project architecture used is MVVM with Coordinator. Protocols (Abstractions) are used between all layers of the architecture with the purpose to easily mock dependencies and isolate objects. Main principles used are S.O.L.I.D. principles. Single Coordinator object can handle a stack of screens (Flow) logically connected. When lifecycle of this flow ends it can launch another coordinator or bring focus to a parent Coordinator. Every Coordinator can handle different presentation style like FullScreen, FormSheet, Popover etc.

New Async-Await language feature is used to improve code readability.
Combine is used most commonly to help in communication between ViewController and ViewModel or ViewModel and Coordinator.

	
## Setup
To run this project, just double click on *Trip Planner.xcodeproj* file
