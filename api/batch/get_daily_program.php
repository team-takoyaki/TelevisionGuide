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

// NHKオンラインのURL追加
for ($i=0, $len=count($program_list); $i<$len; $i++) {
    $program_list[$i]['nhk_online_url'] = NHK_ONLINE_URL.'?'
        .http_build_query(array(
                                'a' => '001',
                                'd' => $date,
                                'c' => $SERVECE_INDEX[$program_list[$i]['service']['id']],
                                'e' => $program_list[$i]['event_id']*1,                                
                                ));
}

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
        $data['list']['g1'],
        $data['list']['s1'],
        $data['list']['s3']
    );

    usort($ret, function ($a, $b) {
            return $a['id'] < $b['id'];
        });

    return $ret;
}
