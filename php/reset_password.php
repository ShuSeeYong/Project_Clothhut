<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);


$sql = "SELECT * FROM USER WHERE EMAIL = '$email' ";
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $sqlupdatepass = "UPDATE USER SET PASSWORD = '$password' WHERE EMAIL = '$email'";
    $resultPass = $conn->query($sqlupdatepass);
    
    if ($resultPass === true)
	{
		echo "success";
	}
	
	else
	{
		echo "failed";
	}
    
}
else
{
    echo "error";
}
?>