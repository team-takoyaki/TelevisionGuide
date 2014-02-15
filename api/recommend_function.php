<?php
require_once '/var/www/html/api/common.conf';

function loadPgFromJson () {
    $get_date1 = strftime('%Y-%m-%d', time());
    $get_date2 = strftime('%Y-%m-%d', strtotime('+1 days',time()));

    $file1 = DATA_DIR.'/pg/'.$get_date1.'.tv.json';
    $file2 = DATA_DIR.'/pg/'.$get_date2.'.tv.json';

    $json1 = file_get_contents($file1);
    $data1 = json_decode($json1, true);
    
    $ret = array();
    if (file_exists($file2)) {
        $json2 = file_get_contents($file2);
        $data2 = json_decode($json2, true);
        $ret = array_merge($data1, $data2);
    } else {
        $ret = $data1;
    }
    return $ret;
}