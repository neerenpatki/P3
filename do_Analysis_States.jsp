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
ArrayList<String> p_name_list=new ArrayList<String>();//product ID, 10
ArrayList<String> s_name_list=new ArrayList<String>();//customer ID,20
HashMap<Integer, Integer> product_ID_amount	=	new HashMap<Integer, Integer>();
HashMap<String, Integer> state_name_amount=	new HashMap<String, Integer>();
HashMap<String, Integer> state_total = new HashMap<String, Integer>();
HashMap<String, Integer> product_total = new HashMap<String, Integer>();
HashMap<String, Integer> state_cells = new HashMap<String, Integer>();
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
String  	SQL_1=null,SQL_2=null,SQL_ut=null, SQL_pt=null, SQL_row=null, SQL_col=null;
String  	SQL_amount_row=null,SQL_amount_col=null,SQL_amount_cell=null;
int 		p_id=0,u_id=0;
String		p_name=null,s_name=null;
String 		st_name = null, prod_name = null;
int 		st_tot = 0, prod_tot = 0;
int 		p_amount_price=0,s_amount_price=0;

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

	
	if(("All").equals(state) && ("0").equals(category))//0,0
	{
		SQL_1="SELECT state, SUM(sum) FROM prod_st GROUP BY state ORDER BY sum desc LIMIT "+show_num_row;
		/*SQL_1="select s.id, s.state from users u, states s where u.stateID = s.id "+
		" group by s.id order by s.state asc";*/
		SQL_2 = "SELECT pid, name, SUM(sum) FROM prod_st GROUP BY pid,name ORDER BY sum desc LIMIT "+show_num_col;
		//SQL_2="select id,name from products order by name asc limit "+show_num_col;
		SQL_ut="insert into us_t (id, state) select u2.id, state from ("+SQL_1+") as u "+
		"left outer join users u2 on u2.stateID = u.id order by state";
		SQL_pt="insert into ps_t (id, name) "+SQL_2;
		SQL_row="select count(distinct stateID) from users";
		SQL_col="select count(*) from products";
		SQL_amount_row="select u.state, sum(s.quantity*s.price) from  us_t u, sales s  where s.uid=u.id group by u.state;";
		SQL_amount_col="select s.pid, sum(s.quantity*s.price) from ps_t p, sales s where s.pid=p.id  group by s.pid;";
		SQL_cells="SELECT * FROM prod_st WHERE state IN (SELECT state FROM ("+SQL_1+") as u)"; // Get all of the information for the cells
	}
	
	if(("All").equals(state) && !("0").equals(category))//0,1
	{
		SQL_1="select s.id, s.state from users u, states s where u.stateID = s.id "+
		" group by s.id order by s.state asc limit "+show_num_row;
		SQL_2="select id,name from products where cid="+category+" order by name asc limit "+show_num_col;
		SQL_ut="insert into us_t (id, state) select u2.id, state from ("+SQL_1+") as u "+
		"left outer join users u2 on u2.stateID = u.id order by state";
		SQL_pt="insert into ps_t (id, name) "+SQL_2;
		SQL_row="select count(distinct stateID) from users";
		SQL_col="select count(*) from products where cid="+category+"";
		SQL_amount_row="select u.state, sum(s.quantity*s.price) from  us_t u, sales s, products p  where s.pid=p.id and p.cid="+category+" and s.uid=u.id group by u.state;";
		SQL_amount_col="select s.pid, sum(s.quantity*s.price) from ps_t p, sales s  where s.pid=p.id group by s.pid;";
	}
	if(!("All").equals(state) && ("0").equals(category))//1,0
	{
		SQL_1="select s.id, s.state from users u, states s where s.state='"+state+"' and u.stateID = s.id "+"group by s.id order by state asc limit "+show_num_row;
		SQL_2="select id,name from products order by name asc limit "+show_num_col;
		SQL_ut="insert into us_t (id, state) select u2.id, state from ("+SQL_1+") as u left "+
		"outer join users u2 on u2.stateID = u.id order by state";
		SQL_pt="insert into ps_t (id, name) "+SQL_2;
		SQL_row="select count(distinct stateID) from users u, states s where s.state='"+state+"' and "+
		"u.stateID = s.id";
		SQL_col="select count(*) from products";
		SQL_amount_row="select u.state, sum(s.quantity*s.price) from  us_t u, sales s  where s.uid=u.id group by u.state;";
		SQL_amount_col="select s.pid, sum(s.quantity*s.price) from ps_t p, sales s, users u, states st"+
		" where s.pid=p.id and s.uid=u.id and u.stateID = st.id and st.state ='"+state+
		"' group by s.pid;";
	}
	if(!("All").equals(state) && !("0").equals(category))//1,1
	{
		SQL_1="select s.id, s.state from users u, states s where s.state='"+state+
		"' and u.stateID = s.id group by state order by state asc limit "+show_num_row;
		SQL_2="select id,name from products where cid="+category+" order by name asc offset "+pos_col+" limit "+show_num_col;
		SQL_ut="insert into us_t (id, state) select u2.id, u.state from ("+SQL_1+") as u left outer join users u2 on u2.state=u.state order by u.state";
		SQL_pt="insert into ps_t (id, name) "+SQL_2;
		SQL_row="select count(distinct stateID) from users u, states s where u.stateID = s.id and "+
		"s.state='"+state+"'";
		SQL_col="select count(*) from products where cid="+category+"";
		SQL_amount_row="select u.state, sum(s.quantity*s.price) from  us_t u, sales s, products p  where s.pid=p.id and p.cid="+category+" and s.uid=u.id group by u.state;";
		SQL_amount_col="select s.pid, sum(s.quantity*s.price) from ps_t p, sales s, users u where s.pid=p.id  and s.uid=u.id and u.state='"+state+"' group by s.pid;";

	}
	

	//top 20 states and totals
	rs=stmt.executeQuery(SQL_1);
	while(rs.next())
	{
		st_name = rs.getString(1);
		st_tot = rs.getString(2);
		state_total.put(st_name, st_tot);
		/*s_name=rs.getString(2);
		s_name_list.add(s_name);
		state_name_amount.put(s_name, 0);*/
		
	}
//	out.println(SQL_1+"<br>"+SQL_2+"<br>"+SQL_pt+"<BR>"+SQL_ut+"<br>"+SQL_row+"<BR>"+SQL_col+"<br>");
	//product name
	//top 10 products and totals
	rs=stmt.executeQuery(SQL_2);
	while(rs.next())
	{
		prod_name = rs.getString(2);
		prod_tot = rs.getInt(3);
		product_total.put(prod_name, prod_tot);
		p_list.add(rs.getInt(1)); // Store the pid of the top 10 products
		p_name_list.add(prod_name); // Store the names of the top 10 products
		/*p_id=rs.getInt(1);   
		p_name=rs.getString(2);
		p_list.add(p_id);
	    p_name_list.add(p_name);
		product_ID_amount.put(p_id,0);*/
		
	}
	conn.setAutoCommit(false);
    //stmt2.execute("CREATE TEMP TABLE us_t (id int, state text)ON COMMIT DELETE ROWS;");
	//stmt2.execute("CREATE TEMP TABLE ps_t (id int, name text)ON COMMIT DELETE ROWS;");
	//temporary table
	//customer tempory table
	//stmt2.execute(SQL_ut);
	//product tempory table
	//stmt2.execute(SQL_pt);

	
	//count the total tuples in  usres and products after filterings
	/*int maxState=0;
	rs=stmt.executeQuery(SQL_row);//if only customer can buy products, then limit to only customers
	if(rs.next())
	{
		maxState=rs.getInt(1);
	}
	int maxProduct=0;
	rs=stmt.executeQuery(SQL_col);//if only customer can buy products, then limit to only customers
	if(rs.next())
	{
		maxProduct=rs.getInt(1);
	}*/
	
%>	
<%	

	
	
	
//	out.println(SQL_amount_row+"<br>"+SQL_amount_col+"<br>"+SQL_amount_cell+"<BR>");
	
	// Store the cells purchases
	rs=stmt.executeQuery(SQL_cells);
	while (rs.next()) {
		state_cells.put(rs.getString(2), )
	}
	/*rs=stmt.executeQuery(SQL_amount_row);
	while(rs.next())
	{
		s_name=rs.getString(1);
		s_amount_price=rs.getInt(2);
		if(state_name_amount.get(s_name)!=null)
		{
			state_name_amount.put(s_name,s_amount_price);
		}
   }
	rs=stmt.executeQuery(SQL_amount_col);
	while(rs.next())
	{
		p_id=rs.getInt(1);   
		p_amount_price=rs.getInt(2);
		if(product_ID_amount.get(p_id)!=null)
		{
			product_ID_amount.put(p_id,p_amount_price);
		}
	}*/

   
    int i=0,j=0;
	HashMap<String, String> pos_idPair=new HashMap<String, String>();
	HashMap<String, Integer> idPair_amount=new HashMap<String, Integer>();	
	int amount=0;
	
%>
	<table align="center" width="100%" border="1">
		<tr align="center">
			<td width="12%"><table align="center" width="100%" border="0"><tr align="center"><td><strong><font size="+2" color="#9933CC">STATE</font></strong></td></tr></table></td>
			<td width="88%">
				<table align="center" width="100%" border="1">
					<tr align="center">
<%	
	int amount_show=0;
	for(i=0;i<p_list.size();i++)
	{
		p_id			=   p_list.get(i);
		p_name			=	p_name_list.get(i);
		if(product_ID_amount.get(p_id)!=null)
		{
			amount_show=(Integer)product_ID_amount.get(p_id);
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
<tr><td width="12%">
	<table align="center" width="100%" border="1">
	<%	
		for(i=0;i<s_name_list.size();i++)
		{
			s_name			=	s_name_list.get(i);
			if(state_name_amount.get(s_name)!=null)
			{
				amount_show=(Integer)state_name_amount.get(s_name);
				if(amount_show!=0)
				{
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+s_name+"(<font color='#0000ff'>$"+amount_show+"</font>)</strong></td></tr>");
				}
				else
				{
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+s_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
				}	
			}
			else
			{
				out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+s_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
			}
			for(j=0;j<p_list.size();j++)
			{
				p_id	=   p_list.get(j);
				pos_idPair.put(i+"_"+j, s_name+"_"+p_id);
				idPair_amount.put(s_name+"_"+p_id,0);
			}
		}
	%>
	</table>
</td>
<td width="88%">	
	<%	

		SQL_amount_cell="select u.state, s.pid, sum(s.quantity*s.price) from us_t u,ps_t p, sales s where s.uid=u.id and s.pid=p.id group by u.state, s.pid;";
		 rs=stmt.executeQuery(SQL_amount_cell);
		 while(rs.next())
		 {
			 s_name=rs.getString(1);
			 p_id=rs.getInt(2);
			 amount=rs.getInt(3);
			 idPair_amount.put(s_name+"_"+p_id, amount);
		 }
		
	%>	 
	<table align="center" width="100%" border="1">
	<%	
		String idPair="";
		for(i=0;i<s_name_list.size();i++)
		{
			out.println("<tr  align='center'>");
			for(j=0;j<p_list.size();j++)
			{
				idPair=(String)pos_idPair.get(i+"_"+j);
				amount=(Integer)idPair_amount.get(idPair);
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
			out.println("</tr>");
		}
	%>
	</table>
	
</td>
</tr>
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