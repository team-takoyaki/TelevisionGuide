<?php

// レコメンドデータ配信API
// recommend.json?user_id=06316648-2F2B-4A7B-B2AA-FD91E0F39E6F
// 処理の流れ
// 1. パラメータ受け取り
// 2. 番組情報準備
#// 2.1 キャッシュあればメモリから取得
// 2.2 なければjsonから読み取り、キャッシュ化
#// 3. ユーザ情報処理
#// 3.1 ユーザ情報存在確認
#// 3.2 ユーザ情報あれば取得
#// 4. パーソナライズ処理
#// 4.1
#// ...
// 5. データ出力

require_once '/var/www/html/api/common.conf';

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
$recommend_data = $pg_data;
/*
 * 5. データ出力
 */
header("Content-Type: application/json; charset=utf-8");
echo $encode_json($recommend_data);
exit;