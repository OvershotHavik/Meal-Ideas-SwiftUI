# Meal-Ideas-SwiftUI


Note: The API keys are not included in this project. You will see errors in the Constants File due to this. Uncomment the API Key class right above the Base URL class to clear the errors. The network calls for all but MealDB Surprise Me will not bring back results due to this. 




Meal Ideas was designed with SwiftUI. It uses a tab view across the bottom to allow user to switch between sources. It uses environment to allow the same search to be done across each source automatically. 

What Meal Ideas does: 
Allows users to create a meal idea for future use. It also allows them to search other sources: MealDB and Spoonacular. Each source has the options to search by category, ingredient, and keyword. They can also tap Surprise Me for a random meal from the respective source.  For User Meals the option to show all meals created is under Custom. 

Each meal the user taps on will get logged into history. They can also favorite the meals they like. These are separated so each source only shows meals belonging to them. The user can unfavorite or delete history from the appropriate views located on the top view. These are also stored in CloudKit so they can be viewed across any of their devices.

The user meals are stored in Core Data and are synced across all devices with CloudKit. 
Each meal can consist of the following: 
- Meal Name: Only requirement 
- Meal Photo:  User can use either their camera or a photo from their library
- Category(s)
- Ingredients
- Possible sides
- Prep Time
- Instruction Photo: User can use either their camera or a photo from their library
- Recipe text
- Source

They also have an option to add their own custom category, ingredient, or side. These can be modified in the Settings tab. These are stored in CloudKit as well.

If the user changes the name of the meal they created, or deletes it altogether, history and favorites get updated so they no longer show the old meal. 

In the Settings tab, user can change the color of the top gradient to their liking which persists using AppStorage.  Any changes made to the custom items automatically update on the meals that contain them. If they delete the custom item, it gets removed from any meals.

Each list is searchable: User Meals, categories, ingredients, sides, favorites, history.

If a user taps on an image it will take them to a view to be able to zoom in and share it if they would like. 

Using adaptive grids for the search results, the meal cards adjust to the screen size so it works great on both iPhone and iPad, landscape or portrait. 

The top view auto hides as the user scrolls down, then reappears a soon as the user starts to scroll back up, or it bounces off the bottom. 

My Ideas and MealDB get all results for the search in one call. However Spoonacular has infinity scroll enabled so after 15 meals are shown, it automatically calls for the next 15 meals from their database. Once the specific query runs out of results it no longer calls for more. 



As of 2/5/2022 App is fully functional at this time, ready for beta testers.

Test Flight
0.1.0 - 2/6/2022 - First beta test for family and friends

Verizon 0.1.1 update:
- Updated the onboarding images to show the phone instead of just the screenshots to clear some confusion.  Also added a "Swipe to continue" at the bottom since the page dots are hard to see in light mode.
- Adjusted some text line breaks and shortened titles so they didn't get cut off.
- Added a share button on the meal detail screens, and updated the zoomed image view so now it shares the URL of the meal if one is provided. The share button is not visible if source is not provided.

Version 0.2.0 Update:

Shopping List added!

- Tap on an ingredient from any meal, and it will get added to the shopping list tab at the bottom
- Once added to the list, you can check them off as you pick them up at the store
- You can clear the list either by checking them off and choosing "delete checked" or you can clear all
- Any items added tot he shopping card will show checked off on the meal's detail view.

Version 0.2.1
- Added onboarding for Shopping List
- Added a label on the ingredient list to alert the user that it was added/removed from the shopping list
- Added the option to have the user tap an image while creating their meal to get to the zoom view

Pre Launch Update: March 6 2022
- Added an option for the user to add misc items to the shopping list
- Updated colors and constants throughout the app
- Fixed spoon so now it verifies the category is searchable for it before doing category and nto just custom

Version 1.1.0:  April 2 2022
- Sharing
    - You can now share your shopping list via text, email, etc.
        - All of your shopping list will be shared. Any selected items will show a check mark next to them.
    - You can now share your meals via text, email, etc. 
        - When you share your meal, the photo’s and any information you provided will be shared as text. Sharing between other users within My Meal Ideas is not supported at this time. 
- Auto color adjustment
    - If you select a color that is darker, the text and buttons will switch to white. If you choose a lighter color, the font and buttons will switch to black. This applies to the area where the color is shown only. 
- Check mark placement
    - Moved the check mark to the left so it is closer to what you selected.
- Copy text from a photo
    - Within the create meal screen, there is now a button above the text field. When you tap this it will take you to a screen to walk you through how to copy text from a photo to save time when entering the information in.
- Minor bug fixes and rewording
- Updated pictures for onboarding and App Store to reflect changes.

Version 1.1.1 update:  May 1 2022
- Added image compression to save space on the device and iCloud.
- Added an alert when typing a meal name to advise if what has been typed in so far is already in use.
- Added Unit tests for the three sources for the meals. 
- Converted MealDB from Async/Await to Combine for the experience and reference. Left the network calls in the Network Manager for future use if I decide to switch it back to async/await.

If you have created a meal with an image, please go back and make a change to the meal, such as add a space to the end of the meal name, save it, then go back in and remove the space. This will save the image with the compression. Any future meals saved will have the compression added automatically. 
