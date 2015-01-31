
<!-- TWO STEPS TO INSTALL DATE PICKER:

  1.  Copy the coding into the HEAD of your HTML document
  2.  Add the last code into the BODY of your HTML document  -->

<!-- STEP ONE: Paste this code into the HEAD of your HTML document  -->

<HEAD>


<script language="JavaScript" src="js/calendar.js"></script>
<script language="JavaScript" src="js/overlib_mini.js"></script>
<script language="JavaScript" src="js/in.js"></script>
</HEAD>

<!-- STEP TWO: Copy this code into the BODY of your HTML document  -->

<BODY>

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->
<!-- Original:  James O'Connor (joconnor@nordenterprises.com) -->
<!-- Web Site:  http://nordenterprises.com -->


<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
<p>Pop-up calendar sample page:</p>
<form name="sample" method="post" action="popupcalsample.html">
	<p>Beginning date: 
	
	<input type="text" name="T1" size="20">  
	<a href="javascript:show_calendar('sample.T1');" onMouseOver="window.status='選擇日曆上的日期.'; overlib('選擇日曆上的日期.'); return true;" onMouseOut="window.status=''; nd(); return true;"><img src="images/show-calendar.gif" width=24 height=22 border=0></a>
	<br>
	<input type="text" name="T2" size="20" onblur="checkYear()">  
	
	
	</p>
	
	<p><input type="submit" value="Submit" name="B1"><input type="reset"
	value="Reset" name="B2"></p>
</form>
