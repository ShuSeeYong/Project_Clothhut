<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$id = $_POST['id'];
$quantity = $_POST['quantity'];
$remarks = $_POST['remarks'];

$sqlcheck = "SELECT * FROM CLOTHESORDER WHERE ID = '$id' AND EMAIL = '$email'";
$result = $conn->query($sqlcheck);
if ($result->num_rows > 0) {
    $sqlupdate = "UPDATE CLOTHESORDER SET QUANTITY = '$quantity' ,REMARKS = '$remarks' WHERE ID = '$id' AND EMAIL = '$email'";
    if ($conn->query($sqlupdate) === TRUE){
        echo "success";    
    }
} 
else{
    $sqlinsert = "INSERT INTO CLOTHESORDER(EMAIL,ID,QUANTITY,REMARKS) VALUES ('$email','$id','$quantity','$remarks')";
    if ($conn->query($sqlinsert) === TRUE){
       echo "success";    
    }
}

?>
