# BillSplit
I made this project to get my hands dirty with iOS development. In retrospect, this might take longer than necessary but at least it's neat :)

... Also, sorry for the image sizing in advance

This app helps you to split a large bill out fairly among friends (especially if people are sharing plates and/or drinks)

# Step One

![Screen Set 1](https://github.com/vinhvu200/BillSplit/raw/master/DemoImage/Set1.png "Screen Set 1")

You will select an image from your phone to be processed.
- tap process when you are ready

# Step Two

![Screen Set 2](https://github.com/vinhvu200/BillSplit/raw/master/DemoImage/Set2.png "Screen Set 2")

After the image is processed with TesseractOCR, each line is parsed out in a table view for you to edit. The hope was that it can parse out item well enough for you to make out the name and price to edit but the image is also placed there in case it is unreadable.
- Double tap the text to edit item name
- Tap on the green box to edit price
- Tap on red box to remove the item
- Tap on Done when all items have been set

# Step Three

![Screen Set 3](https://github.com/vinhvu200/BillSplit/raw/master/DemoImage/Set3.png "Screen Set 3")

In this screen, you are able to add everyone on the bill. You can then individually select a person and tap on the item he or she holds responsibility for, as well as Tax and Tip at the top.
- The icon with the addition sign will allow you to add Users
- The icon with two people shows you everyone on the bill to select from
- The icon on each item shows everyone responsible for that item
- When a user is selected, they may tap on any items to take responsibility
- Tap done when finished

# Step Four

![Screen Set 4](https://github.com/vinhvu200/BillSplit/raw/master/DemoImage/Set4.png "Screen Set 4")

In this screen you will see the final result of how much everyone owes (tax and tip included)
- Clicking on any person will expand to show the cost of their items (after splitting)
