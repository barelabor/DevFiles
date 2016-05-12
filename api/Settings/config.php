<?php

// - SERVER - //
DEFINE('API_DB_SERVER', 'localhost');
DEFINE('API_DB_NAME', 'barelabo_barelabor');
DEFINE('API_DB_USER', 'barelabo_yakov');
DEFINE('API_DB_PASS', 'barelaboryakov');

// -- EMAIL -- //
define("MAIL_USER", "support");
define("MAIL_PASS", "");
define("MAIL_SERVER", "localhost");
define("MAIL_PORT", "26");
define("EMAIL", "support@barelabor.com");
define("EMAIL_FROM", "BareLabor");
	
define("SMTP_AUTH", false);
define("POP3_AUTH", false);

// -- POP3 -- //
/* 
define("POP3_USER", "support@barelabor.com");
define("POP3_PASS", "");
define("POP3_SERVER", "mail.barelabor.com");
define("POP3_PORT", "110");
*/

// -- APP SETTINGS -- //
DEFINE('BASE_PATH', '/barelabor/api');
DEFINE('BASE_URL', 'http://bible-iq.com/barelabor/api');
DEFINE('BASE_WEB_URL', 'http://bible-iq.com');
DEFINE('WEB_API_KEY', '@#BARELABOR!RANDOM_GENERATED_KEY_TOKEN');
DEFINE('UPLOAD_LOCATION_AVATAR', '/Uploads/Users/Avatars/Original/');
DEFINE('LOCATION_AVATAR_NORMAL', 'Uploads/Users/Avatars/Normal/');
DEFINE('LOCATION_AVATAR_NORMAL_2X', 'Uploads/Users/Avatars/Normal2x/');
DEFINE('LOCATION_AVATAR_SMALL', 'Uploads/Users/Avatars/Small/');
DEFINE('LOCATION_AVATAR_SMALL_2X', 'Uploads/Users/Avatars/Small2x/');
DEFINE('LOG_LOCATION', 'Logs/');

DEFINE('UPLOAD_LOCATION_PICS', '/Uploads/Pictures/');
DEFINE('UPLOAD_LOCATION_ESTIMATES', '/Uploads/PrintedEstimates/');
?>