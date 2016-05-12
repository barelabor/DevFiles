<?php
require_once("Classes/resize.image.class.php");
require_once("Classes/Helper.php");
require_once("Settings/config.php");
class ResizeController
{
	var $image;
	var $originalRetina;
	var $failed;
	var $started;
	var $finished;
	public function  __construct($imageName)
	{ 
		$this->failed = 0;
		$this->image = new Resize_Image;
		$this->originalRetina = $imageName;
		
		$this->image->image_to_resize = Helper::GetPath() . $this->originalRetina; // Full Path to the file
		$this->image->ratio = true; // Keep Aspect Ratio?
		$info = pathinfo(Helper::GetPath() . $this->originalRetina);
		$this->started = date("Y-m-d H:i:s");
		$this->image->new_image_name = basename($imageName,'.'.$info['extension']);
	}
	public function SetImageProcessed()
	{
		if($this->failed == 0)
		{
			$mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
			/* Create a prepared statement */
	        if($stmt = $mysqli -> prepare("UPDATE items SET 
	        		dateProcessed = NOW(), 
					itemImageOriginal = ?,
		        	itemImageGrid = ?,
					itemImageGrid2x = ?,
					itemImagePreview = ?,
					itemImagePreview2x = ?,
					itemImageSlide = ?,
					itemImageSlide2x = ?,
					itemImageIcon = ?,
					itemImageIcon2x = ?
				WHERE itemImageOriginal2x = ?")) 
	        {
	            /* Bind parameters
	             s - string, b - boolean, i - int, etc */
	            $slika = basename($this->originalRetina);
	            $itemImageOriginal2x = BASE_URL ."/Uploads/Images/Original/Retina/" . $slika;
			    $itemImageOriginal = BASE_URL . "/Uploads/Images/Original/Normal/{$slika}";
		        $itemImageGrid = BASE_URL . "/Uploads/Images/Grid/Normal/{$slika}";
				$itemImageGrid2x = BASE_URL . "/Uploads/Images/Grid/Retina/{$slika}";
				$itemImagePreview = BASE_URL . "/Uploads/Images/Preview/Normal/{$slika}";
				$itemImagePreview2x = BASE_URL . "/Uploads/Images/Preview/Retina/{$slika}";
				$itemImageSlide = BASE_URL . "/Uploads/Images/Slide/Normal/{$slika}";
				$itemImageSlide2x = BASE_URL . "/Uploads/Images/Slide/Retina/{$slika}";
				$itemImageIcon = BASE_URL . "/Uploads/Images/Icon/Normal/{$slika}";
				$itemImageIcon2x = BASE_URL . "/Uploads/Images/Icon/Retina/{$slika}";
	            $stmt->bind_param("ssssssssss", $itemImageOriginal, $itemImageGrid, $itemImageGrid2x, $itemImagePreview,
	            	$itemImagePreview2x, $itemImageSlide, $itemImageSlide2x, $itemImageIcon, $itemImageIcon2x,
	             $itemImageOriginal2x);
	            if($stmt->execute()) {
	            	/* Bind results to variables */
	            	$this->finished = date("Y-m-d H:i:s");
	            }
	            /* Close statement */
	            $stmt->close();
	        }
	        $mysqli->close();
    	}
	}
	public function SetAvatarsProcessed()
	{
		if($this->failed == 0)
		{
			$mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
			/* Create a prepared statement */
	        if($stmt = $mysqli -> prepare("UPDATE users set dateProcessed = NOW() WHERE avatarOriginal = ?")) 
	        {
	            /* Bind parameters
	             s - string, b - boolean, i - int, etc */
	            $slika = BASE_URL . UPLOAD_LOCATION_AVATAR . basename($this->originalRetina);
	            $stmt->bind_param("s", $slika);
	            if($stmt->execute()) {
	            	/* Bind results to variables */
	            	
	            }
	            /* Close statement */
	            $stmt->close();
	        }
	        $mysqli->close();
    	}
	}
	public function GetUnprocessedImages()
	{
		$images = array();
		$mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
		if ($result = $mysqli->query("SELECT itemImageOriginal2x FROM items WHERE dateProcessed IS NULL "))
        {
        	if($result->num_rows > 0) 
        	{
	        	while ($row = $result->fetch_object())
	        	{
	        		$images[] = ltrim(UPLOAD_LOCATION_AVATAR, '/') . basename($row->itemImageOriginal2x);
			    }
        	}
        	$result->close();
        }
        $mysqli->close();
        return $images;
	}
	public function GetUnprocessedAvatars()
	{
		$images = array();
		$mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
		if ($result = $mysqli->query("SELECT avatarOriginal FROM users WHERE dateProcessed IS NULL "))
        {
        	if($result->num_rows > 0) 
        	{
	        	while ($row = $result->fetch_object())
	        	{
	        		$images[] = ltrim(UPLOAD_LOCATION_AVATAR, '/') . basename($row->avatarOriginal);
			    }
        	}
        	$result->close();
        }
        $mysqli->close();
        return $images;
	}
	public function SaveAvatarSmall()
	{
		try
		{
			$this->image->new_width = 22;
			$this->image->new_height = 22;
			$this->image->save_folder = Helper::GetPath() . LOCATION_AVATAR_SMALL;
			$path = $this->image->save_folder .  basename($this->originalRetina);
			if(!@file_exists($path))
			{
				$process = $this->image->resize();
				if($process['result'] && $this->image->save_folder)
				{
				
					return $path . 'The new image ('.$process['new_file_path'].') has been saved.';
				}
				else
				{
					$this->failed++;
				}
			}
		}
		catch(Exception $e)
		{
			$this->failed++;
		}
	}
	public function SaveAvatarSmall2x()
	{
		try
		{
			$this->image->new_width = 44;
			$this->image->new_height = 44;
			$this->image->save_folder = Helper::GetPath() . LOCATION_AVATAR_SMALL_2X;
			$path = $this->image->save_folder .  basename($this->originalRetina);
			if(!@file_exists($path))
			{
				$process = $this->image->resize();
				if($process['result'] && $this->image->save_folder)
				{
				
					return $path . 'The new image ('.$process['new_file_path'].') has been saved.';
				}
				else
				{
					$this->failed++;
				}
			}
		}
		catch(Exception $e)
		{
			$this->failed++;
		}
	}
	public function SaveAvatarNormal()
	{
		try
		{
			$this->image->new_width = 55;
			$this->image->new_height = 55;
			$this->image->save_folder = Helper::GetPath() . LOCATION_AVATAR_NORMAL;
			$path = $this->image->save_folder . basename($this->originalRetina);
			if(!@file_exists($path))
			{
				$process = $this->image->resize();
				if($process['result'] && $this->image->save_folder)
				{
				
					return $path . 'The new image ('.$process['new_file_path'].') has been saved.';
				}
				else
				{
					$this->failed++;
				}
			}
		}
		catch(Exception $e)
		{
			$this->failed++;
		}
	}
	public function SaveAvatarNormal2x()
	{
		try
		{
			$this->image->new_width = 110;
			$this->image->new_height = 110;
			$this->image->save_folder = Helper::GetPath() . LOCATION_AVATAR_NORMAL_2X;
			$path = $this->image->save_folder .  basename($this->originalRetina);
			if(!@file_exists($path))
			{
				$process = $this->image->resize();
				if($process['result'] && $this->image->save_folder)
				{
				
					return $path . 'The new image ('.$process['new_file_path'].') has been saved.';
				}
				else
				{
					$this->failed++;
				}
			}
		}
		catch(Exception $e)
		{
			$this->failed++;
		}
	}
}
?>