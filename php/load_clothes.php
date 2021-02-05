<?php
error_reporting(0);
include_once ("dbconnect.php");
$sql = "SELECT * FROM CLOTHES";
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["clothes"] = array();
    while ($row = $result->fetch_assoc())
    {
        $clotheslist = array();
        $clotheslist["image"] = $row["IMAGE"];
        $clotheslist["id"] = $row["ID"];
        $clotheslist["name"] = $row["NAME"];
        $clotheslist["price"] = $row["PRICE"];
        $clotheslist["quantity"] = $row["QUANTITY"];
        $clotheslist["rating"] = $row["RATING"];
        array_push($response["clothes"], $clotheslist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>