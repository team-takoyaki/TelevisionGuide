<?php
// 次の日の番組表をとりにいくよ
// 毎朝6時更新だよ
// document : http://api-portal.nhk.or.jp/doc_list-v1_con

require_once '/var/www/html/api/batch/get_daily_program.conf';

// 取得日付設定
$date = strftime('%Y-%m-%d', strtotime('+1 days',time()));
//$date = strftime('%Y-%m-%d', time());

// url取得
$url = createUrl($date);

// プログラムリスト取得
$program_list = getProgramList($url);

// ファイルに書き出し
$filename = DATA_DIR.'/pg/'.$date.'.tv.json';
file_put_contents($filename, json_encode($program_list));

exit;


// プログラムのjsonを取得


function createUrl ($date) {
    return API_URL.'/'.API_AREA.'/'.API_SERVICE.'/'.$date.'.json?key='.API_KEY;
}

function getProgramList ($url) {
    $data = json_decode(file_get_contents($url), true);
    $ret = array_merge(
        $data['list']['e1'],
        $data['list']['e3'],
        $data['list']['e4'],
        $data['list']['g1'],
        $data['list']['g2'],
        $data['list']['s1'],
        $data['list']['s2'],
        $data['list']['s3'],
        $data['list']['s4']
    );

    usort($ret, function ($a, $b) {
            return $a['id'] < $b['id'];
        });

    return $ret;
}
