<?php
// 次の日の番組表をとりにいくよ
// 毎朝6時更新だよ
// document : http://api-portal.nhk.or.jp/doc_list-v1_con

require_once ROOT_DIR.'/batch/get_daily_program.conf';

// 取得日付設定
$date = strftime('%Y-%m-%d', strtotime('+1 days',time()));
//$date = strftime('%Y-%m-%d', time());

// url取得
$url = createUrl($date);

// プログラムリスト取得
$program_list = getProgramList($url);

// ファイルに書き出し
$filename = SAVE_DIR.'/pg/'.$date.'.tv.json';
file_put_contents($filename, json_encode($program_list));

exit;


// プログラムのjsonを取得


function createUrl ($date) {
    return API_URL.'/'.API_AREA.'/'.API_SERVICE.'/'.$date.'.json?key='.API_KEY;
}

function getProgramList ($url) {
    $data = json_decode(file_get_contents($url), true);
    return $data['list']['g1'];
}

