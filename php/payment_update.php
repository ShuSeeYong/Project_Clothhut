<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];
$phone = $_GET['phone'];
$amount = $_GET['amount'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];

if ($paidstatus=="true"){
  $receiptid = $_GET['billplz']['id'];
  $signing = '';
    foreach ($data as $key => $value) {
        $signing.= 'billplz'.$key . $value;
        if ($key === 'paid') {
            break;
        } else {
            $signing .= '|';
        }
    }
    
    $signed= hash_hmac('sha256', $signing, 'S-mok4hn7-L7EH_B_kqnrk0Q');
    if ($signed === $data['x_signature']) {
        
        $sqlcart ="SELECT * FROM CLOTHESORDER WHERE EMAIL = '$email'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $id = $row["ID"];
            $quantity = $row["QUANTITY"]; //cart qty
            $remarks = $row["REMARKS"];
            $sqlinsertintopaid = "INSERT INTO PAID(EMAIL,ID,QUANTITY,REMARKS) VALUES ('$email','$id','$quantity','$remarks')";
            $conn->query($sqlinsertintopaid);
            
        }
        }
        
        
        $sqldeletecart = "DELETE FROM CLOTHESORDER WHERE EMAIL = '$email'";
        $conn->query($sqldeletecart);
    }
     echo '<br><br><body><div><h2><br><br><center>Your Receipt</center>
     </h1>
     <table border=1 width=80% align=center>
     <tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td>
     <td>'.$email. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr>
     <tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr>
     <tr><td>Date </td><td>'.date("d/m/Y").'</td></tr>
     <tr><td>Time </td><td>'.date("h:i a").'</td></tr>
     </table><br>
     <p><center>Press Back Button To Return To CLOTHHUT</center></p></div></body>';
}
else{
     echo 'Payment Failed!';
}
?>