# Lists

Lists is a Ruby On Rails web-based application, where users can signup and create and collaborate on task lists. Each list has its own tasks and tasks can be tagged with any of multiple shared tags. Overdue tasks are noted on the list's display page. A search feature allows users to query their tasks.

The user login and signup administration is implemented using the Devise gem. Additionally, Devise/Omniauth is configured for signup/login through the GitHub auth API.

I set a Bootstrap theme, Cyborg, to give the app some color, and used the 'devise-bootstrap-views' gem to add Boostrap templating to the login views.

### Models

Perhaps the most interesting is the join table `user_lists`, which allows users to share lists by associating many users with many lists. Aside from `user_id` and `list_id`, a `permission` column enables a differentiation between `creator` and `collaborator` to be used in setting resource access and use policies. Other interesting methods include a `collaborators=` method for the List class, which takes a string of emails as input and sets the list's users array and their permissions; methods that allow to query a user's permission for a list; and the list class `search` method, which queries the user's tasks joined by tags.

I chose to write `policy.rb`, a module in the 'models' folder that implements resource authorization, myself rather than use one of the popular libraries, such as Pundit, to experiment and learn. Including the module in both `ApplicationController` and `ApplicatonHelper` allows for controller and view resource authorization where appropriate. Controllers rely on it heavily, as would be expected. The views use it sparingly, for example to determine whether to render a 'delete' or 'edit' resource link when appropriate.

Like 'collaborators', tags are also set via a custom `tags_attributes=` method for tasks that checks for uniquness and are added to a task through a nested 'collection_check_boxes' and 'fields_for' in the task form. Tags can only be edited or destoyed by admins. The `:admin` role is set via an user's `enum role:` attribute, currently only manually, by another admin, of course!

### Views

As with allocating logic to models and helpers as much as possible, as much as I could, I chose to extract reusable views into partials - the same form for `new` and `edit`, as well as a `top` and `bottom` Boostrap column layout; and the customary `nav` and flash message templating. Validation errors are rendered with a Boostrap 'alert' class. A partial and ListsHelper extract the formatting for search query results.

### Controllers

Perhaps the most interesting here is the logic implemented for the nested `lists/:id/tasks/:id` resource. In order to implement an `edit` task action, a check is needed to confirm the list id already exists as well as the task. The extra test does not seem necessary for the `create` task action since the 'new task' form is only rendered as part of the 'list show' show page so we know the list already exists.

### Challenges

Implementing the `collaborators=` included a hurdle: I first named the method `users=` and discovered that when the code reached a line attempting to save the newly constructed array of the list's users, `users = newly_constructed_users_array`, of course the method tried to call itself! Resulting in an error of course. Renaming it to `collaborators=` helped stay clear of that kind of interference.

### Pleasures

I liked writing and implementing my own authorization policy, as well as enabling text input for setting the list's collaborators by email addresses. I also liked working on the complex list show page, which includes a new task form as well as details about collaborators and the different tasks.

Thanks you for reading! I hope you'll enjoy any time with the applicaton.
