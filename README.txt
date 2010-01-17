API Site instaltion profile is an attempt 
to automate the process of creating a Drupal API
site.

A local Drupal API site is beneficial if you are without
internet.  A public or internal API site can be
very helpful for contributed modules and if Drupal.org
goes down.


Notes
=========================================
Drush Make vs Drupal.org Distribution

Though this installtion profile only includes
valid Drupal code, the way it stores the different
drupal versions, the Drupa.org Distribution will
not include the needed API files.

It is very suggested to install this via
Drush Make.


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


TO DO
=========================================
Due to how Drupal caches theme data in the installation
process, I cannot seem to get the Pixture color
scheme to change to something else (other than pink).

Also, I cannot seem to automate the process of indexing
the API files.