; Helpful links
; http://drupal.org/node/642116

; Drupal core
core = "6.x"
projects[] = "drupal" 

; Drupal contrib
projects[] = "install_profile_api"
projects[] = "admin_menu"
projects[] = "job_queue"
projects[] = "jquery_update"
projects[] = "api"

; We need the APISite profile
projects[] = "apisite"
;projects[data][type] = module
;projects[data][download][type] = cvs
;projects[data][download][module] = contributions/modules/apisite
;projects[data][download][revision] = DRUPAL-6--1

; Drupal theme
projects[] = "pixture"

; Drupal checkouts of core for API
libraries[drupal_5][download][type] = "cvs"
libraries[drupal_5][download][root] = ":pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal"
libraries[drupal_5][download][revision] = "DRUPAL-5"
libraries[drupal_5][download][module] = "drupal"
libraries[drupal_6][download][type] = "cvs"
libraries[drupal_6][download][root] = ":pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal"
libraries[drupal_6][download][revision] = "DRUPAL-6"
libraries[drupal_6][download][module] = "drupal"
libraries[drupal_7][download][type] = "cvs"
libraries[drupal_7][download][root] = ":pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal"
libraries[drupal_7][download][revision] = "HEAD"
libraries[drupal_7][download][module] = "drupal"

