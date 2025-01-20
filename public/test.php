<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo 'PHP Version: ' . phpversion() . '<br/>';
echo 'Document Root: ' . $_SERVER['DOCUMENT_ROOT'] . '<br/>';
echo 'Script Filename: ' . $_SERVER['SCRIPT_FILENAME'] . '<br/>';