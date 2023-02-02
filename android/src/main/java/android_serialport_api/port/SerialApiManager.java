/*
 * SerialApiManager.java
 * Created by: Mahad Asghar on 18/08/2022.
 *
 *  Copyright © 2022 BjsSoftSolution. All rights reserved.
 */



package android_serialport_api.port;
import android.util.Log;

import androidx.annotation.StringDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;



public class SerialApiManager {

    private final String TAG = "ADan_SerialPortManager";
    private static SerialApiManager instance;
    private HashMap serialPorts;
    private LogInterceptorSerialPort logInterceptor;



    public static final String port = "port";
    public static final String read = "read";
    public static final String write = "write";
    public static final String append = "append";

    @Retention(RetentionPolicy.SOURCE)
    @StringDef({port, read, write, append})
    public @interface Type {
    }

    private SerialApiManager() {
        serialPorts = new HashMap();
    }

    public static SerialApiManager getInstances() {
        if (instance == null) {
            synchronized (SerialApiManager.class) {
                if (instance == null) {
                    instance = new SerialApiManager();
                }
            }
        }
        return instance;
    }

    public SerialApiManager setLogInterceptor(LogInterceptorSerialPort logInterceptor) {
        this.logInterceptor = logInterceptor;
        Iterator iter = serialPorts.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();
            SerialApi serialPort = (SerialApi) entry.getValue();
            serialPort.setLogInterceptor(logInterceptor);
        }
        return this;
    }

    /**
     *
     * @param port    Serial Number
     * @param isAscii coded format true:ascii false HexString
     * @param reader  Read data monitor
     */
    public boolean startSerialPort(String port, boolean isAscii, BaseReader reader,int baudRate) {
        return startSerialPort(port, isAscii, baudRate, 0, reader);
    }

    /**
     *
     * @param port      Serial Number
     * @param baudRate Baud rate
     * @param flags    sign
     * @param reader   Read data monitor
     */
    public boolean startSerialPort(String port, boolean isAscii, int baudRate, int flags, BaseReader reader) {
        SerialApi serial;
        if (serialPorts.containsKey(port)) {
            serial = (SerialApi) serialPorts.get(port);
        } else {
            Log.d("SerialPort",port);
            serial = new SerialApi(port, isAscii, baudRate, flags);
            serialPorts.put(port, serial);
        }
        serial.setLogInterceptor(logInterceptor);
        return serial.open(reader);
    }

    /**
     * @param port
     * @param reader
     */
    public void setReader(String port, BaseReader reader) {
        if (serialPorts.containsKey(port)) {
            SerialApi serial = (SerialApi) serialPorts.get(port);
            serial.setReader(reader);
        }
    }

    public void setReadCode(String port, boolean isAscii) {
        if (serialPorts.containsKey(port)) {
            SerialApi serial = (SerialApi) serialPorts.get(port);
            serial.setReadCode(isAscii);
        }
    }

    public void send(String port, String cmd) {
        if (serialPorts.containsKey(port)) {
            SerialApi serial = (SerialApi) serialPorts.get(port);
            serial.write(cmd);
        }
    }

    public void send(String port, boolean isAscii, String cmd) {
        if (serialPorts.containsKey(port)) {
            SerialApi serial = (SerialApi) serialPorts.get(port);
            serial.write(isAscii, cmd);
        }
    }

    /**
     * Close a serial port
     *
     * @param port
     */
    public void stopSerialPort(String port) {
        if (serialPorts.containsKey(port)) {
            SerialApi serial = (SerialApi) serialPorts.get(port);
            serial.close();
            serialPorts.remove(serial);
            System.gc();
        }
    }

    /**
     * Has it been turned on
     *
     * @param port
     * @return
     */
    public boolean isStart(String port) {
        if (serialPorts.containsKey(port)) {
            SerialApi serial = (SerialApi) serialPorts.get(port);
            return serial.isOpen();
        }
        return false;
    }

    /**
     * Destruction of resources
     */
    public void destroy() {
        Log.e(TAG, "SerialPort destroyed");
        try {
            Iterator iter = serialPorts.entrySet().iterator();
            while (iter.hasNext()) {
                Map.Entry entry = (Map.Entry) iter.next();
                SerialApi serial = (SerialApi) entry.getValue();
                serial.close();
                serialPorts.remove(serial);
            }
            System.gc();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
