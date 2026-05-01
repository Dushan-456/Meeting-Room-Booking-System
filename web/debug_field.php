<?php
namespace MRBS;
require 'defaultincludes.inc';
$fields = db()->field_info(_tbl('entry'));
foreach ($fields as $field) {
    if ($field['name'] == 'seat_count') {
        echo "Field: " . $field['name'] . "\n";
        echo "Nature: " . $field['nature'] . "\n";
        echo "Type: " . $field['type'] . "\n";
        echo "Length: " . ($field['length'] ?? 'NULL') . "\n";
    }
}
