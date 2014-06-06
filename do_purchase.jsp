<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<%@include file="welcome.jsp" %>
<%
if(session.getAttribute("name")!=null)
{

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charSet=utf-8" />
<title>CSE135</title>
</head>

<body>

<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="products_browsing.jsp" target="_self">Show Products</a></td></tr>
		<tr><td><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr>
	</table>	
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<p><table align="center" width="80%" style="border-bottom-width:2px; border-top-width:2px; border-bottom-style:solid; border-top-style:solid">
	<tr><td align="left"><font size="+3">
	<%
	String uName=(String)session.getAttribute("name");
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
	String card=null;
	int card_num=0;
	try {card=request.getParameter("card"); }catch(Exception e){card=null;}
	try
	{
		 card_num    = Integer.parseInt(card);
		 if(card_num>0)
		 {
	
				Connection conn=null;
				Statement stmt=null, prodUserStmt = null, tempstmt = null, checkStmt = null, checkStmt2 = null, sumStmt = null, sumStmt2 = null;
				ResultSet prodUserRS = null, rs = null, checkRS = null, checkRS2 = null, sumRS = null, sumRS2 = null;
				String productName = null, userName = null, stateName = null;
				int categoryID = 0;
				int prodUserSum = 0;
				int pid = 0;
				int uid = 0;
				try
				{
					
					String SQL_copy="INSERT INTO sales (uid, pid, quantity, price) select c.uid, c.pid, c.quantity, c.price from carts c where c.uid="+userID+";";
					
					String  SQL="delete from carts where uid="+userID+";";
					
					/* TO UPDATE prod_user TABLE */
					String prodUserSQL = "SELECT p.name, p.cid, u.name, s.state, SUM(c.price * c.quantity) AS sum FROM products p, carts c, users u, states s WHERE p.id = c.pid AND c.uid = u.id AND u.stateID = s.id GROUP BY p.name, p.cid, u.name, s.state " + ";";
										
					
					/* Get the sum of transaction from carts*/
					String prodUserSumSQL = "SELECT uid, pid, SUM(c.price * c.quantity) FROM carts c, users u GROUP BY uid, pid;";
					
					/*Get sum of transaction from carts*/
					String prodStSumSQL = "SELECT s.state, c.pid, SUM(c.price * c.quantity) FROM users u, carts c, states s WHERE c.uid = u.id AND u.stateID = s.id GROUP BY s.state, c.pid";
					
					/*Get the pid and uid from carts for current transaction */
					String tempSQL = "SELECT * FROM carts c;"; 
										
					/* Check if tuple in prod_user already exists with given attribs */
					String checkSQL = "SELECT pu.id, pu.uname FROM prod_user pu, carts c WHERE c.pid = pu.pid AND pu.id = c.uid;";
					
					String checkSQL2 = "SELECT ps.pid, ps.name, s.state FROM prod_st ps, carts c, users u, states s WHERE c.pid = ps.pid AND c.uid = u.id AND u.stateID = s.id AND ps.state = s.state;";
										
										
										
					try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
					String url="jdbc:postgresql://127.0.0.1:5432/P1";
					String user="postgres";
					String password="880210";
					conn =DriverManager.getConnection(url, user, password);
					stmt =conn.createStatement();
					tempstmt = conn.createStatement();
				    prodUserStmt = conn.createStatement();
				    checkStmt = conn.createStatement();
				    checkStmt2 = conn.createStatement();
				    sumStmt = conn.createStatement();
				    sumStmt2 = conn.createStatement();
				    
				    /* To insert new tuple into prod_user */
				    PreparedStatement prodUserpstmt = conn.prepareStatement( "INSERT INTO prod_user(pid, name, cid, id, uname, state, sum) VALUES(?, ?, ?, ?, ?, ?, ?);");
				    
				    PreparedStatement 
				    
				    /* Update a tuple in prod_user */
				    PreparedStatement updatepstmt = conn.prepareStatement( "UPDATE prod_user SET sum = sum + ? WHERE pid = ? AND id = ?;");
				    PreparedStatement updateStatepstmt = conn.prepareStatement( "UPDATE prod_st SET sum = sum + ? WHERE state = ? AND pid = ?;");
				    
					try{
							conn.setAutoCommit(false);
							/**record log,i.e., sales table**/
							stmt.execute(SQL_copy); 
							rs =  tempstmt.executeQuery(tempSQL);
							prodUserRS = prodUserStmt.executeQuery(prodUserSQL);
							checkRS = checkStmt.executeQuery(checkSQL);
							checkRS2 = checkStmt2.executeQuery(checkSQL2);
							sumRS = sumStmt.executeQuery(prodUserSumSQL);
							sumRS2 = sumStmt2.executeQuery(prodStSumSQL);
								
							stmt.execute(SQL);
							conn.commit();							
							conn.setAutoCommit(true);
					
					
						
					//Check if user,product tuple is already in prod_user	
					if(checkRS.next()){
					    while(sumRS.next()){//the correct sum from an RS has a next{
					        //Update the prepared statement
					        //Execute the prepared statement
					        updatepstmt.setInt(1, sumRS.getInt(3));
					        updatepstmt.setInt(2, sumRS.getInt(2));
					        updatepstmt.setInt(3, sumRS.getInt(1));
					        updatepstmt.execute();
					    }
					}									
					else{
							/*Store fields to insert into prod_User */
							while(prodUserRS.next()){
							
							    productName = prodUserRS.getString(1);//
							    categoryID = prodUserRS.getInt(2);//
							    userName = prodUserRS.getString(3);
							    stateName = prodUserRS.getString(4);//
							    prodUserSum = prodUserRS.getInt(5);//
							    
							    //Assign pid and uid to each tuple ONCE
							    if(rs.next()){
							        uid = rs.getInt(2);
							        pid = rs.getInt(3);
							    
							        prodUserpstmt.setInt(1, pid);
							        prodUserpstmt.setInt(4, uid);
                                }
							    
							    //Set prepared statement wildcards
							    prodUserpstmt.setString(2, productName);
							    prodUserpstmt.setInt(3, categoryID);
							    prodUserpstmt.setString(5, userName);
							    prodUserpstmt.setString(6, stateName);
							    prodUserpstmt.setInt(7,prodUserSum);
							    
							    //Execute prepared statement for each product purchased.
							    prodUserpstmt.execute();
							    
							}
				    }	
				    
				    
				    if(checkRS2.next()){
                        while(sumRS2.next()){
                                out.println("ADSJASDAS");
                                updateStatepstmt.setInt(3, sumRS2.getInt(2));
                                updateStatepstmt.setString(2, sumRS2.getString(1));
                                updateStatepstmt.setInt(1, sumRS2.getInt(3));
                                updateStatepstmt.execute();
                        
                        }
				    }
				    else{
				            
				    
				    
				    
				    }
				    
				
				    
				    
				    
				    
				    		

							out.println("Dear customer '"+uName+"', Thanks for your purchasing.<br> Your card '"+card+"' has been successfully proved. <br>We will ship the products soon.");
							out.println("<br><font size=\"+2\" color=\"#990033\"> <a href=\"products_browsing.jsp\" target=\"_self\">Continue purchasing</a></font>");
					}
					catch(Exception e)
					{
						out.println("Fail! Please try again <a href=\"purchase.jsp\" target=\"_self\">Purchase page</a>.<br><br>");
						out.println(e);
					}
					conn.close();
				}
				catch(Exception e)
				{
						out.println("<font color='#ff0000'>Error.<br><a href=\"purchase.jsp\" target=\"_self\"><i>Go Back to Purchase Page.</i></a></font><br>");
						
				}
			}
			else
			{
			
				out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\"></a> again.");
			}
		}
	catch(Exception e) 
	{ 
		out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\"></a> again.");
	}
%>
	
	</font><br>
</td></tr>
</table>
</div>
</body>
</html>
<%}%>