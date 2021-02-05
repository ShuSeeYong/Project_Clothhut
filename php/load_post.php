<?php
error_reporting(0);
include_once ("dbconnect.php");
$sql = "SELECT * FROM POST";
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["post"] = array();
    while ($row = $result->fetch_assoc())
    {
        $postlist = array();
        
        $postlist["image"] = $row["IMAGE"];
        $postlist["id"] = $row["ID"];
        $postlist["email"] = $row["EMAIL"];
        $postlist["username"] = $row["USERNAME"];
        $postlist["name"] = $row["NAME"];
        $postlist["description"] = $row["DESCRIPTION"];
        array_push($response["post"], $postlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>