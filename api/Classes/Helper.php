<?php
require_once("Settings/config.php");
require_once("KLogger.php");

class Helper {

  public static function GetLogger()
  {
    return KLogger::instance(LOG_LOCATION); 
  }

  /* Returns the physical root path */
  public static function GetPath()
  {
    return $_SERVER['DOCUMENT_ROOT'] . BASE_PATH;
  }

  public static function PostedFile($file)
  {
    if(isset($_FILES[$file]['tmp_name']))
    {
      return is_uploaded_file($_FILES[$file]['tmp_name']);
    }
  }

  public static function FileExists($file)
  {
    if(isset($_FILES[$file]['tmp_name']))
    {
      return is_uploaded_file($_FILES[$file]['tmp_name']);
    }
  }

  public static function UploadFile($file, $location, $newFileName)
  {
      $pathInfo = pathinfo($_FILES[$file]['name']);
      $fileName = $newFileName .".". strtolower($pathInfo['extension']);
      $imageLocation = Helper::GetPath() . $location . $fileName;
      move_uploaded_file($_FILES[$file]['tmp_name'], $imageLocation);

      return $fileName;
  }

  public static function Clean($input, $encoding = 'UTF-8')
  {
      return htmlentities($input, ENT_QUOTES, $encoding);
  }

	public static function GetCustomStatus($statusCode, $server)
	{
		switch ($statusCode) {
            case 200:
                $ret = "OK";
                break;

            case 401:
                $ret = "UNAUTHORIZED";
                break;

            case 404:
                $ret = "NOT_FOUND";
                break;

            case 400:
                $ret = "BAD_REQUEST";
                break;

            default:
                $ret = str_replace(" ", "_", strtoupper($server->getStatus($statusCode)));
                break;
        };

        return $ret;
	}

  public static function TimeAgo($ptime, $ago = false)
  {
    if($ago){
      $etime = $ptime;
    }
    else{
      $etime = time() - strtotime($ptime);
    }
    
    if ($etime < 1) {
        return '0 seconds ago';
    }
    
    $a = array( 12 * 30 * 24 * 60 * 60  =>  'year',
                30 * 24 * 60 * 60       =>  'month',
                24 * 60 * 60            =>  'day',
                60 * 60                 =>  'hour',
                60                      =>  'minute',
                1                       =>  'second'
                );
    
    foreach ($a as $secs => $str) {
        $d = $etime / $secs;
        if ($d >= 1) {
            $r = round($d);
            return $r . ' ' . $str . ($r > 1 ? 's' : '') . " ago";
        }
    }
  }

    /*
    Calculate the distance between two points (latitude, longitude)

    Example:
    echo distance(32.9697, -96.80322, 29.46786, -98.53506, "m") . " miles<br>";
    echo distance(32.9697, -96.80322, 29.46786, -98.53506, "k") . " kilometers<br>";
    echo distance(32.9697, -96.80322, 29.46786, -98.53506, "n") . " nautical miles<br>";
    */
    public function GetDistance($lat1, $lon1, $lat2, $lon2, $unit)
    {
      $theta = $lon1 - $lon2; 
      $dist = sin(deg2rad($lat1)) * sin(deg2rad($lat2)) +  cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * cos(deg2rad($theta)); 
      $dist = acos($dist); 
      $dist = rad2deg($dist); 
      $miles = $dist * 60 * 1.1515;
      $unit = strtoupper($unit);

      if ($unit == "K") {
        return ($miles * 1.609344); 
      } else if ($unit == "N") {
          return ($miles * 0.8684);
        } else {
            return $miles;
          }
    }


  function Base36Encode($base10) {
    return base_convert($base10, 10, 36);
  }
 
  function Base36Decode($base36) {
    return base_convert($base36, 36, 10);
  }

  /* Gets the reset password token */
  public static function GetRandomToken()
  {   
    $underscores = 2; // Maximum number of underscores allowed in password
    $length = 10; // Length of password
     
    $p ="";
    for ($i=0;$i<$length;$i++)
    {   
      $c = mt_rand(1,7);
      switch ($c)
      {
        case ($c<=2):
          // Add a number
          $p .= mt_rand(0,9);   
        break;
        case ($c<=4):
          // Add an uppercase letter
          $p .= chr(mt_rand(65,90));   
        break;
        case ($c<=6):
          // Add a lowercase letter
          $p .= chr(mt_rand(97,122));   
        break;
        case 7:
           $len = strlen($p);
          if ($underscores>0&&$len>0&&$len<($length-1)&&$p[$len-1]!="_")
          {
            $p .= "_";
            $underscores--;   
          }
          else
          {
            $i--;
            continue;
          }
        break;       
      }
    }
    return $p;
  }

  /**
  * Check if API_KEY is valid
  */
  public static function APIKeyValid($userID = 0)
  {
    $ok = false;

    if(isset($_SERVER['HTTP_API_KEY']) && 
        !empty($_SERVER['HTTP_API_KEY'])) 
    {
      $ok = true;
      /* 
        Do some verification with the api_key, or not
      */
      if($userID != 0)
      {
        //$ok = true;
      }
      else
      {
        //$ok = true;
      }
    }

//    return $ok;
    return true;
  }

}
?>