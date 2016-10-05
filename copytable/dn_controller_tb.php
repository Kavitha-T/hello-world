<!DOCTYPE HTML>
<html>

<head>
<title>SITE SETUP </title>
<link rel="stylesheet" type="text/css" href="style_dn_controller_tb.css">
<script>

</script>

</head>
<body>
<?php
$errurl = " ";
$errsite=" ";
$output = " ";
$errversion = " ";
$errpserver = " ";
$errwserver = " ";

if($_SERVER['REQUEST_METHOD']=='POST')
{
	
 if (empty($_POST["txturl"])) 
  {
   $errurl = "Url Required";
  } 
  else 
  {
  $url= $_POST['txturl'];
  }
  
  if (empty($_POST["txtsitename"])) 
  {
    $errsite= "SiteName Required";
  } 
  else 
  {
    $dbnew = $_POST['txtsitename'];
  }
  
   if ($_POST["txtversion"] === "select") 
  {
    $errversion= "Version Required";
  } 
  else 
  {
    $version = $_POST['txtversion'];
  }
  
  if ($_POST["txtpserver"] === "select") 
  {
    $errpserver= "PageServer Required";
  } 
  else 
  {
    $pserver = $_POST['txtpserver'];
  }
  
  if ($_POST["txtwserver"] === "select") 
  {
    $errwserver= "WebServer Required";
  } 
  else 
  {
  $wserver = $_POST['txtwserver'];
  }
exec("perl db_copy_table_exeter_pl.pl $url $dbnew", $output);
}

?>


<div id='img'><img src="img/exeter_premedia_services.png" alt="Exeter Premedia Services" width="60%" style="display: block; margin: 40px auto;">
</div>
<div> </div>
<div class = "div1" style ="overflow-x:auto;">
<form action="" method="post">
<p> SITE SETUP</p>
<table class = "table" cellspacing="8" cellpadding="8">
<tr>
<td><label class="label"> Url </label></td> 
<td><input type = "text" class="text" name="txturl" placeholder="Enter the Url"/>
<span style="color:red">* <?php echo $errurl; ?></span></td></td>
</tr>

<tr>
<td><label class="label"> Site Name </label></td>
<td><input type = "text" class="text" name="txtsitename" placeholder="Enter the site-name"/>
<span style="color:red">* <?php echo $errsite; ?></span></td>
</tr>

<tr>
<td><label class="label"> Version </label></td>
<td>
<select class="dropdown" name="txtversion">  
      
      <option value = "cms-0.9.39-alpha">cms-0.9.39-alpha</option>
      <option value = "cms-0.9.39-alpha">cms-0.9.40-alpha</option>
      <option value = "cms-0.9.40-alpha-qa">cms-0.9.40-alpha-qa</option>
      <option value = "cms-0.9.40-alpha-qa">cms-0.9.40-alpha-qa-dev</option>
      <option value = "cms-0.9.40-alpha-qa">cms-0.9.40-alpha-qa-stg</option>
	  <option value = "cms-kriya-bmj-abs-0.1">cms-kriya-bmj-abs-0.1</option>
</select>
<span style="color:red"> <?php echo $errversion; ?></span>
</td>
</tr>

<tr>
<td><label class="label"> Page Server </label></td>
<td>
<select class="dropdown" name="txtpserver" > 
      
      <option value = "pag3.ama.uk.com">pag3.ama.uk.com</option>
      <option value = "pag3.ama.uk.com">pag4.ama.uk.com</option>
      <option value = "pag2.ama.uk.com:8099">pag2.ama.uk.com:8099</option>
	  <option value = "pag3.ama.uk.com:8099">pag3.ama.uk.com:8099</option>
</select>
<span style="color:red"> <?php echo $errpserver; ?></span>
</td>
</tr>

<tr>
<td><label class="label"> Web Server</label></td>
<td>
<select class="dropdown" name="txtwserver"> 
     
      <option value = "cms30">cms30</option>
      <option value = "cms31">cms31</option>
      <option value = "cms32">cms32</option>
</select>
<span style="color:red"><?php echo $errwserver; ?></span>
</td>
</tr>
<tr>
<td><input type ="submit" value="Submit" name="submit" class="button" /></td>
<td><input type ="reset" value="Cancel" name="cancel" class="button" /></td>
</tr>
</table>

</form>
</div>

<div class="div">
<?php print_r($output);  ?>
</div>
</body>

</html>