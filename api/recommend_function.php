<?php
require_once '/var/www/html/api/common.conf';

function loadPgFromJson ($user_id) {
    $get_date1 = strftime('%Y-%m-%d', time());
    $get_date2 = strftime('%Y-%m-%d', strtotime('+1 days',time()));

    if ($user_id !== 'demo') {
        $file1 = DATA_DIR.'/pg/'.$get_date1.'.tv.json';
        $file2 = DATA_DIR.'/pg/'.$get_date2.'.tv.json';
    } else {
        $file2 = DATA_DIR.'/pg/demo.tv.json';
    }

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

function removePgData($pg_data, $forget_data) {
    $ret = array();
    foreach ($pg_data as $pg) {
        foreach ($forget_data as $id) {
            if ($pg['id'] !== $id) {
                array_push($ret, $pg);
            }
        }
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
    $saved_data = array(
                        'pg_id' => array(),
                        'title' => array(),
                        );
    if (file_exists($file)) {
        $saved_data = loadUserInfo($user_id, $type);
        if (!is_array($saved_data['title'])) {
            $saved_data['title'] = array();
        }
        if (!is_array($saved_data['pg_id'])) {
            $saved_data['pg_id'] = array();
        }        
    }
    
    // remmember title について
    $saved_data['title'] = array_unique(array_merge($data['title'],$saved_data['title']));
    array_push($saved_data['pg_id'],$data['pg_id']);
    $saved_data['pg_id'] = array_unique($saved_data['pg_id']);

    return file_put_contents($file, serialize($saved_data));
}

function getUserFileName ($user_id, $type) {
    return DATA_DIR.'/user/'.$user_id.'.'.$type.'.dat';
}

function execEtcProsess($pg_data) {
    $today = date('Y-m-d');
    for ($i=0, $len=count($pg_data); $i<$len; $i++) {
        $pg_data[$i]['pg_icon'] = 'http://www.nhk.or.jp/prog/img/424/424.jpg';
        $pg_day = date('Y-m-d', strtotime($pg_data[$i]['start_time']));
        $day_diff = day_diff($today, $pg_day);
        if ($day_diff == 0) {
            $pg_data[$i]['pg_day'] = 'きょう';
        } else if ($day_diff == 1) {
            $pg_data[$i]['pg_day'] = 'あす';
        } else if ($day_diff == 2) {
            $pg_data[$i]['pg_day'] = 'あさって';
        } else {
            $pg_data[$i]['pg_day'] = '未来';
        } 

        $amfm = date('a', strtotime($pg_data[$i]['start_time']));
        $pg_time = date('g時j分〜', strtotime($pg_data[$i]['start_time']));
        if ($amfm === 'am') {
            $pg_amfm = '午前';
        } else {
            $pg_amfm = '午後';
        }

        $pg_data[$i]['pg_time'] = $pg_amfm.$pg_time;
        
    }
    return $pg_data;
}


function day_diff($date1, $date2) {
    // 日付をUNIXタイムスタンプに変換
    $timestamp1 = strtotime($date1);
    $timestamp2 = strtotime($date2);

    // 何秒離れているかを計算
    $seconddiff = abs($timestamp2 - $timestamp1);
    // 日数に変換
    $daydiff = $seconddiff / (60 * 60 * 24);
    // 戻り値    
    return $daydiff;
}


