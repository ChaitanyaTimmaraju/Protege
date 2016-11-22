<?php
$request = explode('/', trim($_SERVER['PATH_INFO'], '/'));

$servername = "webmail.cs.okstate.edu";
$database = "raymocf";
$table = "items";

$username = array_shift($request);
$password = array_shift($request);

$main_id = array_shift($request);
$category_name = array_shift($request);
$item_name = array_shift($request);
$cost = array_shift($request);
$deposit = array_shift($request);
$balance_due_date = array_shift($request);
$paid_by = array_shift($request);

$conn = new mysqli($servername, $username, $password, $database);

if($conn->connect_error) {
    die("ERROR: Could not connect. " . mysqli_connect_error());
}

$columns = "(main_id, category_name, item_name, cost, deposit, balance_due_date, paid_by)";
$args = "('$main_id', '$category_name', '$item_name', '$cost', '$deposit', '$balance_due_date', '$paid_by')";

$sql = "INSERT INTO $table $columns VALUES $args";

if(mysqli_query($conn, $sql)) {
    echo "Record added";
} else {
    echo "ERROR: " . mysqli_error($conn);
}




$conn->close();
?>
