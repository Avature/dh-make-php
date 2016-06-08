<?php
$maintainer = "Uwe Steinmann <steinm@debian.org>";
$extraoptions = "--only 5";
$packages = array(array("pkgname"=>"memcache"));

foreach($packages as $package) {
	$cmd = "dh-make-pecl ".$extraoptions. " --maintainer \"".$maintainer."\" ".$package["pkgname"];
	echo $cmd."\n";
}
?>
