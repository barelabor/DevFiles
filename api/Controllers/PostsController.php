<?php 
require_once("Classes/Helper.php");
require_once("Models/Post.php");

class PostsController
{
    /**
    * Send post
    */
    public function SendPost($userID, $clubID, $postTitle, $postKeywords = "")
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']) && 
                isset($_POST['clubID']) && 
                isset($_POST['postTitle']))
            {
                $postImage = "";
                if(Helper::PostedFile("postImage"))
                {
                    $postImage = Helper::UploadFile("postImage", UPLOAD_LOCATION_PICS . $userID . "/", "post-{$userID}-image");
                }               

                $response = Post::SendPost($userID, $clubID, $postImage, $postTitle, $postKeywords);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }

    /**
    * Get popular posts
    */
    public function GetPopularPosts($userID, $page = 1, $take = 50)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']))
            {
                $response = Post::GetPopularPosts($userID, $page, $take);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }


    /**
    * Get recent posts
    */
    public function GetRecentPosts($userID, $take = 50)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['userID']))
            {
                $response = Post::GetRecentPosts($userID, $take);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }

    /**
    * Delete a post
    */
    public function DeletePost($postID)
    {
        if(Helper::APIKeyValid($userID))
        {
            if(isset($_POST['postID']))
            {
                $response = Post::DeletePost($postID);
            }
            else
            {
                $response->status = 400;
            }
        }
        else {
            $response->status = 400;
        }

        $this->server->setStatus($response->status);
        $response->status = Helper::GetCustomStatus($response->status, $this->server);

        return $response;
    }
}
?>