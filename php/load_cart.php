<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

// $sql = "SELECT * FROM CLOTHESORDER WHERE EMAIL = '$email'";

$sql = "SELECT CLOTHESORDER.ID, CLOTHESORDER.QUANTITY, CLOTHESORDER.REMARKS, 
CLOTHES.IMAGE, CLOTHES.NAME, CLOTHES.PRICE FROM CLOTHESORDER 
INNER JOIN CLOTHES ON CLOTHESORDER.ID = CLOTHES.ID
WHERE CLOTHESORDER.EMAIL = '$email'";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["cart"] = array();
    while ($row = $result ->fetch_assoc()){
        $cartlist = array();
        $cartlist[id] = $row["ID"];
        $cartlist[quantity] = $row["QUANTITY"];
        $cartlist[remarks] = $row["REMARKS"];
        $cartlist[image] = $row["IMAGE"];
        $cartlist[name] = $row["NAME"];
        $cartlist[price] = $row["PRICE"];
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>