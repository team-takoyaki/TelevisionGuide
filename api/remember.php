<?php

// 覚えたデータ配信API
// remember.php?user_id=06316648-2F2B-4A7B-B2AA-FD91E0F39E6F
// 処理の流れ

require_once '/var/www/html/api/common.conf';
require_once '/var/www/html/api/recommend_function.php';

/*
 * 1. パラメータ受け取り
 */
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : false;

/*
 * 2. 番組情報準備
 */
$recommend_data = array();
// 2.1 キャッシュあればメモリから取得
// 2.2 なければjsonから読み取り、キャッシュ化
$pg_data = loadPgFromJson();
$user_info = loadUserInfo ($user_id, 'remember');

if (!$pg_data || !$user_info) {
    header("Content-Type: application/json; charset=utf-8");
    echo "[]";
    exit;
}

$remember_pg = array();
foreach ($user_info['pg_id'] as $pg_id) {
    foreach ($pg_data as $pg) {
        if ($pg['id'] === $pg_id) {
            array_push($remember_pg, $pg);
            break;
        }
    }
}


/*
 * 5. データ出力
 */
header("Content-Type: application/json; charset=utf-8");
echo json_encode($remember_pg);

exit;