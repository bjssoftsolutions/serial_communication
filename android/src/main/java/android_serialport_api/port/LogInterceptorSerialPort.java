/*
 * LogInterceptorSerialPort.java
 * Created by: Mahad Asghar on 18/08/2022.
 *
 *  Copyright © 2022 BjsSoftSolution. All rights reserved.
 */


package android_serialport_api.port;

/**
 *
 * Serial port log interceptor
 */

public interface LogInterceptorSerialPort {

    /**
     * Operation log output callback
     *
     * @param type    Log type
     * @param port    serial port
     * @param isAscii true:ASCII  false:Hex
     * @param log     Log contents
     */
    void log(@SerialApiManager.Type String type, String port, boolean isAscii, String log);

}
