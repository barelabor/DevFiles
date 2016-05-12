<?php

// Put your device token here (without spaces):
//$deviceToken = 'a8e6a32f33f1d36b17e12fa3c36c5748ffe6c67cba83f1acd42359d273e04322';
$deviceToken = '23d7c37494593c4819fcef56736c0e84f1656c55206da73f306b967ecb6071e2';


// Put your private key's passphrase here:
$passphrase = '123456';

// Put your alert message here:
$message = 'ae aweg aer aHi, Thomas. I sent notification to u. This is push notification';

////////////////////////////////////////////////////////////////////////////////

$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
$fp = stream_socket_client(
	'ssl://gateway.sandbox.push.apple.com:2195', $err,
	$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

stream_socket_enable_crypto($fp, true, STREAM_CRYPTO_METHOD_SSLv23_CLIENT);

if (!$fp)
	exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
$body['aps'] = array(
	'alert' => $message,
	'sound' => 'default',
	'badgecount' => 1,
	'action'=> array('route' => 'mail/thread1', 'request' => array("user_id"=>731, "thread_id"=>123, "item_id" => 3, "type_id" => "123123")),
	'notify' => 'notification',
);

// Encode the payload as JSON
$payload = json_encode($body);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

var_dump($result);

if (!$result)
	echo 'Message not delivered' . PHP_EOL;
else
	echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);