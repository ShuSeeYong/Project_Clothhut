<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$image = $_POST['image'];
$name = $_POST['name'];
$price = $_POST['price'];
$quantity = $_POST['quantity'];
$rating = $_POST['rating'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../images/clothesimages/'.$image.'.jpg';
$is_written = file_put_contents($path, $decoded_string);

if ($is_written > 0){
    $sqlregister = "INSERT INTO CLOTHES(EMAIL,IMAGE,NAME,PRICE,QUANTITY,RATING) VALUES('$email','$image','$name','$price','$quantity','$rating')";

    if ($conn->query($sqlregister) === TRUE){
    echo "success";
    }else{
    echo "failed";
}
}else{
    echo "failed";
}

?>