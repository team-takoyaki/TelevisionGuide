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

function loadUserInfo ($user_id, $type) {
    $file = getUserFileName ($user_id, $type);
    if (file_exists($file)) {
        return unserialize(file_get_contents($file));
    } else {
        return false;
    }
}

function saveUserInfo ($user_id, $type, $data) {
    $file = getUserFileName ($user_id, $type);
    
    if (file_exists($file)) {
        $saved_data = loadUserInfo($user_id);

        // remmember title について
        if (isset($saved_data['title'])) {
            $save_data['title'] = array_unique(array_merge($data['title'],$saved_data['title']));
        }

        if (isset($saved_data['pg_id'])) {
            $save_data['pg_id'] = array_unique(array_merge($data['pg_id'],$saved_data['pg_id']));
        }        
        

        // ...
    }

    return file_put_contents($file, serialize($data));
}

function getUserFileName ($user_id, $type) {
    return DATA_DIR.'/user/'.$user_id.'.'.$type.'.dat';
}