<?php
include_once("dbconnect.php");
$image = $_POST['image'];
$email = $_POST['email'];
$username = $_POST['username'];
$name = $_POST['name'];
$description = $_POST['description'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../images/clothesimages/'.$image.'.jpg';
$is_written = file_put_contents($path, $decoded_string);

if ($is_written > 0){
    $sqlregister = "INSERT INTO POST(IMAGE,EMAIL,USERNAME,NAME,DESCRIPTION) VALUES('$image','$email','$username','$name','$description')";

    if ($conn->query($sqlregister) === TRUE){
    echo "success";
    }else{
    echo "failed";
}
}else{
    echo "failed";
}

?>