; Drupal core
; -----------
core = 6.x
projects[drupal][type] = core
projects[drupal][version] = "6.22"

; Drush Make API version
; -----------
api = 2

; Contrib modules
; -----------

; The dev version of API has all of the new functionality. It is worth using it
; instead of the stable version, which is now quite old.
projects[api][type] = "module"
projects[api][download][type] = "git"
projects[api][download][url] = "http://git.drupal.org/project/api.git"
projects[api][download][revision] = "6e4ea4ff965307b03c5546617da5b2b46be12c12"
projects[api][subdir] = contrib
; Add patch to improve directory parsing performance and memory usage by
; skipping hidden any blacklisted directories. See
; http://drupal.org/node/1411648 for further information.
projects[api][patch][] = "http://drupal.org/files/1411648-onlythis.patch"


projects[autoload][version] = 2.1
projects[autoload][subdir] = contrib

projects[ctools][version] = 1.8
projects[ctools][subdir] = contrib

; Grammar Parser does not have a 6.x release but the 7.x code is compatible
; with D6 by simply patching the .info file. This is recommended on the project
; page. See http://drupal.org/node/994518 for more information.
; @todo update patch for the 7.2 release.
projects[grammar_parser][type] = module
projects[grammar_parser][download][type] = get
projects[grammar_parser][download][url] = http://ftp.drupal.org/files/projects/grammar_parser-7.x-1.1.tar.gz
projects[grammar_parser][subdir] = contrib
projects[grammar_parser][patch][] = "http://drupal.org/files/issues/grammar_parser.info.patch"

projects[job_queue][version] = 3.1
projects[job_queue][subdir] = contrib
