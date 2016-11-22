<?php
$request = explode('/', trim($_SERVER['PATH_INFO'], '/'));

$servername = "webmail.cs.okstate.edu";
$database = "raymocf";
$table = "categories";
$username = array_shift($request);
$password = array_shift($request);
$main_id = intval(array_shift($request));
$conn = new mysqli($servername, $username, $password, $database);

if($conn->connect_error) {
    die("ERROR: Could not connect. " . mysqli_connect_error());
}

$sql = "SELECT * FROM $table WHERE main_id = $main_id";
$result = $conn->query($sql);
$rows = array();

while($r = mysqli_fetch_assoc($result)) {
  $rows[] = $r;
}

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=UTF-8');

echo json_encode($rows);


$conn->close();
?>
