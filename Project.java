
import java.util.*;
import java.sql.*;

public class Project {
	static String username;
	static String password;
	static String url = "jdbc:mysql://localhost/miniProject?useSSL=false";
	static Scanner in = new Scanner(System.in);
	String Align = " ";
	static String AD_ID;

	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		
		System.out.println("Enter username, if you don't have press enter:");
		username = in.nextLine();
		System.out.println("Enter password, if you don't have press enter:");
		password = in.nextLine();
		if(username.equalsIgnoreCase("ayush"))
			AD_ID="AD101";
		else if(username.equalsIgnoreCase("adarsh"))
			AD_ID = "AD102";
		else
			AD_ID="NULL";
			
		char choice = '8';	
		String loop = "";
		Project obj = new Project();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(url, username, password);

		} catch (ClassNotFoundException e) {
			System.out.println("Error in loading drivers");
		} catch (SQLException e) {

			System.out.println("\nIncorrect username or password.....ACCESS DENIED.....\n\n");
			System.exit(0);
		}
		// Database access providing code
		System.out.println("");
		System.out.println("--------------------------WELCOME TO BLOOD BANK SYSTEM----------------------------");

		do {	
			if(!AD_ID.equalsIgnoreCase("NULL")){
			System.out.println(
					"\ta. View donor lists.\n\tb. View Reciepent lists\n\tc. View blood samples available.\n\td. Donate Blood\n\te. Update your entry.\n\tf. Need Blood.\n\tg. Delete entry from donors\n\th. Delete entry from Reciepent\n\t");
			
					
			System.out.println("\nSelect any option");

			choice = in.next().charAt(0);
			in.nextLine();
			}
			
			else{
			System.out.println("\n\nDO YOU WANNA HELP SOMEONE BY DONATING BLOOD?? OR DO YOU NEED BLOOD?\n\nFOR ABOVE MENTIONED, VISIT OUR NEAREST CENTRE AS EARLY AS POSSIBLE......\n\nFor other info, PRESS:\n\ta. Contact us\n\tb. Any questions ?\n\tc. Exit");
			System.out.println("\nSelect any option");

			choice = in.next().charAt(0);
			in.nextLine();
			choice = (char)((int)choice + 8);
			}
			choice = Character.toLowerCase(choice);
			switch (choice) {
			case 'a':
				System.out.println("Donars list: ");
				obj.selectDonars();
				// selectdonor
				break;
			case 'b':
				System.out.println("BloodGroup List: ");
				obj.selectReciepent();
				break;
			case 'c':
				System.out.println("BloodGroup List: ");
				obj.selectBloodGroups();
				break;
			// selectblood
			case 'd':
				obj.insert();
				break;
			// donation insertion
			case 'e':
				System.out.println("Enter the ID:");
				obj.updateDetails();
				break;
			// update
				
			case 'f':
				System.out.println();
				obj.insertRecipent();
				break;
			case 'g':
				System.out.println("Enter the ID to be deleted: ");
				obj.deleteEntry();

				break;
			// delete
			case 'h':
				System.out.println("Enter the ID to be deleted: ");
				obj.deleteEntryReciepent();
				break;
			case 'i':
				obj.selectContactUs();
				break;
			// contact us
			case 'j':
				obj.insertQuery();
				break;
			// queries
			case 'k':
				System.exit(0);
				break;
				
			default:
				System.out.println("Invalid choice");

			}
			System.out.println("\nDo you wanna continue (Y/N) ?");
			loop = in.next();
		} while (loop.equalsIgnoreCase("Y"));
	}

	private Connection connect() {
		// SQLite connection string

		Connection conn = null;
		try {
			conn = DriverManager.getConnection(url, username, password);
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return conn;
	}

	public void insert() {
		int age;
		long phone;
		String name, email, gender,BD_ID;
		String bGroup, address, date, time, Quantity;

		System.out.println("Enter ID");
		BD_ID = in.nextLine();
		
		
		System.out.println("Enter Fullname");
		name = in.nextLine();

		System.out.println("Enter Phone number");
		phone = in.nextLong();

		System.out.println("Enter Email-Id");
		email = in.next();

		System.out.println("Enter Gender");
		gender = in.next();

		System.out.println("Enter Age");
		age = in.nextInt();
		in.nextLine();

		System.out.println("Enter Blood Group");
		bGroup = in.nextLine();
		
		System.out.println("Enter Quantity");
		Quantity = in.nextLine();
		
		System.out.println("Enter Address");
		address = in.nextLine();

		
		String sql = "INSERT INTO BLOODDONARS(BD_ID,AD_ID,FULLNAME,MOBILENUMBER,EMAILID,GENDER,AGE,BG_ID,Quantity,ADDRESS) VALUES(?,?,?,?,?,?,?,?,?,?)";
		try (Connection conn = this.connect(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, BD_ID);
			pstmt.setString(2, AD_ID);
			pstmt.setString(3, name);
			pstmt.setLong(4, phone);
			pstmt.setString(5, email);
			pstmt.setString(6, gender);
			pstmt.setInt(7, age);
			pstmt.setString(8, bGroup);
			pstmt.setString(9,Quantity);
			pstmt.setString(10, address);
			// pstmt.setString(9, date + " " + time);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println("SQL: " + e.getMessage());
		}
	}

	public void insertRecipent() {
		int age;
		long phone;
		String name, email, gender,BR_ID;
		String bGroup, address, date, time, Quantity;

		System.out.println("Enter ID");
		BR_ID = in.nextLine();
		
		
		System.out.println("Enter Fullname");
		name = in.nextLine();

		System.out.println("Enter Phone number");
		phone = in.nextLong();

		System.out.println("Enter Email-Id");
		email = in.next();

		System.out.println("Enter Gender");
		gender = in.next();

		System.out.println("Enter Age");
		age = in.nextInt();
		in.nextLine();

		System.out.println("Enter Blood Group");
		bGroup = in.nextLine();
		
		System.out.println("Enter Quantity");
		Quantity = in.nextLine();
		
		System.out.println("Enter Address");
		address = in.nextLine();

		
		String sql = "INSERT INTO BLOODRECIEPENT(BR_ID,AD_ID,FULLNAME,MOBILENUMBER,EMAILID,GENDER,AGE,BG_ID,Quantity,ADDRESS) VALUES(?,?,?,?,?,?,?,?,?,?)";
		try (Connection conn = this.connect(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, BR_ID);
			pstmt.setString(2, AD_ID);
			pstmt.setString(3, name);
			pstmt.setLong(4, phone);
			pstmt.setString(5, email);
			pstmt.setString(6, gender);
			pstmt.setInt(7, age);
			pstmt.setString(8, bGroup);
			pstmt.setString(9,Quantity);
			pstmt.setString(10, address);
			// pstmt.setString(9, date + " " + time);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println("SQL: " + e.getMessage());
		}
	}

	
	public void insertQuery() {
		int ID;
		long phone;
		String name, email,message,CON_ID=AD_ID;

	/*	System.out.println("Enter ID");
		ID = in.nextInt();
		in.nextLine();
*/		
		System.out.println("Enter Fullname");
		name = in.nextLine();

		System.out.println("Enter Phone number");
		phone = in.nextLong();

		System.out.println("Enter Email-Id");
		email = in.next();
		in.nextLine();

		System.out.println("Enter your Message");
		message = in.nextLine();
		String sql = "INSERT INTO CONTACTUSQUERY(CON_ID,NAME,EMAILID,CONTACTNUMBER,MESSAGE) VALUES(?,?,?,?,?)";
		try (Connection conn = this.connect(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

	//		pstmt.setInt(1, ID);
			pstmt.setString(1, CON_ID);
			pstmt.setString(2, name);
			pstmt.setString(3, email);
			pstmt.setLong(4, phone);
			pstmt.setString(5, message);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println("SQL: " + e.getMessage());
		}
	}

	public void selectDonars() {
		String sql = "SELECT * FROM BLOODDONARS";
		String Align = " ";

		try (Connection conn = this.connect();
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql)) {
			System.out.printf("BD_ID\tAD_ID\tNAME%10s\tPHONE%5s\tEMAIL-ID%10s\tGENDER\tAGE\tBGROUP\tQuantity\tADDRESS%10s\tDATE%7sTIME\n",
					Align, Align, Align, Align, Align);
			System.out.println(
					"--------------------------------------------------------------------------------------------------------------------------------------------------------------");
			// loop through the result set
			while (rs.next()) {
				System.out.println(rs.getString("BD_ID") + "\t"+rs.getString("AD_ID")+"\t" + rs.getString("FULLNAME") + "\t" + rs.getLong("MOBILENUMBER")
						+ "\t" + rs.getString("EMAILID") + "\t" + rs.getString("GENDER") + "\t" + rs.getInt("AGE")
						+ "\t" + rs.getString("BG_ID") + "\t" + rs.getString("Quantity") +"\t" + rs.getString("ADDRESS") + "\t"
						+ rs.getString("POSTINGDATE"));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public void selectReciepent() {
		String sql = "SELECT * FROM BLOODRECIEPENT";
		String Align = " ";

		try (Connection conn = this.connect();
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql)) {
			System.out.printf("BR_ID\tAD_ID\tNAME%10s\tPHONE%5s\tEMAIL-ID%10s\tGENDER\tAGE\tBGROUP\tQuantity\tADDRESS%10s\tDATE%7sTIME\n",
					Align, Align, Align, Align, Align);
			System.out.println(
					"--------------------------------------------------------------------------------------------------------------------------------------------------------------");
			// loop through the result set
			while (rs.next()) {
				System.out.println(rs.getString("BR_ID") + "\t"+rs.getString("AD_ID")+"\t" + rs.getString("FULLNAME") + "\t" + rs.getLong("MOBILENUMBER")
						+ "\t" + rs.getString("EMAILID") + "\t" + rs.getString("GENDER") + "\t" + rs.getInt("AGE")
						+ "\t" + rs.getString("BG_ID") + "\t" + rs.getString("Quantity") +"\t" + rs.getString("ADDRESS")
						);
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public void selectContactUs() {
		String sql = "SELECT * FROM CONTACTUS";
		String Align = " ";

		try (Connection conn = this.connect();
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql)) {
			System.out.printf("CON_ID\tAD_ID\tNAME%10s\t\tEMAIL-ID%10s\tPhone\n", Align, Align, Align, Align, Align);
			System.out.println(
					"----------------------------------------------------------------------------------------------");
			// loop through the result set
			while (rs.next()) {
				System.out.println(rs.getString("CON_ID")+ "\t"+ rs.getString("AD_ID")+ "\t" + rs.getString("NAME") + "\t" + rs.getString("EMAILID")+"\t"
						+ rs.getLong("CONTACTNO"));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}

	public void selectBloodGroups() {
		String sql = "SELECT * FROM BLOODGROUPS";

		try (Connection conn = this.connect();
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql)) {
			System.out.printf("BG_ID\tBGROUP\tTOTAL\n", Align, Align, Align, Align, Align);
			System.out.println("---------------------------");
			// loop through the result set
			while (rs.next()) {
				System.out.println(
						rs.getString("BG_ID") + "\t" + rs.getString("BLOODGROUP")+"\t"+rs.getInt("Total") );
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}

	public void updateDetails() {
		
		String id = in.nextLine();
	
		String sql = "SELECT * FROM BLOODDONARS where BD_ID = " + "'"+id+"'";
		String ne = "";
		System.out.println(sql);

		String arr[] = {"ADDRESS","AD_ID", "FULLNAME", "MOBILENUMBER", "EMAILID", "GENDER", "AGE", "BG_ID", "Quantity"};
		try (Connection conn = this.connect();
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql)) {
			System.out.printf("ID\tAD_ID\tNAME%10s\tPHONE%5s\tEMAIL-ID%10s\tGENDER\tAGE\tBG_ID\tQuantity\tADDRESS%10s\tDATE%7sTIME\n",
					Align, Align, Align, Align, Align);
			System.out.println(
					"--------------------------------------------------------------------------------------------------------------------------------------------------------------");
			// loop through the result set
			while (rs.next()) {
				System.out.println(rs.getString("BD_ID") + "\t"+rs.getString("AD_ID") + "\t" + rs.getString("FULLNAME") + "\t" + rs.getLong("MOBILENUMBER")
						+ "\t" + rs.getString("EMAILID") + "\t" + rs.getString("GENDER") + "\t" + rs.getInt("AGE")
						+ "\t" + rs.getInt("BG_ID") +  "\t" + rs.getString("Quantity") +"\t" + rs.getString("ADDRESS") + "\t"
						+ rs.getString("POSTINGDATE"));
			}
			sql = "UPDATE BLOODDONARS SET ";
			int flag = 0;
			do {
				System.out.println("\nWrite the column number which you wanna update, if it's done then type \"done\"");

				ne = in.nextLine();
				if (!ne.equalsIgnoreCase("done") && !ne.equalsIgnoreCase("1")) {
					if (flag == 1)
						sql += ", ";

					System.out.print("Set " + arr[ne.charAt(0) - 49] + " as : ");

					sql += arr[ne.charAt(0) - 49] + " = '" + in.nextLine() + "' ";
					flag = 1;
				}
			} while (!ne.equalsIgnoreCase("done"));
			sql += "where BD_ID = " + "'"+id+"'";
			//System.out.println(sql);
			if(flag==1)
			stmt.executeUpdate(sql);

		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		
	}

	public void deleteEntry() {
		String id = in.nextLine();
		String sql = "DELETE FROM BLOODDONARS WHERE BD_ID = ?";

		try (Connection conn = this.connect(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			// set the corresponding param
			pstmt.setString(1, id);
			// execute the delete statement
			pstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public void deleteEntryReciepent() {
		String id = in.nextLine();
		String sql = "DELETE FROM BLOODRECIEPENT WHERE BR_ID = ?";

		try (Connection conn = this.connect(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			// set the corresponding param
			pstmt.setString(1, id);
			// execute the delete statement
			pstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
}

