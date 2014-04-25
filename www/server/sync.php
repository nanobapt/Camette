<?php

	if (isset($_POST["order"])){
		$order = "WAIT";

		if ($_POST["order"]=="snap")
			$order = "SNAP ".time();
		elseif ($_POST["order"]=="launch")
			$order = "LAUNCH ".time();
		elseif ($_POST["order"]=="quit")
			$order = "QUIT";

		file_put_contents("order",$order);
	}
?>


<html>
<head>
<title>Synchronize cams</title>
</head>
<body>

<form method="POST" action="sync.php">
<select name="order">
	<option value="snap">Get snapshots</option>
	<option value="launch">Launch timelapse</option>
	<option value="quit">Exit sync</option>
</select>
<input type="submit" value="Send"/>
</form>

</body>
</html>
