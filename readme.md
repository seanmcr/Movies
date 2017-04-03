# Project 1 - *Movies*

**Movies** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **14** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [ ] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [ ] Implement segmented control to switch between list view and grid view.
- [ ] Add a search bar.
- [ ] All images fade in.
- [ ] For the large poster, load the low-res image first, switch to high-res when complete.
- [ ] Customize the highlight and selection effect of the cell.
- [ ] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Movie details (e.g. runtime, production companies) are loaded asynchronously after transitioning to the detail view for better performance
- [x] Applied a dark blur effect to the backdrop image to give a cool background effect on the details view and maintain continuity between the cell on the main view and the details view
- [x] Used layout constraints to enable for an adaptive design

## Video Walkthrough

Here's a walkthrough of implemented user stories:

[Movies iOS app walkthrough](http://i.imgur.com/LtOOlLW.gif)
[Showing network failure](http://i.imgur.com/T3Fmaix.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

* I ended up using layout constraints somewhat extensively throughout the app, which was really helpful in achieving the design I wanted but took more time than I intended.  Using the UIScrollView gave me a bit of a headache because of ambiguity in the content height/width
* I wasn't able to get a custom UILabel with an attributed string to display in the navigation bar.  I also tried making the navigation bar transparent and displaying the UILabel behind it, with no luck.
* I tried making a custom XIB for the network error notification so i could re-use it between views, but I couldn't figure out how to get Interface Builder to recognize my custom UIView + XIB.  Eventually I gave up.

## License

    Copyright 2017 Sean McRoskey

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
