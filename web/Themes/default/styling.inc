<?php
declare(strict_types=1);
namespace MRBS;

// DEFAULT THEME

// ***** COLOURS ************************
// Colours used in MRBS.    All the colours are defined here as PHP variables

$body_background_color          = "#f8fafc";    // background colour for the main body
$standard_font_color            = "#1e293b";    // default font color
$header_font_color              = "#ffffff";    // font color for text in headers
$highlight_font_color           = "#e11d48";    // used for highlighting text (eg links, errors)
$color_key_font_color           = $standard_font_color;    // used in the colour key table

$banner_back_color              = "#3b82f6";    // background colour for banner
$banner_border_color            = $body_background_color;    // border colour for banner
$banner_font_color              = $header_font_color;       // font colour for banner
$banner_nav_hover_color         = "#2563eb";   // background colour when header links are hovered over

$minical_view_color             = "#1e293b";    // used for highlighting the dates in the current view
$minical_today_color            = "#bae6fd";    // used for highlighting today

$header_back_color              = $banner_back_color;  // background colour for headers
$flatpickr_highlight_color      = $banner_back_color;  // used for highlighting the date

$admin_table_header_back_color  = $header_back_color;     // background colour for header and also border colour for table cells
$admin_table_header_sep_color   = $body_background_color; // vertical separator colour in header
$admin_table_header_font_color  = $header_font_color;     // font colour for header
$admin_table_border_color       = "#e2e8f0";

$main_table_border_color        = "#e2e8f0";    // border colour for day/week/month tables - outside
$main_table_header_border_color = "#e2e8f0";    // border colour for day/week/month tables - header
$main_table_body_h_border_color = "#ffffff";    // border colour for day/week/month tables - body, horizontal
$main_table_body_v_border_color = "#e2e8f0";    // border colour for day/week/month tables - body, vertical
$main_table_month_color         = "#ffffff";    // background colour for days in the month view
$main_table_month_weekend_color = "#f8fafc";    // background colour for weekends in the month view
$main_table_month_holiday_color = "#f1f5f9";    // background colour for holidays in the month view
$main_table_month_weekend_holiday_color = "#e2e8f0";    // background colour for weekend holidays in the month view
$main_table_month_invalid_color = "#cbd5e1";    // background colour for invalid days in the month view
$main_table_slot_invalid_color  = "#cbd5e1";    // background colour for invalid slots in the day and week views
$main_table_slot_private_type_color = "#cbd5e1";          // background colour when the type has to kept private
$main_table_labels_back_color   = $header_back_color;     // background colour for the row labels column
$timeline_color                 = $header_back_color;

// border colours for the main table when it is printed.     These are used by mrbs-print.css.php
$main_table_border_color_print        = "#dddddd";    // border colour for the main table (print view)
$main_table_header_border_color_print = "#dddddd";    // border colour for day/week/month tables - header (print view)
$main_table_body_h_border_color_print = "#dddddd";    // border colour for day/week/month tables - body, horizontal (print view)
$main_table_body_v_border_color_print = "#dddddd";    // border colour for day/week/month tables - body, vertical (print view)

// font colours for the main table when it is printed
$header_font_color_print        = "#0B263B";
$anchor_link_color_header_print = "#0B263B";

$report_table_border_color      = $standard_font_color;
$report_h2_border_color         = $banner_back_color;     // border colour for <h2> in report.php
$report_h3_border_color         = "#879AA8";              // border colour for <h2> in report.php

$search_table_border_color      = $standard_font_color;

$site_faq_entry_border_color    = "#e2e8f0";              // used to separate individual FAQ's in help.php

$anchor_link_color              = $standard_font_color;        // link color
$anchor_visited_color           = $anchor_link_color;          // link color (visited)
$anchor_hover_color             = $anchor_link_color;          // link color (hover)

$anchor_link_color_banner       = $header_font_color;          // link color
$anchor_visited_color_banner    = $anchor_link_color_banner;   // link color (visited)
$anchor_hover_color_banner      = $anchor_link_color_banner;   // link color (hover)

$anchor_link_color_header       = $standard_font_color;          // link color
$anchor_visited_color_header    = $anchor_link_color_header;   // link color (visited)
$anchor_hover_color_header      = $anchor_link_color_header;   // link color (hover)

$column_hidden_color            = $main_table_month_invalid_color;    // hidden days in the week and month views
$calendar_hidden_color          = "#dae0e4";                          // hidden days in the mini-cals
$row_highlight_color            = $banner_back_color;  // used for highlighting a row
$row_even_color                 = "#ffffff"; // even rows in the day and week views
$row_odd_color                  = "#efefef"; // odd rows in the day and week views
$row_even_color_weekend         = "#f4f4f4"; // even rows in the day and week views for weekends
$row_odd_color_weekend          = "#e4e4e4"; // odd rows in the day and week views for weekends
$row_even_color_holiday         = "#e8e8e8"; // even rows in the day and week views for holidays
$row_odd_color_holiday          = "#d8d8d8"; // odd rows in the day and week views for holidays
$row_even_color_weekend_holiday = "#dfdfdf"; // even rows in the day and week views for weekend holidays
$row_odd_color_weekend_holiday  = "#cfcfcf"; // odd rows in the day and week views for weekend holidays

$zebra_even_color = "#ffffff";  // Colour for even rows in other tables (eg Search, Report and Users)
$zebra_odd_color  = '#f8fafc';  // Colour for odd rows in other tables (eg Search, Report and Users)

$help_highlight_color           = "#ffe4e6";        // highlighting text on the help page

// Button colours
$button_color_stops = array('#ffffff', '#f1f5f9');  // linear gradient colour stops
$button_inset_color = '#cbd5e1';

// These are the colours used for distinguishing between the different types of bookings in the main
// displays in the day, week and month views
$color_types = array(
    'A' => "#fef08a", // soft yellow
    'B' => "#a7f3d0", // soft teal
    'C' => "#fde047", // yellow
    'D' => "#bae6fd", // soft sky blue
    'E' => "#99f6e4", // soft cyan
    'F' => "#c7d2fe", // soft indigo
    'G' => "#bbf7d0", // soft green
    'H' => "#e9d5ff", // soft purple
    'I' => "#d9f99d", // soft lime
    'J' => "#fecaca"); // soft red

// colours used for pending.php and bookings awaiting approval
$outstanding_color         = "#fde047";     // font colour for the outstanding reservations message in the header
$pending_header_back_color = $header_back_color; // background colour for series headers
$series_entry_back_color   = "#fef08a";     // background colour for entries in a series
$pending_control_color     = "#fde047";     // background colour for the series +/- controls in pending.php
$attention_color           = '#f97316';  // background colour for the number of bookings awaiting approval

// ***** DIMENSIONS *******************
$banner_border_width          = '0';  // (px)  border width for the outside of the banner
$banner_border_cell_width     = '1';  // (px)  border width for the cells of the banner
$main_table_border_width      = '0';  // (px)  border width for the outside of the main day/week/month tables
$main_table_cell_border_width = '1';  // (px)  vertical border width for the cells of the main day/week/month tables
$main_cell_height             = '1.5em';  // height of the cells in the main day/week tables


// ***** FONTS ************************
$standard_font_family  = '"Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif';

