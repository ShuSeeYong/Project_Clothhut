<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT * FROM REVIEW WHERE id = '$id'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["review"] = array();
    while ($row = $result->fetch_assoc())
    {
        $reviewlist = array();
        $reviewlist["id"] = $row["ID"];
        $reviewlist["email"] = $row["EMAIL"];
        $reviewlist["name"] = $row["NAME"];
        $reviewlist["review"] = $row["REVIEW"];
        $reviewlist["rating"] = $row["RATING"];
        $reviewlist["date"] = $row["DATE"];
        array_push($response["review"], $reviewlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
