<!DOCTYPE html>
<html>
<head>
<title>App Server 1</title>
<style>
body {
  background-color: #D3D3D3;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin: 0 auto;
}

th, td {
  border: 1px solid black;
  padding: 10px;
  text-align: center;
}

h1 {
  text-align: center;
}

.button {
  background-color: #0000FF;
  color: white;
  padding: 10px;
  margin: 10px;
  border: none;
  cursor: pointer;
}
</style>
</head>
<body>
<h1>App Server 1</h1>
<table>
<tr>
<th>ID</th>
<th>Title</th>
<th>Description</th>
<th>Due Date</th>
</tr>

<?php
$host = '10.0.2.2';
$port = '3306';
$username = 'root'; 
$password = 'root'; 
$database = 'root'; 


$mysqli = new mysqli($host, $username, $password, $database, $port);


if ($mysqli->connect_error) {
    die('MYSQL Bağlantı hatası: ' . $mysqli->connect_error);
}


echo 'MySQL connection successful.<br>';


$query = "SELECT * FROM my_table";
$result = $mysqli->query($query);

while ($row = $result->fetch_assoc()) {
    echo "<tr>";
    echo "<td>" . $row['id'] . "</td>";
    echo "<td style='color:lightblue;'>" . $row['title'] . "</td>";
    echo "<td style='color:darkblue;'>" . $row['description'] . "</td>";
    echo "<td>" . $row['due_date'] . "</td>";
    echo "</tr>";
}

echo "</table>";


$mysqli->close();
?>
<a href="create.php" class="button">Create New</a>
</body>
</html>