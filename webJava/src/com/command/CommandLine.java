package com.command;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class CommandLine {
    public static String ExcuteCommand(String[] args) throws IOException {
    	String lineStr = "";
    	String result = "";
        if (args == null || args.length == 0) {
            System.out.println("�����������в���(����java CommandLine 'netstat')");
        } else {
            String cmd = "";
            for (int i = 0; i < args.length; i++)
                cmd += " " + args[i];
            try {
                Runtime run = Runtime.getRuntime();
                Process p = run.exec(cmd);//������һ��������ִ������S
                BufferedInputStream in = new BufferedInputStream(p.getInputStream());
                BufferedInputStream err = new BufferedInputStream(p.getErrorStream());
                BufferedReader inBr = new BufferedReader(new InputStreamReader(in));
                BufferedReader errBr = new BufferedReader(new InputStreamReader(err));
                
                while ((lineStr = errBr.readLine()) != null)
                    result+=lineStr+'\n';
                while ((lineStr = inBr.readLine()) != null)
                	result+=lineStr;
                //��������Ƿ�ִ��ʧ�ܡ�
                try {
                    if (p.waitFor()!=0) {
                        if(p.exitValue()==1)//p.exitValue()==0��ʾ����������1������������
                        	result="����ִ��ʧ��!";
                    }
                }catch (InterruptedException e){
                    e.printStackTrace();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }
}