<?php
require_once '/var/www/html/api/common.conf';

function loadPgFromJson () {
    $get_date1 = strftime('%Y-%m-%d', time());
    $get_date2 = strftime('%Y-%m-%d', strtotime('+1 days',time()));

    $json1 = DATA_DIR.'/pg/'.$get_date1.'.tv.json';
    $json2 = DATA_DIR.'/pg/'.$get_date2.'.tv.json';

    $data1 = json_decode($json1, true);
    $data2 = json_decode($json2, true);

    return array_merge( $data1, $data2 );
}