package com.test;

public class Test {   
	  
    /**  
     * @param args  
     */  
    public static void main(String[] args) {   
        //Send to C#   
        byte[] a = Int2BytesLH(129);   
           
        //模拟Recv from C#   
        byte[] b = new byte[]{32,3,0,0};   
        int c = Bytes2Int(BytestoHL(b));   
           
        //Send to JAVA   
        byte[] a1 = Int2Bytes(800);   
           
           
        //模拟Recv from JAVA   
        byte[] b1 = new byte[]{0,0,3,32};   
        int c1 = Bytes2Int(b1);   
           
           
    }   
  
       
  
    /**  
     * 将一个Int 数据，转换为byte数组.  
     * JAVA直接使用  
     * @param intValue Int 数据  
     * @return byte数组.  
     */  
    public static byte[] Int2Bytes(int intValue) {   
    	
     byte [] result = new byte[4];   
     result[0] = (byte) ((intValue & 0xFF000000) >> 24);   
     result[1] = (byte) ((intValue & 0x00FF0000) >> 16);   
     result[2] = (byte) ((intValue & 0x0000FF00) >> 8);   
//     result[3] = Integer.toHexString(intValue);;
     //((intValue & 0x000000FF) );   
     return result;   
    }   
  
    /**  
     * 将int转为低字节在前，高字节在后的byte数组  
     * 转为C#需要的的数组顺序  
     *   
     */  
    private static byte[] Int2BytesLH(int n) {   
        byte[] b = new byte[4];   
        b[0] = (byte) (n & 0xff);   
        b[1] = (byte) (n >> 8 & 0xff);   
        b[2] = (byte) (n >> 16 & 0xff);   
        b[3] = (byte) (n >> 24 & 0xff);   
        return b;   
    }   
  
    /**  
     * 将byte[]转为低字节在前，高字节在后的byte数组  
     * 从C#收包后转换为JAVA的数组顺序  
     */  
    private static byte[] BytestoHL(byte[] n) {   
        byte[] b = new byte[4];   
        b[3] = n[0];   
        b[2] = n[1];   
        b[1] = n[2];   
        b[0] = n[3];   
        return b;   
    }   
  
    /**  
     * 将byte数组的数据，转换成Int值.  
     * JAVA直接使用  
     * @param byteVal byte数组  
     * @return Int值.  
     */  
    public static int Bytes2Int(byte[] byteVal) {   
     int result = 0;   
     for(int i = 0; i < byteVal.length; i ++) {   
      int tmpVal = (byteVal[i] << (8 * (3-i)));   
      switch (i) {   
       case 0:   
        tmpVal = tmpVal & 0xFF000000;   
        break;   
       case 1:   
        tmpVal = tmpVal & 0x00FF0000;   
        break;   
       case 2:   
        tmpVal = tmpVal & 0x0000FF00;   
        break;   
       case 3:   
        tmpVal = tmpVal & 0x000000FF;   
        break;   
      }   
      result = result | tmpVal;   
     }   
     return result;   
    }   
  
}  
