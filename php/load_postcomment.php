<?php
error_reporting(0);
include_once("dbconnect.php");

$name = $_POST['name'];

$sql = "SELECT * FROM COMMENT WHERE NAME = '$name'"; 
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["comments"] = array();
    
    while ($row = $result ->fetch_assoc()){
        $commentlist = array();
        $commentlist[name] = $row["NAME"];
        $commentlist[caption] = $row["CAPTION"];
        $commentlist[useremail] = $row["USEREMAIL"];
        $commentlist[username] = $row["USERNAME"];
        $commentlist[datecomment] = $row["DATECOMMENT"];
        
        array_push($response["comments"], $commentlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>