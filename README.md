# ItunesBrowser

## Design Patterns Applied

### MVC (Model-View-Controller)

The main application utilizes the MVC model where the view controller handles the UI Logic, while the data is separated by employing a model class to contain them. The data related queries and caching, in my implementation, is handled by the model. For me it makes sense to have the model manage the data in order to purely separate the concerns between the UI and Data logic.

### Singleton

The main model of this application uses the Singleton pattern. This is to ensure that there is a single source of data across the application. 
