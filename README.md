# Splitsy
HackCUNY-2024(RL,MA,AT)

## Inspiration

NYC has a huge restaurant scene and is a big contributors to the dining industry. Our residents eat out a lot and one of the biggest annoying parts of eating out with friends is splitting the bill at the end of the night. Usually one person puts down their card and then calculate every person's owed amount. Not only do they have to fidget with their calculator app to do so, but they also have to do each person individually based on what they order...because why should the person who ordered 10$ worth of things be splitting evenly with the person who ordered 80$.

## What it does
Splitsy is an iOS app that is intended to make your life easier by providing a simple solution to this splitting problem. All you have to do is scan your receipt at the end of your hangout and Splitsy will automatically detect the total price and itemized items with their quantity and price. Then you could either choose a divide evenly option or a divide per person option to determine how you want to split the bill. After adding people to the session and putting in your tip percentage and tax Splitsy will calculate based on what food each person ordered their total that they must pay back.

## How we built it
Our main proof of concept is done with Figma and our attempt at a working prototype was done using Swift and the SwiftUI library. We attempted to use several different OCR receipt scanning APIs including Asprise and Taggun to see which one worked best and how to properly process the receipt data.

<picture><img src = "https://github.com/Riyuanliu/Splitsy/blob/main/Splitsy/Simulator Screenshot - iPhone 15 Pro - 2024-02-18 at 11.35.37.png" width = 200px></picture>
## Challenges we ran into

Actually finishing was a major issue. None of our team members had experience with Swift or making an app in general which is why ultimately we fell short of our goal. It took forever to figure out what was even going on. We were able to get the API working to return processed data and got some views running in Swift but they definitely needed more finish and refinement and actual cohesion. 

## Accomplishments that we're proud of

The idea in our eyes was a success as it is an app that we all saw ourselves using. We all experienced the same problem at some point in our lives and as college students who are low on money, managing those dining finances is important to us. I think we can up with great concepts that can be refined and actually implemented moving forward. We managed to brainstorm a solution to a small yet personal problem and we think that's an accomplishment on its own.

## Data accessing
After we have upload the picture, we use a OCR Api for the receipt, it will return the data in json file, which allow us to access this information during the calucation process.

<picture><img src = "https://github.com/Riyuanliu/Splitsy/blob/main/Data.png" width = 200px></picture>

## What we learned

Don't bite off more than you can chew especially with a language you've never worked with before. That really frustrated us and ultimately was our failing point. But on a technical aspect, we got more experience with frontend UI work and got a glimpse into how APIs work on a deeper level and how useful (and expensive) they are. 


## What's next for Splitsy

We want to get a working MVP going that is a working app atleast. This means having the basic features of the receipt scanning and divide per person/evenly functionality as the main feature and running smoothly and cohesively. In the future we envision being able to use databases to enhance these base feature by storing past receipt and dining history. 
