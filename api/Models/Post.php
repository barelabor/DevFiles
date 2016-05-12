<?php 
require_once("Settings/config.php");
require_once("Classes/Helper.php");
require_once("Models/Response/SingleItemResponse.php");
require_once("Models/Response/MultipleItemsResponse.php");
require_once("Models/Response/BooleanResponse.php");
require_once("Models/User.php");

class Post
{
	public static function GetImageUrl($userID, $image)
    {
        if(!empty($image))
        {
          if(strncmp($image, "http://", strlen("http://")) &&
              strncmp($image, "https://", strlen("https://")))
          {
            $image = BASE_URL . UPLOAD_LOCATION_PICS  . (!empty($userID) ? $userID . "/"  : "") .  $image;
          }            
        }

        return $image;
    }

    /* 
    * Get post
    */
    public static function GetPost($userID, $postID, $browsingUserID = null)
    {
        $response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        if(is_null($browsingUserID) || empty($browsingUserID)) 
        {
            $browsingUserID = $userID;
        }

        $postID = $mysqli->real_escape_string($postID);
        $userID = $mysqli->real_escape_string($userID);
        $browsingUserID = $mysqli->real_escape_string($browsingUserID);

        if($result = $mysqli -> query(
            "SELECT p.postID,
                    p.userID,                                 
                    p.postImage,  
                    TIMESTAMPDIFF(SECOND, p.postDate, NOW()) AS timeAgo,
                    p.postTitle,                                
                    p.postKeywords,  
                    (SELECT if(count(*) > 0, 1,0) FROM likes WHERE postID = {$postID} and userID = {$browsingUserID}) as isLiked,                              
                    (SELECT COALESCE(COUNT(*), 0) FROM comments WHERE postID = {$postID}) as totalComments,
                    (SELECT COALESCE(COUNT(*), 0) FROM likes WHERE postID = {$postID}) as totalLikes,
                    (SELECT COALESCE(COUNT(*), 0) FROM guess WHERE postID = {$postID} AND guessedUserID={$userID}) as rightGuess,
                    (SELECT COALESCE(COUNT(*), 0) FROM guess WHERE postID = {$postID} AND guessedUserID!={$userID}) as wrongGuess,
                    (SELECT if(count(*) > 0, 1,0) FROM guess WHERE postID = {$postID} AND userID={$browsingUserID} AND guessedUserID={$userID}) as iGuessedRight,
                    (SELECT if(count(*) > 0, 1,0) FROM guess WHERE postID = {$postID} AND userID={$browsingUserID} AND guessedUserID!={$userID}) as iGuessedWrong
            FROM posts p
            WHERE p.postID = {$postID}")) 
        {
            $response->status = 200;
            $row = $result->fetch_object();
            
            $row->user = User::Profile($userID, $row->userID)->item;
            $row->timeAgo = Helper::TimeAgo($row->timeAgo, true);
            //$row->isLiked = $row->totalLikes > 0;
            $row->isCommented = $row->totalComments > 0;
            $row->postImage = Post::GetImageUrl($userID, $row->postImage);

            $response->item = $row;
            $result->close();
        }
        else
        {
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        
        $mysqli->close();
        return $response;
    }

    /**
    * Send post
    */
    public static function SendPost($userID, $clubID, $postImage, $postTitle, $postKeywords = "")
    {
        $response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $userID = $mysqli->real_escape_string($userID);
        $clubID = $mysqli->real_escape_string($clubID);
        $postTitle = $mysqli->real_escape_string($postTitle);
        $postImage = $mysqli->real_escape_string($postImage);
        $postKeywords = $mysqli->real_escape_string($postKeywords);

        $sql = "INSERT INTO posts(userID, clubID, postImage, postTitle, postKeywords) VALUES ({$userID}, {$clubID}, '{$postImage}', '{$postTitle}', '{$postKeywords}')";
        if($mysqli -> query($sql)) 
        {
            $response->status = 200;
            $response->item = Post::GetPost($userID, $mysqli->insert_id)->item;
        }
        else
        {
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }
 
        $mysqli->close();
        return $response;
    }

    /**
    * Get popular posts
    */
    public static function GetPopularPosts($userID, $page = 1, $take = 50)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $postID = $mysqli->real_escape_string($postID);
        $take = $mysqli->real_escape_string($take);
        $from = ($mysqli->real_escape_string($page) - 1) * $take;

        $items = array();

        $sql = "SELECT 
                    p.postID,
                    p.userID,
                    (
                        (SELECT COALESCE(COUNT(*), 0) FROM likes WHERE postID = p.postID) +
                        (SELECT COALESCE(COUNT(*), 0) FROM comments WHERE postID = p.postID)
                    ) as score,
                    p.postDate
                FROM posts p
                ORDER BY score DESC, p.postDate DESC
                LIMIT {$from}, {$take}";

        if ($result = $mysqli->query($sql))
        {
            if($result->num_rows > 0) {
                $response->status = 200;
                while($row = $result->fetch_object())
                { 
                    $items[] = Post::GetPost($row->userID, $row->postID)->item;
                }
            }
            else
            {
                $response->status = 404;
            }

            $result->close();
        }
        else
        {
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        $mysqli->close();
        $response->items = $items;
        return $response;
    }

    /**
    * Get recent posts
    */
    public static function GetRecentPosts($userID, $take = 50)
    {
        $response = new MultipleItemsResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $postID = $mysqli->real_escape_string($postID);
        $take = $mysqli->real_escape_string($take);

        $items = array();

        $sql = "SELECT 
                    p.postID,
                    p.userID
                FROM posts p
                ORDER BY p.postID DESC
                LIMIT 0, {$take}";

        if ($result = $mysqli->query($sql))
        {
            if($result->num_rows > 0) {
                $response->status = 200;
                while($row = $result->fetch_object())
                { 
                    $items[] = Post::GetPost($row->userID, $row->postID)->item;
                }
            }
            else
            {
                $response->status = 404;
            }

            $result->close();
        }
        else
        {
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }

        $mysqli->close();
        $response->items = $items;
        return $response;
    }

    /**
    * Delete a post
    */
    public static function DeletePost($postID)
    {
        $response = new SingleItemResponse();
        $mysqli = new mysqli(API_DB_SERVER, API_DB_USER, API_DB_PASS, API_DB_NAME);
        $postID = $mysqli->real_escape_string($postID);

        $sql = "DELETE FROM posts WHERE postID={$postID}";
        if($mysqli -> query($sql)) 
        {
            $response->status = 200;
        }
        else
        {
            $response->status = 503;
            $log = Helper::GetLogger();
            $log->logError($mysqli->error);
        }
 
        $mysqli->close();
        return $response;
    }
}
?>