<input type=hidden name="id" value="<%=form.getId()%>">

<p>
* Login ID<br>
<input name="loginId" value="<%=form.getLoginId()%>">

<p>
* Password<br>
<input type=password name="password" value="<%=form.getPassword()%>">

<p>
<input type=checkbox name="role" value="admin" <%=form.getRoleSelectionAttr("admin")%>>Admin
&nbsp;
<input type=checkbox name="role" value="ae" <%=form.getRoleSelectionAttr("ae")%>>AE

<p>
* Name<br>
<input name="fullname" value="<%=form.getFullname()%>">

<p>
* Email<br>
<input name="email" size=30 value="<%=form.getEmail()%>">

<p>
* Phone<br>
<input name="phone" value="<%=form.getPhone()%>">