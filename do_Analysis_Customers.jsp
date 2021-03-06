<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>

<body>
<%
ArrayList<Integer> p_list=new ArrayList<Integer>();//product ID, 10
ArrayList<Integer> u_list=new ArrayList<Integer>();//customer ID,20
ArrayList<String> p_name_list=new ArrayList<String>();//product ID, 10
ArrayList<String> u_name_list=new ArrayList<String>();//customer ID,20
HashMap<Integer, Integer> product_ID_amount	=	new HashMap<Integer, Integer>();
HashMap<Integer, Integer> customer_ID_amount=	new HashMap<Integer, Integer>();
HashMap<String, Integer> customer_total=	new HashMap<String, Integer>();
HashMap<String, Integer> product_total=	new HashMap<String, Integer>();
HashMap<String, Integer> customer_cells=	new HashMap<String, Integer>();
%>
<%
	String  state=null, category=null, age=null;
	try { 
			state     =	request.getParameter("state"); 
			category  =	request.getParameter("category"); 
			age       =	request.getParameter("age"); 			
	}
	catch(Exception e) 
	{ 
       state=null; category=null; age=null;
	}
	String  pos_row_str=null, pos_col_str=null;
	int pos_row=0, pos_col=0;
	try { 
			pos_row_str     =	request.getParameter("pos_row"); 
			pos_row=Integer.parseInt(pos_row_str);		
			pos_col_str     =	request.getParameter("pos_col"); 
			pos_col=Integer.parseInt(pos_col_str);		
	}
	catch(Exception e) 
	{ 
       pos_row_str=null; pos_row=0;
       pos_col_str=null; pos_col=0;

	}
%>
<%
Connection	conn=null;
Statement 	stmt,stmt2;
ResultSet 	rs=null;
String  	SQL_1=null,SQL_2=null,SQL_ut=null, SQL_pt=null, SQL_row=null, SQL_col=null, SQL_cells=null;
String  	SQL_amount_row=null,SQL_amount_col=null,SQL_amount_cell=null;
int 		p_id=0,u_id=0;
String		p_name=null,u_name=null;
String 		st_name = null, prod_name = null;
int 		u_tot = 0, prod_tot = 0;
int 		p_amount_price=0,u_amount_price=0;

int show_num_row=20, show_num_col=10;
	
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://127.0.0.1:5432/P1";
	String user="postgres";
	String password="880210";
	conn =DriverManager.getConnection(url, user, password);
	stmt =conn.createStatement();
	stmt2 =conn.createStatement();
	
	
	if(("All").equals(state) && ("0").equals(category))//0,0,0
	{
		SQL_1="SELECT uname, SUM(sum) FROM customers GROUP BY uname ORDER BY sum DESC LIMIT 20";
		SQL_2 = "SELECT name, SUM(sum) FROM prodTot GROUP BY name ORDER BY sum DESC LIMIT 10";
		SQL_cells="SELECT * FROM prod_user WHERE name IN (SELECT name FROM ("+SQL_2+") as v) AND uname IN (SELECT uname FROM ("+SQL_1+") as u)";
	}
	
	if(("All").equals(state) && !("0").equals(category))//0,1,0
	{
		SQL_1="SELECT uname, sum FROM customers WHERE cid = "+category+" ORDER BY sum DESC LIMIT 20";
		SQL_2="SELECT name, SUM(sum) FROM prodTot WHERE cid = "+category+
		" GROUP BY name ORDER BY sum DESC LIMIT 10";
		SQL_cells="SELECT * FROM prod_user WHERE name IN (SELECT name FROM ("+SQL_2+") as v) AND uname IN (SELECT uname FROM ("+SQL_1+") as u)";
	}
	if(!("All").equals(state) && ("0").equals(category))//1,0,0
	{
		SQL_1="SELECT uname, SUM(sum) FROM customers WHERE state = '"+state+
		"' GROUP BY uname ORDER BY sum DESC LIMIT 20";
		SQL_2="SELECT name, sum FROM prodTot WHERE state = '"+state+"' ORDER BY sum DESC LIMIT 10";
		SQL_cells="SELECT * FROM prod_user WHERE name IN (SELECT name FROM ("+SQL_2+") as v) AND uname IN (SELECT uname FROM ("+SQL_1+") as u)";
	}
	if(!("All").equals(state) && !("0").equals(category))//1,1,0
	{
		SQL_1="SELECT uname, sum FROM customers WHERE state = '"+state+"' AND cid = "+category+" ORDER BY sum DESC LIMIT 20";
		SQL_2="SELECT name, sum FROM prodTot WHERE state = '"+state+"' AND cid = "+category+" ORDER BY sum DESC LIMIT 10";
		SQL_cells="SELECT * FROM prod_user WHERE name IN (SELECT name FROM ("+SQL_2+") as v) AND uname IN (SELECT uname FROM ("+SQL_1+") as u)";
		String SQL_users = "SELECT u.name FROM users u, states s "+
		"WHERE s.id = u.stateID and state = '"+state+"'";
		rs=stmt.executeQuery(SQL_users);
	}
	ArrayList<String> users = new ArrayList<String>();
	if (rs != null) {
		while (rs.next()) {
			users.add(rs.getString(1));
		}
	}
	//customer name
	rs=stmt.executeQuery(SQL_1);

	while(rs.next())
	{
		u_name=rs.getString(1);
		u_tot=rs.getInt(2);
		customer_total.put(u_name, u_tot);
		u_name_list.add(u_name);
		users.remove(u_name);
	}
	int k = 0;
	for (int i = u_name_list.size(); i < show_num_row; i++) {
		if (k < users.size()) {
			u_name_list.add(users.get(k));
			k++;
		}
	}
//	out.println(SQL_1+"<br>"+SQL_2+"<br>"+SQL_pt+"<BR>"+SQL_ut+"<br>"+SQL_row+"<BR>"+SQL_col+"<br>");
	//product name
	rs=stmt.executeQuery(SQL_2);
	while(rs.next())
	{
		prod_name = rs.getString(1);
		prod_tot = rs.getInt(2);
		product_total.put(prod_name, prod_tot);
		p_name_list.add(prod_name); // Store the names of the top 10 products
	}	
	//temporary table
	conn.setAutoCommit(false);
%>	
<%	
	
//	out.println(SQL_amount_row+"<br>"+SQL_amount_col+"<br>"+SQL_amount_cell+"<BR>");
	
	rs=stmt.executeQuery(SQL_cells);
	while(rs.next())
	{
		p_name = rs.getString(2);
		u_name = rs.getString(5);
		customer_cells.put(p_name+"_"+u_name, rs.getInt(7));
   }
    int i=0,j=0;
	HashMap<String, String> pos_idPair=new HashMap<String, String>();
	HashMap<String, Integer> idPair_amount=new HashMap<String, Integer>();	
	int amount=0;
	
%>
	<table align="center" width="100%" border="1">
		<tr align="center">
			<td width="17%"><table align="center" width="100%" border="0"><tr align="center"><td><strong><font size="+2" color="#FF00FF">CUSTOMER</font></strong></td></tr></table></td>
			<td width="83%">
				<table align="center" width="100%" border="1">
					<tr align="center">
<%	
	int amount_show=0;
	for(i=0;i<p_name_list.size();i++)
	{
		p_name			=	p_name_list.get(i);
		if(product_total.get(p_name)!=null)
		{
			amount_show=(Integer)product_total.get(p_name);
			if(amount_show!=0)
			{
				out.print("<td width='10%'><strong>"+p_name+"<br>(<font color='#0000ff'>$"+amount_show+"</font>)</strong></td>");
			}
			else
			{
				out.print("<td width='10%'><strong>"+p_name+"<br>(<font color='#ff0000'>$0</font>)</strong></td>");
			}	
		}
		else
		{
			out.print("<td width='10%'><strong>"+p_name+"<br>(<font color='#ff0000'>$0</font>)</strong></td>");
		}
	}
%>
					</tr>
				</table>
			</td>
		</tr>
	</table>
<table align="center" width="100%" border="1">
<tr><td width="17%">
	<table align="center" width="100%" border="1">
	<%	
		for(i=0;i<u_name_list.size();i++)
		{
			u_name			=	u_name_list.get(i);
			if(customer_total.get(u_name)!=null)
			{
				amount_show=(Integer)customer_total.get(u_name);
				if(amount_show!=0)
				{
					out.println("<tr align=\"center\"><td width=\"17%\"><strong>"+u_name+"(<font color='#0000ff'>$"+amount_show+"</font>)</strong></td></tr>");
				}
				else
				{
					out.println("<tr align=\"center\"><td width=\"17%\"><strong>"+u_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
				}	
			}
			else
			{
				out.println("<tr align=\"center\"><td width=\"17%\"><strong>"+u_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
			}
		}
	%>
	</table>
</td>
<td width="88%">	
	<table align="center" width="100%" border="1">
	<%	
		String idPair="";
		for(i=0;i<u_name_list.size();i++)
		{	
			u_name = u_name_list.get(i);
			out.println("<tr  align='center'>");
			for(j=0;j<p_name_list.size();j++)
			{
				p_name = p_name_list.get(j);
				if (customer_cells.get(p_name+"_"+u_name) != null)
				{
					amount=(Integer)customer_cells.get(p_name+"_"+u_name);
					if(amount==0)
					{
						out.println("<td width=\"10%\"><font color='#ff0000'>0</font></td>");
					}
					else
					{
						out.println("<td width=\"10%\"><font color='#0000ff'><b>"+amount+"</b></font></td>");
					}
					amount=0;
				}
				else {
					out.println("<td width=\"10%\"><font color='#ff0000'>0</font></td>");
				}
			}
			out.println("</tr>");
		}
	%>
	</table>
	
</td>
</tr>
</table>	
	
<%
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
catch(Exception e)
{
  out.println(e);
  out.println("Fail! Please connect your database first.");
}
%>	

</body>
</html>