API Site installation profile is an attempt to automate the process of creating
a Drupal API site.

A local Drupal API site is beneficial if you are without internet.  A public or
internal API site can be very helpful for contributed modules and if Drupal.org
goes down.


Notes
=========================================
Drush Make vs Drupal.org Distribution

Though this installation profile only includes valid Drupal code, the way it
stores the different Drupal versions, the Drupal.org Distribution will not
include the needed API files.

It is very suggested to install this via Drush Make.


Installation
=========================================
1) Install Drush
2) Install Drush Make
3) drush make apisite.make {site_dir}
4) cd {site_dir}
5) drush dl apisite
6) Install Drupal with API Site profile
7) Run cron until there are no more jobs left 
   in the queue (will take some time)

To do
=========================================

This profile helps with aggregating all dependencies for an API site but doesn't
go as far as setting up the API module for you. The immediate to do list is the
following:

- Work out a way to enable API module on installation without running into the
  requirements problem.
- Enable API navigation and search blocks on installation.
- Set "access API reference" permission on installation.
- Set home page to api.