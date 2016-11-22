<?php
$request = explode('/', trim($_SERVER['PATH_INFO'], '/'));

$servername = "webmail.cs.okstate.edu";
$database = "raymocf";
$table = "categories";
$username = array_shift($request);
$password = array_shift($request);
$main_id = intval(array_shift($request));
$name = array_shift($request);
$budget = array_shift($request);
$conn = new mysqli($servername, $username, $password, $database);

if($conn->connect_error) {
    die("ERROR: Could not connect. " . mysqli_connect_error());
}


$sql = "INSERT INTO $table (main_id, name, budget) VALUES ('$main_id', '$name', '$budget')";

if(mysqli_query($conn, $sql)) {
    echo "Category added";
} else {
    echo "ERROR: " . mysqli_error($conn);
}

$conn->close();
?>
