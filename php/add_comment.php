<?php
include_once("dbconnect.php");
$image = $_POST['image'];
$clothesname = $_POST['clothesname'];
$email = $_POST['email'];
$name = $_POST['name'];
$review = $_POST['review'];
$rating = $_POST['rating'];


$sqlregister = "INSERT INTO REVIEW(IMAGE,CLOTHESNAME, EMAIL, NAME, REVIEW, RATING) VALUES('$image','$clothesname','$email','$name','$review','$rating')";

if ($conn->query($sqlregister) === TRUE) {

    echo "success";
  
}else{
    echo "failed";
}

?>
