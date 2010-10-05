SnorVember - a 'frankenstein marriage' of facial hair
=====================================================

First there was Movember, but it really failed in terms of having a good website. Then came Snoranje, whos website rocked. The two of them got together and SnorVember was born.

The current project you see here is the very barebones skeleton of what will be the final product. So bare with me as we add Cucumber stories/features, a good testing workflow, and the start of the design and layout.

On the agenda
-------------

  - Registrations

  - Facebook integration

  - Teams

  - Donations

  - Leaderboards and all that jazz

  - some Admin goodness

  - and translations, translations, translations


To get up and running
---------------------

Make sure you have Ruby 1.8.7 (rvm is recommended, but whatever floats your boat), the bundler gem, and MongoDB installed.

Start Mongo, then type:

    rails s

and you should be good to go.

It is also recommended that you add the following to your host file:

    snorvember.local

This makes sure your other localhost cookies don't get mashed in the process.


Some other info, mostly testing
-------------------------------

We are using both Cucumber with RSpec2 for a combination of unit testing and integration tests. RSpec is used for basic model unit tests and unit tests for complex functionality (map reduce stats). Cucumber is all about the website; public, users and admin.

As well as RSpec, we also use Shoulda matchers, for more info on these matchers go to:

    http://rdoc.info/gems/shoulda/2.11.3/Shoulda/ActiveRecord/Matchers


Extra links for FB Connection stuff
-----------------------------------

  - http://developers.facebook.com/docs/authentication/
  - http://developers.facebook.com/docs/reference/javascript/
  - http://developers.facebook.com/docs/authentication/javascript
  - http://www.facebook.com/developers/apps.php?app_id=106266066102294&ret=2
  - http://github.com/facebook
  - http://github.com/facebook/connect-js