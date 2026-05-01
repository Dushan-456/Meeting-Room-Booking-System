<?php
namespace MRBS;
require 'defaultincludes.inc';

$sql = "UPDATE " . _tbl('area') . " SET timezone = ?";
db()->query($sql, array('Asia/Colombo'));

echo "Timezone updated for all areas to Asia/Colombo\n";
