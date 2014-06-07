import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;

/**
 * # of users 		
 * # of categories 	
 * # of products	
 * # of sales		
 * products'categories, randomly
 * users'ages, randomly, [12,100]
 * users'states, randomly,e,g, California, New York
 * products'prices, randomly [1,100], Integer
 * quantities, randomly [1,10], integer
 * 
 **/
public class DataGeneratorBulk 
{
	HashMap<Integer, Integer> hm=new HashMap<Integer, Integer>();
	int MAXBuffer=1000000;
	private Connection conn = null;
	private Statement stmt=null;
	public static void main(String[] args) throws Exception
	{

		int Num_users		=	10000; //100
		int Num_categories	=	20;  //10
		int Num_products	=	1000;//1000
		int Num_sales		=	100000000;//10000
		
		 String  usersPath		=	"/Users/neerenpatki/Documents/UCSD/users.txt",
	    		 categoriesPath	=	"/Users/neerenpatki/Documents/UCSD/categories.txt",
	    		 productsPath	=	"/Users/neerenpatki/Documents/UCSD/products.txt",
	     		 salesPath		=	"/Users/neerenpatki/Documents/UCSD/sales.txt";
		
		DataGeneratorBulk dg=new DataGeneratorBulk();
		dg.createData(usersPath, categoriesPath, productsPath, salesPath, Num_users,Num_categories,Num_products,Num_sales);
		
	}
	
	public void createData(String usersPath, String categoriesPath, String productsPath, String salesPath, int Num_users,int Num_categories, int Num_products,int Num_sales ) throws Exception
	{
		try{
    		File file1 = new File(usersPath);
    		     //file2 = new File(categoriesPath),
    			 //file3 = new File(productsPath),
    			 //file4 = new File(salesPath);
    		file1.delete();//file2.delete();file3.delete();file4.delete();
    	}
        catch(Exception e)
    	{
    		System.out.println("It is your first time to run this code, enjoy it.");
    	}
	     openConn();
	     init();//create tables
	     
	     long start=System.currentTimeMillis();
	     generateUsers(usersPath,Num_users);
	     //generateCategories(categoriesPath,Num_categories);
	     //generateProducts(productsPath,Num_categories,Num_products);
	     //generateSales(salesPath,Num_users,Num_products, Num_sales );
	     long end=System.currentTimeMillis();
	     System.out.println("Finish, running time:"+(end-start)+"ms");
	     
	     long start2=System.currentTimeMillis();	
	     copy(usersPath,categoriesPath,productsPath,salesPath);
	     long end2=System.currentTimeMillis();
	     System.out.println("Finish, running time:"+(end2-start2)+"ms");
		 closeConn();
	}
	public boolean openConn() throws Exception
	{
	   try{
	    try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	    String url="jdbc:postgresql://127.0.0.1:5432/P1"; //database name
	    String user="postgres";							 //username
	    String password="880210";						//password
	    conn=DriverManager.getConnection(url, user, password);
	    stmt=conn.createStatement();
	    return true;
	    }
	   catch(SQLException e)
	   {
	    e.printStackTrace();
	    return false;
	   }
	
	}
	public void init()throws SQLException
	{
		//dropCreateTable("DROP TABLE states CASCADE;","CREATE TABLE states (id SERIAL PRIMARY KEY, state TEXT NOT NULL UNIQUE);");
		dropCreateTable("DROP TABLE users CASCADE;","CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT NOT NULL UNIQUE, role TEXT, age INTEGER,stateID INTEGER REFERENCES states (id) ON DELETE CASCADE);");
		//dropCreateTable("DROP TABLE categories CASCADE;","CREATE TABLE categories(id SERIAL PRIMARY KEY,name TEXT NOT NULL UNIQUE, description TEXT);");
		//dropCreateTable("DROP TABLE products CASCADE;","CREATE TABLE products (id SERIAL PRIMARY KEY,cid INTEGER REFERENCES categories (id) ON DELETE CASCADE,name TEXT NOT NULL,SKU TEXT NOT NULL UNIQUE,price INTEGER NOT NULL);");
		//dropCreateTable("DROP TABLE sales CASCADE;","CREATE TABLE sales (id SERIAL PRIMARY KEY,uid INTEGER REFERENCES users (id) ON DELETE CASCADE,pid INTEGER REFERENCES products (id) ON DELETE CASCADE,quantity INTEGER NOT NULL, price INTEGER NOT NULL);");
	}
	public boolean dropCreateTable(String sql, String sql2) throws SQLException
	{
		try{
			stmt.execute(sql);
			stmt.execute(sql2);
			return true;
		}catch(SQLException e)
		{
			stmt.execute(sql2);
			return false;
		}
	}
	public void copy(String usersPath,String categoriesPath,String productsPath, String salesPath) throws SQLException
	{
		//String statesPath = "/Users/neerenpatki/Documents/UCSD/states.txt";
		//System.out.println("==========================================================");
		/*System.out.println("Inserting states data...");
		stmt.execute("COPY states(state) FROM '"+statesPath+"' USING DELIMITERS ',';");
		System.out.println("Successfully inserted states");*/
		System.out.println("Inserting users data.....");
		stmt.execute("COPY users(name,role,age,stateID) FROM '"+usersPath+"' USING DELIMITERS ',';");
		System.out.println("Successfully inserting users data into database");
		/*System.out.println("Inserting categories data.....");
		stmt.execute("COPY categories (name,description) FROM '"+categoriesPath+"' USING DELIMITERS ',';");
		System.out.println("Successfully inserting categories data into database");
		System.out.println("Inserting products data.....");
		stmt.execute("COPY products(cid,name,SKU,price) FROM '"+productsPath+"' USING DELIMITERS ',';");
		System.out.println("Successfully inserting products data into database");
		System.out.println("Inserting sales data.....");
		stmt.execute("COPY sales(uid,pid,quantity,price) FROM '"+salesPath+"' USING DELIMITERS ',';");*/
		System.out.println("Successfully inserting sales data into database");
	}
	public boolean closeConn() throws SQLException
	{
	   conn.close();
	   return true;
	}
	
	
	//INSERT INTO users table
	public void generateUsers(String usersPath,int Num_users)
	{
		ArrayList<String> SQLs=new ArrayList<String>();
		
		int age=0;
		String name="",state="";
		String SQL="";
		String[] states={"Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia",
				"Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts",
				"Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey",
				"New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island",
				"South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"};
		String[] nameList={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		Random r=new Random();
		int flag=0;
		//SQLs.add("INSERT INTO users (name, role, age, stateID) VALUES('CSE','owner',35, 4);");
		/*SQLs.add("insert into states (state) values ('Alabama');");
		SQLs.add("insert into states (state) values ('Alaska');");
		SQLs.add("insert into states (state) values ('Arizona');");
		SQLs.add("insert into states (state) values ('Arkansas');");
		SQLs.add("insert into states (state) values ('California');");
		SQLs.add("insert into states (state) values ('Colorado');");
		SQLs.add("insert into states (state) values ('Connecticut');");
		SQLs.add("insert into states (state) values ('Delaware');");
		SQLs.add("insert into states (state) values ('Florida');");
		SQLs.add("insert into states (state) values ('Georgia');");
		SQLs.add("insert into states (state) values ('Hawaii');");
		SQLs.add("insert into states (state) values ('Idaho');");
		SQLs.add("insert into states (state) values ('Illinois');");
		SQLs.add("insert into states (state) values ('Indiana');");
		SQLs.add("insert into states (state) values ('Iowa');");
		SQLs.add("insert into states (state) values ('Kansas');");
		SQLs.add("insert into states (state) values ('Kentucky');");
		SQLs.add("insert into states (state) values ('Louisiana');");
		SQLs.add("insert into states (state) values ('Maine');");
		SQLs.add("insert into states (state) values ('Maryland');");
		SQLs.add("insert into states (state) values ('Massachusetts');");
		SQLs.add("insert into states (state) values ('Michigan');");
		SQLs.add("insert into states (state) values ('Minnesota');");
		SQLs.add("insert into states (state) values ('Mississippi');");
		SQLs.add("insert into states (state) values ('Missouri');");
		SQLs.add("insert into states (state) values ('Montana');");
		SQLs.add("insert into states (state) values ('Nebraska');");
		SQLs.add("insert into states (state) values ('Nevada');");
		SQLs.add("insert into states (state) values ('New Hampshire');");
		SQLs.add("insert into states (state) values ('New Jersey');");
		SQLs.add("insert into states (state) values ('New Mexico');");
		SQLs.add("insert into states (state) values ('New York');");
		SQLs.add("insert into states (state) values ('North Carolina');");
		SQLs.add("insert into states (state) values ('North Dakota');");
		SQLs.add("insert into states (state) values ('Ohio');");
		SQLs.add("insert into states (state) values ('Oklahoma');");
		SQLs.add("insert into states (state) values ('Oregon');");
		SQLs.add("insert into states (state) values ('Pennsylvania');");
		SQLs.add("insert into states (state) values ('Rhode Island');");
		SQLs.add("insert into states (state) values ('South Carolina');");
		SQLs.add("insert into states (state) values ('South Dakota');");
		SQLs.add("insert into states (state) values ('Tennessee');");
		SQLs.add("insert into states (state) values ('Texas');");
		SQLs.add("insert into states (state) values ('Utah');");
		SQLs.add("insert into states (state) values ('Vermont');");
		SQLs.add("insert into states (state) values ('Virginia');");
		SQLs.add("insert into states (state) values ('Washington');");
		SQLs.add("insert into states (state) values ('West Virginia');");
		SQLs.add("insert into states (state) values ('Wisconsin');");
		SQLs.add("insert into states (state) values ('Wyoming');");*/
		
		while(flag<Num_users)
		{
			age=r.nextInt(88)+12;
			//state=states[r.nextInt(states.length)];
			int stateID = r.nextInt(50)+1;
			name=nameList[r.nextInt(nameList.length)];
			flag++;
			SQL=name+"_user_"+flag+",'customer',"+age+", "+stateID;
			SQLs.add(SQL);
			if(SQLs.size()>MAXBuffer)
			{	writeToFile(usersPath, SQLs);
				SQLs.clear();
			}
		}
		writeToFile(usersPath, SQLs);
		SQLs.clear();
		System.out.println("Successfully generating users data");
	}
	//INSERT INTO categories table
	public void generateCategories(String categoriesPath,int Num_categories )
	{
		ArrayList<String> SQLs=new ArrayList<String>();
		String SQL="";
		int flag=0;
		while(flag<Num_categories)
		{
			flag++;
			SQL="C"+flag+",This is the number "+flag+" category";
			SQLs.add(SQL);
			if(SQLs.size()>MAXBuffer)
			{
				writeToFile(categoriesPath, SQLs);
				SQLs.clear();
			}
		}
		writeToFile(categoriesPath, SQLs);
		SQLs.clear();
		System.out.println("Successfully generating categories data");
	}
	//INSERT INTO products table
	public void generateProducts(String productsPath,int Num_categories,int Num_products )
	{
		String[] nameList={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		ArrayList<String> SQLs=new ArrayList<String>();
		String name="",SQL="";
		int flag=0;
		Random r=new Random();
		int cid=0;
		int price=0;
		while(flag<Num_products)
		{
			flag++;
			cid=r.nextInt(Num_categories)+1;
			name=nameList[r.nextInt(nameList.length)];
			price=r.nextInt(100)+1;
			SQL=cid+","+name+"_P"+flag+",SKU_"+flag+","+price;
			hm.put(flag, price);
			SQLs.add(SQL);
			if(SQLs.size()>MAXBuffer)
			{
				writeToFile(productsPath, SQLs);
				SQLs.clear();
			}
		}
		writeToFile(productsPath, SQLs);
		SQLs.clear();
		System.out.println("Successfully generating products data");
	}
	//INSERT INTO sales table
	public void generateSales(String salesPath,int Num_users, int Num_products,int Num_sales )
	{
		ArrayList<String> SQLs=new ArrayList<String>();
		String SQL="";
		int flag=0,price=0;
		Random r=new Random();
		int uid=0,pid=0,quantity=0;
		
		while(flag<Num_sales)
		{
			flag++;
			uid=r.nextInt(Num_users)+1;
			pid=r.nextInt(Num_products)+1;
			price=(Integer)hm.get(pid);
			quantity=r.nextInt(10)+1;
			
			SQL=uid+","+pid+","+quantity+","+price;
			SQLs.add(SQL);
			if(SQLs.size()>MAXBuffer)
			{
				writeToFile(salesPath, SQLs);
				SQLs.clear();
			}
		}
		writeToFile(salesPath, SQLs);
		SQLs.clear();
		System.out.println("Successfully generating sales data");
	}
	
	public void  writeToFile(String path, ArrayList<String> al)
	{
		BufferedWriter out = null;    
		try 
		{                                                                        
        	out = new BufferedWriter(new OutputStreamWriter( 
        		new FileOutputStream(path, true)));                              
            
      	   		for(int i=0;i<al.size();i++)
      	   		{
          	   		out.write(al.get(i));
          	   		out.newLine();
      	   		}
      	   		out.close();
      	 }
		catch (Exception e) 
        {                                                     
            e.printStackTrace();                                                    
        }
	}
	
}
