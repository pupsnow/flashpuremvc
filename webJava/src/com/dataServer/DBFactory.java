package com.dataServer;

import java.sql.*;//做数据库时候必须要引入的包 

public class DBFactory
	{
		Connection Conn = null;
		PreparedStatement Stmt = null;
		ResultSet Rs = null;
		String driverName = "com.microsoft.jdbc.sqlserver.SQLServerDriver";
		String OracleUserName = "sa";
		String OracleUserPwd = "111111";
		String ConnUrl = "jdbc:sqlserver://localhost:1433;databaseName=news";

		public Connection getConnection()
			{
				try
					{
						Class.forName(driverName);
					} catch (ClassNotFoundException ex)
					{
						System.out.println("加载驱动程序有错误");
					}
				try
					{
						Conn = DriverManager.getConnection(ConnUrl,
								OracleUserName, OracleUserPwd);
					} catch (SQLException ex1)
					{
						System.out.print("取得连接的时候有错误，请核对用户名和密码");
					}

				return Conn;
			}
	}
