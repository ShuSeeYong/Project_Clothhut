<?php
include_once("dbconnect.php");

$name = $_POST['name'];
$caption = $_POST['caption'];
$useremail = $_POST['useremail'];
$username = $_POST['username'];

$sqlregister = "INSERT INTO COMMENT(NAME,CAPTION,USEREMAIL,USERNAME) VALUES('$name','$caption','$useremail','$username')";

if ($conn->query($sqlregister) === TRUE) {

    echo "success";
  
}else{
    echo "failed";
}

?>