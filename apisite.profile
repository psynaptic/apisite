<?php
// $Id$

/**
 * @file
 * Main API Site installation profile file.
 */

/**
 * Implementation of hook_profile_details().
 */
function apisite_profile_details() {
  return array(
    'name' => 'API Site',
    'description' => 'API Site creates a Drupal site that provides API documentation similar to <a href="http://api.drupal.org">api.drupal.org</a>.',
  );
}

/**
 * Implementation of hook_profile_modules().
 */
function apisite_profile_modules() {
  global $install_locale;
  $modules = array(
    'install_profile_api',
    'block',
    'color',
    'dblog',
    'filter',
    'help',
    'menu',
    'node',
    'search',
    'system',
    'taxonomy',
    'update',
    'upload',
    'user',
    'admin_menu',
    'jquery_update',
    'job_queue',
  );
  return $modules;
}

/**
 * Implementation of hook_profile_tasks().
 */
function apisite_profile_tasks(&$task, $url) {
  global $install_locale;
  
  // Use the Install Profile API
  install_include(apisite_profile_modules());
  
  // For task profile
  if ($task == 'profile') {
    // Install API module here because of its
    // weird requirement behavior
    drupal_install_modules(array('api' => 'api'));
    
    // Create batch
    $batch['title'] = t('Configuring @drupal', array('@drupal' => drupal_install_profile_name()));
    $batch['operations'][] = array('_apisite_batch_branches', array());
    $batch['operations'][] = array('_apisite_batch_theme', array());
    $batch['operations'][] = array('_apisite_batch_blocks', array());
    $batch['operations'][] = array('_apisite_batch_menu', array());
    $batch['operations'][] = array('_apisite_batch_index', array());
    $batch['operations'][] = array('_apisite_batch_finalize', array());
    $batch['finished'] = '_apisite_setup_finished';
    
    variable_set('install_task', 'apisite-setup');
    batch_set($batch);
    batch_process($url, $url);
    return;
  }
  
  // Arbitratry task
  if ($task == 'apisite-setup') {
    include_once 'includes/batch.inc';
    $output = _batch_page();
    return $output;
  }
}

/**
 * Finish configuration batch
 */
function _apisite_setup_finished($success, $results, $operations) {
  if ($success) {
    // Here we do something meaningful with the results.
    $message = count($results) . ' actions processed.';
    $message .= theme('item_list', $results);
    $type = 'status';
  }
  else {
    // An error occurred.
    // $operations contains the operations that remained unprocessed.
    $error_operation = reset($operations);
    $message = 'An error occurred while processing ' . $error_operation[0] . ' with arguments :' . print_r($error_operation[0], TRUE);
    $type = 'error';
  }

  // Clear out any status messages that modules may have thrown, as we're
  // setting our own for the profile.  Leave error messages, however.
  drupal_get_messages('status');
  drupal_set_message($message, $type);

  // Advance the installer task.
  variable_set('install_task', 'profile-finished');
}

/**
 * Branch items for API Site
 */
function _apisite_batch_branches($args, &$context) {
  $items = _apisite_get_branches();
  
  // Create branches for API
  foreach ($items as $item) {
    drupal_write_record('api_branch', $item);
  }
  $context['results'][] = t('Created API branches.');
  
  // Set default API
  variable_set('api_default_branch', 'drupal_6');
  $context['results'][] = t('Set default API to Drupal 6.');
  
  // Batch processing
  $context['message'] = t('API Branch setup.');
}

/**
 * Theme batch process
 */
function _apisite_batch_theme($args, &$context) {
  $themes = system_theme_data();
  
  // Enable themes
  install_default_theme('pixture');
  $context['results'][] = t('Set default theme to Pixture.');
  variable_set('admin_theme', 'garland');
  $context['results'][] = t('Set default admin theme to Slate.');
  
  // Set random theme for fun (DOES NOT WORK AT THE MOMENT)
  $schemes = _apisite_picture_schemes();
  $settings = variable_get('theme_pixture_settings', array());
  $settings['scheme'] = array_rand($schemes);
  variable_set('theme_pixture_settings', $settings);
  $context['results'][] = t('Attempt to set Picture color.');
  
  // Batch processing
  $context['message'] = t('Theme processing.');
}

/**
 * Blocks items for API Site
 */
function _apisite_batch_blocks($args, &$context) {
  system_initialize_theme_blocks('theme_name');
  $items = array();
  $theme = 'pixture';
  $region = 'left';
  
  $items['api-search'] = new stdClass;
  $items['api-search']->module = 'api';
  $items['api-search']->delta = 'api-search';
  $items['api-search']->weight = -10;
  $items['api-search']->theme = $theme;
  $items['api-search']->region = $region;
  
  $items['navigation'] = new stdClass;
  $items['navigation']->module = 'api';
  $items['navigation']->delta = 'navigation';
  $items['navigation']->weight = -5;
  $items['navigation']->theme = $theme;
  $items['navigation']->region = $region;

  // Configure blocks
  install_init_blocks();
  foreach ($items as $item) {
    install_set_block($item->module, $item->delta, $item->theme, $item->region, $item->weight);
  }
  $context['results'][] = t('Added API blocks.');
  
  // Batch processing
  $context['message'] = t('Block processing.');
}

/**
 * Menu items for API Site
 */
function _apisite_batch_menu($args, &$context) {
  // Clear menu and cache
  menu_rebuild();
  cache_clear_all();
  
  $items = array();
  $items['drupal_5'] = array(
    'menu_name' => 'primary-links',
    'link_path' => 'api/drupal_5',
    'link_title' => t('Drupal 5'),
    'weight' => 1,
    'mlid' => 0,
    'plid' => 0,
  ); 
  $items['drupal_6'] = array(
    'menu_name' => 'primary-links',
    'link_path' => 'api/drupal_6',
    'link_title' => t('Drupal 6'),
    'weight' => 2,
    'mlid' => 0,
    'plid' => 0,
  ); 
  $items['drupal_7'] = array(
    'menu_name' => 'primary-links',
    'link_path' => 'api/drupal_7',
    'link_title' => t('Drupal 7'),
    'weight' => 3,
    'mlid' => 0,
    'plid' => 0,
  );  
  
  // Create menu items
  foreach ($items as $item) {
    menu_link_save($item);
  }
  $context['results'][] = t('Added Menu items for API branches.');
  
  
  // Batch processing
  $context['message'] = t('Menu processing.');
}

/**
 * Various last changes for profile
 */
function _apisite_batch_finalize($args, &$context) {
  // Set front page
  variable_set('site_frontpage', 'api');
  $context['results'][] = t('Set front page.');
  
  // Rebuild key tables/caches   
  system_theme_data();
  $context['results'][] = t('Rebuild caches ad structures.');
  
  // Batch processing
  $context['message'] = t('Various settings.');
}

/**
 * Index API files (NOT CURRENTLY WORKING)
 */
function _apisite_batch_index($args, &$context) {
  // If not in 'safe mode', increase the maximum execution time:
  if (!ini_get('safe_mode')) {
    set_time_limit(0);
  }

  // Index API
  module_load_include('module', 'api', 'api');
  module_load_include('inc', 'api', 'parser');
  // This will take a while
  $branches = _apisite_get_branches();
  api_update_branch($branches['drupal_6']);
  $context['results'][] = t('Indexing Drupal 6 API files.');
  
  // Batch processing
  $context['message'] = t('API index processing.');
}

/**
 * Defined branches
 */
function _apisite_get_branches() {
  $items = array();
  $path = realpath('.');
  
  $branch = new stdClass;
  $branch->branch_name = 'drupal_5';
  $branch->title = 'Drupal 5';
  $branch->directories = $path . '/sites/all/libraries/drupal_5';
  $branch->weight = 5;
  $items['drupal_5'] = $branch;
  
  $branch = new stdClass;
  $branch->branch_name = 'drupal_6';
  $branch->title = 'Drupal 6';
  $branch->directories = $path . '/sites/all/libraries/drupal_6';
  $branch->weight = 6;
  $items['drupal_6'] = $branch;
  
  $branch = new stdClass;
  $branch->branch_name = 'drupal_7';
  $branch->title = 'Drupal 7';
  $branch->directories = $path . '/sites/all/libraries/drupal_7';
  $branch->weight = 7;
  $items['drupal_7'] = $branch;
  
  return $items;
}

/**
 * Pixture color schemes
 */
function _apisite_picture_schemes() {
  $items = array();
  // Pre-defined color schemes
  $items = array(
    '#eb52c1,#b21f88,#b800a6,#ff6bfe,#555555' => t('Girly Pink (Default)'),
    '#de8291,#c55964,#861509,#f8306a,#555555' => t('Red Carpet'),
    '#d59648,#865518,#572e05,#eb8919,#555555' => t('Caramel Brown'),
    '#cfb377,#90712c,#463406,#e6bd5c,#555555' => t('Earth Brown'),
    '#f7b42b,#8e6130,#ec8c04,#fade42,#555555' => t('Orange Sunset'),
    '#d1bc00,#6c7019,#d5be01,#f0fd58,#555555' => t('Gold Yellow'),
    '#afc94a,#61751f,#2d3701,#d2f943,#555555' => t('Olive Garden'),
    '#9bc068,#3c7c41,#0e3d0b,#6beb37,#555555' => t('Forest Green'),
    '#83b49f,#486156,#174431,#52bf90,#555555' => t('Teal'),
    '#76c9cb,#317d81,#054f52,#00d1bc,#555555' => t('Aquamarine'),
    '#7bc0ea,#3561b1,#025fb1,#62c8fd,#555555' => t('Ocen Water'),
    '#9ab1f9,#4b5cc3,#062984,#5283ff,#555555' => t('Deep Blue'),
    '#b0a2f6,#7958a7,#25008f,#c49eff,#555555' => t('Purple Haze'),
    '#ba90c6,#935b9f,#250c27,#c271d0,#555555' => t('Violet'),
    '#9397d7,#575dc1,#091c3e,#d0d6f6,#555555' => t('Graphite'),
    '#54677d,#3d5c85,#282e39,#8692a7,#555555' => t('Ash'),
    '#aaaeb1,#4d637a,#8c909b,#eeecec,#555555' => t('Silver'),
  );
  return $items;
}

/**
 * Debug function (not very good)
 */
function apipr($var) {
  $output = 
    '-----------------------------------------------------
    <pre>'
    . var_export($var, TRUE) .
    '</pre>';
  $mission = variable_get('site_mission', '');
  variable_set('site_mission', $mission . $output);
  drupal_set_message($output);
}