<?php // -*-mode: PHP; coding:utf-8;-*-
declare(strict_types=1);
namespace MRBS;

use IntlDateFormatter;

require_once 'lib/autoload.inc';

/**************************************************************************
 *   MRBS Configuration File
 *   Configure this file for your site.
 *   You shouldn't have to modify anything outside this file.
 *
 *   This file has already been populated with the minimum set of configuration
 *   variables that you will need to change to get your system up and running.
 *   If you want to change any of the other settings in systemdefaults.inc.php
 *   or areadefaults.inc.php, then copy the relevant lines into this file
 *   and edit them here.   This file will override the default settings and
 *   when you upgrade to a new version of MRBS the config file is preserved.
 *
 *   NOTE: if you include or require other files from this file, for example
 *   to store your database details in a separate location, then you should
 *   use an absolute and not a relative pathname.
 **************************************************************************/

/**********
 * Timezone
 **********/

// The timezone your meeting rooms run in. It is especially important
// to set this if you're using PHP 5 on Linux. In this configuration
// if you don't, meetings in a different DST than you are currently
// in are offset by the DST offset incorrectly.
//
// Note that timezones can be set on a per-area basis, so strictly speaking this
// setting should be in areadefaults.inc.php, but as it is so important to set
// the right timezone it is included here.
//
// When upgrading an existing installation, this should be set to the
// timezone the web server runs in.  See the INSTALL document for more information.
//
// A list of valid timezones can be found at http://php.net/manual/timezones.php
// The following line must be uncommented by removing the '//' at the beginning
$timezone = "Asia/Colombo";



/*******************
 * Database settings
 ******************/

// If you are using cPanel on your web server, make sure you include the prefix,
// typically 8 characters followed by an underscore, in your database name and
// database username.  For example $db_database = "abcdefgh_mrbs". (Note: this
// prefix is not the same as the table prefix below.)

// Which database system: "pgsql"=PostgreSQL, "mysql"=MySQL
$dbsys = "mysql";
// Hostname of database server. For pgsql, can use "" instead of localhost
// to use Unix Domain Sockets instead of TCP/IP. For mysql "localhost"
// tells the system to use Unix Domain Sockets, and $db_port will be ignored;
// if you want to force TCP connection you can use "127.0.0.1".
$db_host = "localhost:3307";
// If you need to use a non standard port for the database connection you
// can uncomment the following line and specify the port number
// $db_port = 1234;
// Database name:
$db_database = "mrbs";
// Schema name.  This only applies to PostgreSQL and is only necessary if you have more
// than one schema in your database and also you are using the same MRBS table names in
// multiple schemas.
//$db_schema = "public";
// Database login user name:
$db_login = "root";
// Database login password:
$db_password = '';
// Prefix for table names.  This will allow multiple installations where only
// one database is available
$db_tbl_prefix = "mrbs_";
// Set $db_persist to TRUE to use PHP persistent (pooled) database connections.  Note
// that persistent connections are not recommended unless your system suffers significant
// performance problems without them.   They can cause problems with transactions and
// locks (see http://php.net/manual/en/features.persistent-connections.php) and although
// MRBS tries to avoid those problems, it is generally better not to use persistent
// connections if you can.
$db_persist = false;


/* Add lines from systemdefaults.inc.php and areadefaults.inc.php below here
   to change the default configuration. Do _NOT_ modify systemdefaults.inc.php
   or areadefaults.inc.php.  */


$mrbs_company = "PGIM Academic Centre";
$vocab_override['en']['mrbs'] = "Welcome";

$mrbs_company_logo = "./images/logo.png";    // name of your logo file.   This example assumes it is in the MRBS directory

// Event Registration
$enable_registration = false;
$enable_registration_users = false;
$allow_registration_default = false;

// Booking Confirmation (Tentative status)
$confirmation_enabled = true;
$confirmed_default = true; // Default for admins; will be overridden for users in edit_entry.php

// Custom Styling
$custom_css_url = 'css/custom.css';

// Mandatory Fields
$is_mandatory_field['entry.seat_count'] = true;
$is_mandatory_field['entry.event_type'] = true;
$is_mandatory_field['entry.internet'] = true;
$is_mandatory_field['entry.laptop'] = true;
$is_mandatory_field['entry.sound_system'] = true;
$is_mandatory_field['entry.projector'] = true;
$is_mandatory_field['entry.tv'] = true;
$is_mandatory_field['entry.hybrid_facility'] = true;

// Vocab Overrides
$vocab_override['en']['entry.seat_count'] = "Roughly how many participants will attend this?";
$vocab_override['en']['entry.event_type'] = "Select Booking Type";
$vocab_override['en']['entry.internet'] = "Do you need Internet Facility?";
$vocab_override['en']['entry.laptop'] = "Do you need Laptop or Computer?";
$vocab_override['en']['entry.sound_system'] = "Do you need Sound System with Microphones?";
$vocab_override['en']['entry.projector'] = "Do you need Projector or Other Multimedia Devices?";
$vocab_override['en']['entry.tv'] = "Do you need TV Facility?";
$vocab_override['en']['entry.hybrid_facility'] = "Is this event required Zoom or hybrid meeting facility?";
$vocab_override['en']['namebooker'] = "Topic of Event";
$vocab_override['en']['entry.meeting_link'] = "Zoom or Google Meet Link";
$vocab_override['en']['entry.other_requirement'] = "Other Requirement";

// Field Order
$edit_entry_field_order = array('create_by', 'name', 'description', 'start_time', 'end_time', 'room_id', 'type', 'confirmation_status', 'privacy_status', 'seat_count', 'event_type', 'internet', 'laptop', 'sound_system', 'projector', 'tv', 'hybrid_facility', 'meeting_link', 'other_requirement');

// Select Options
$select_options['entry.event_type'] = array(
    'Lecture' => 'Lecture',
    'Exam' => 'Exam',
    'Workshop' => 'Workshop',
    'Meeting' => 'Meeting',
    'Other' => 'Other'
);

// Radio Options for Facilities
$radio_options['entry.internet'] = array(1 => 'Yes', 0 => 'No');
$radio_options['entry.laptop'] = array(1 => 'Yes', 0 => 'No');
$radio_options['entry.sound_system'] = array(1 => 'Yes', 0 => 'No');
$radio_options['entry.projector'] = array(1 => 'Yes', 0 => 'No');
$radio_options['entry.tv'] = array(1 => 'Yes', 0 => 'No');
$radio_options['entry.hybrid_facility'] = array(1 => 'Yes', 0 => 'No');

// Custom JavaScript
$custom_js_url = 'js/custom.js';


// Custom buttons in date heading
$custom_date_buttons = array(
    array('text' => 'PGIM Main Premises ', 'url' => 'https://example.com/2'),
    array('text' => 'Academic Centre', 'url' => 'https://example.com/1'),
    array('text' => 'Board Room V', 'url' => 'https://example.com/3')
);
