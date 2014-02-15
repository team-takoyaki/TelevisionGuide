<?php

// 覚える機能API
// remember_action.php?user_id=xxxx&pg_id=xxxx
// 処理の流れ
// 1. パラメータ受け取り
// 2. パラメータ分析
// 2.1 番組情報取り出し
// 2.2 お気に入り番組名抽出
#// 2.3 お気に入りキーワード抽出
// 3. 情報書き込み
// 4. 番組表返却呼び出し

require_once '/var/www/html/api/common.conf';
require_once '/var/www/html/api/recommend_function.php';

/*
 * 1. パラメータ受け取り
 */
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : false;
$pg_id   = isset($_GET['pg_id'])   ? $_GET['pg_id']   : false;
//$pg_id   = '2014021607567';

if (!$pg_id || !$user_id) {
    echo 'need param';
    exit;
}

/*
 * 2. パラメータ分析
 */
// 2.1 番組情報取り出し
$recommend_data = array();
$pg_data = loadPgFromJson();
$target_pg = false;
foreach ($pg_data as $pg) {
    if ($pg_id === $pg['id']) {
        $target_pg = $pg;
        break;
    }
}

if (!$target_pg) {
    echo 'pg match error';
    exit;
}

// 2.2 お気に入り番組名抽出
$remember_title =  explode(' ', $pg['title']);
// 2.3 お気に入りキーワード抽出


/*
 * 3. 情報書き込み
 */
$ret = saveUserInfo(array($user_id, 'title' => $remember_title));

if (!$ret) {
    echo 'write error';
    epgxit;
}

echo 'success';
exit;


