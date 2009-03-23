package com.xml;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.xml.sax.InputSource;

public class XmlRead
	{
		public ArrayList<Map<String, String>> xmlElements(String xmlDoc)
			{
				// 创建一个新的字符串
				StringReader read = new StringReader(xmlDoc);
				// 创建新的输入源SAX 解析器将使用 InputSource 对象来确定如何读取 XML 输入
				InputSource source = new InputSource(read);
				// 创建一个新的SAXBuilder
				SAXBuilder sb = new SAXBuilder();
				// 创建一个object
				ArrayList<Map<String, String>> noticeList = new ArrayList<Map<String, String>>();
				try
					{
						// 通过输入源构造一个Document
						Document doc = sb.build(source);
						// 取的根元素
						Element root = doc.getRootElement();
						System.out.println(root.getName());// 输出根元素的名称（测试）
						// 得到根元素所有子元素的集合
						List jiedian = root.getChildren();
						// 获得XML中的命名空间（XML中未定义可不写）
						// Namespace ns = root.getNamespace();
						Element et = null;
						for (int i = 0; i < jiedian.size(); i++)
							{
								Map<String, String> datasource = new HashMap<String, String>();
								et = (Element) jiedian.get(i);// 循环依次得到子元素

								datasource.put("ColumnName", et
										.getAttributeValue("ColumnName"));
								datasource.put("Value", et
										.getAttributeValue("Value"));
								datasource.put("DataType", et
										.getAttributeValue("DataType"));
								datasource.put("Operator", et
										.getAttributeValue("Operator"));
								noticeList.add(datasource);
								/**//*
									 * 无命名空间定义时
									 * et.getChild("users_id").getText();
									 * et.getChild("users_address",ns).getText()
									 */
								// System.out.println(et.getChild("users_id",ns).getText());
								// 有命名空间 时用
								// System.out.println(et.getChild("users_address",ns).getText());
							}
						/**//*
							 * 如要取<row>下的子元素的名称
							 */
						/*
						 * et = (Element) jiedian.get(0); List zjiedian =
						 * et.getChildren(); for (int j = 0; j <
						 * zjiedian.size(); j++) { Element xet = (Element)
						 * zjiedian.get(j); System.out.println(xet.getName()); }
						 */
					}
				catch (JDOMException e)
					{
						// TODO 自动生成 catch 块
						e.printStackTrace();
					}
				catch (IOException e)
					{
						// TODO 自动生成 catch 块
						e.printStackTrace();
					}
				return noticeList;
			}

		
	}
