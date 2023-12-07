/*
 * SerialApi.java
 * Created by: Mahad Asghar on 18/08/2022.
 *
 *  Copyright © 2022 BjsSoftSolution. All rights reserved.
 */


package android_serialport_api.port;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

class SerialApi {

    private android_serialport_api.SerialPort serialPort;
    private InputStream inputStream;
    private OutputStream outputStream;
    private ReadThread readThread;
    private String port;
    private boolean open;
    private boolean isAscii;
    private int baudRate;
    private int flags;
    private LogInterceptorSerialPort logInterceptor;

    public SerialApi(String port, boolean isAscii, int baudRate, int flags) {
        this.port = port;
        this.isAscii = isAscii;
        this.baudRate = baudRate;
        this.flags = flags;
    }

    public void setLogInterceptor(LogInterceptorSerialPort logInterceptor) {
        this.logInterceptor = logInterceptor;
    }

    private void log(@SerialApiManager.Type String type, String port, boolean isAscii, CharSequence log) {
        log(type, port, isAscii, log == null ? "null" : log.toString());
    }

    private void log(@SerialApiManager.Type String type, String port, boolean isAscii, String log) {
        if (logInterceptor != null) {
            logInterceptor.log(type, port, isAscii, log);
        }
    }

    /**
     * Start the serial port with the default baud rate of 9600
     *
     * @param reader
     */
    public boolean open(BaseReader reader) {
        log(SerialApiManager.port, port, isAscii,
                new StringBuffer().append("Baud rate：")
                        .append(baudRate).append(" flag bit ：").append(flags)
                        .append(" Start the serial port"));
        if (open) {
            log(SerialApiManager.port, port, isAscii, new StringBuffer().append("Boot failure: Serial port started"));
            return open;
        }
        try {
            serialPort = new android_serialport_api.SerialPort(new File(port), baudRate, 0);
            if (serialPort == null) {

                log(SerialApiManager.port, port, isAscii, new StringBuffer().append("Boot failure：SerialPort == null"));
            } else {
                inputStream = serialPort.getInputStream();
                if (inputStream == null) {
                    throw new Exception("inputStream==null");
                }
                outputStream = serialPort.getOutputStream();
                if (outputStream == null) {
                    throw new Exception("outputStream==null");
                }
                readThread = new ReadThread(isAscii, reader);
                readThread.start();
                open = true;
                log(SerialApiManager.port, port, isAscii, new StringBuffer().append("starting success"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            log(SerialApiManager.port, port, isAscii, new StringBuffer().append("dead start：").append(e));
            open = false;
        }
        return open;
    }

    public boolean isOpen() {
        return open;
    }

    public void setReadCode(boolean isAscii) {
        if (readThread != null) {
            readThread.isAscii = isAscii;
            log(SerialApiManager.port, port, readThread.isAscii, new StringBuffer().append("Modify data format：").append(isAscii ? "ASCII" : "HexString"));
        }
    }

    public void setReader(BaseReader reader) {
        if (readThread != null) {
            readThread.setReader(reader);
        }
    }

    class ReadThread extends Thread {

        public boolean isRun;
        public boolean isAscii;
        private BaseReader reader;

        public ReadThread(boolean isAscii, BaseReader baseReader) {
            reader = baseReader;
            this.isAscii = isAscii;
            if (reader != null) {
                reader.setLogInterceptor(logInterceptor);
            }
        }

        @Override
        public void run() {
            if (inputStream == null) {
                return;
            }
            isRun = true;
            while (isRun && !isInterrupted()) {
                try {
                    if (inputStream.available() > 0) {

                        int size;
                        byte[] buffer = new byte[512];
                        /**
                         * When no data is read, the method waits until the data is read
                         * In IO blocking state, the thread can not interrupt, even if the interrupt, there is data coming, the program will execute to the interrupt flag
                         */
                        size = inputStream.read(buffer);
                        if (!isRun) {
                            break;
                        }
                        if (reader != null) {
                            if (size > 0) {
                                reader.onBaseRead(port, isAscii, buffer, size);
                            }
                        }
                    }
                    Thread.sleep(50);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            log(SerialApiManager.port, port, isAscii, "The thread terminated successfully to release the resource");
        }

        public void stopRead() {
            isRun = false;
        }

        public void setReader(BaseReader baseReader) {
            reader = baseReader;
            if (reader != null) {
                reader.setLogInterceptor(logInterceptor);
            }
        }
    }

    public void write(String cmd) {
        write(isAscii, cmd);
    }

    public void write(boolean isAscii, String cmd) {
        log(SerialApiManager.write, port, isAscii, new StringBuffer().append(cmd));
        if (outputStream != null) {
            synchronized (outputStream) {
                byte[] bytes;
                try {
                    if (isAscii) {
                        bytes = cmd.getBytes();
                    } else {
                        bytes = TransformUtils.hexStringToBytes(cmd);
                    }
                    outputStream.write(bytes);
                } catch (Exception e) {
                    log(SerialApiManager.write, port, isAscii, new StringBuffer().append("Write a failure:").append(e));
                }
            }
            log(SerialApiManager.write, port, isAscii, new StringBuffer().append("Write a successful：").append(cmd));
        } else {
            log(SerialApiManager.write, port, isAscii, new StringBuffer().append("Write a failure：outputStream is null"));
        }
    }

    public void close() {
        try {
            open = false;
            if (readThread != null) {
                readThread.stopRead();
                log(SerialApiManager.port, port, readThread.isAscii, "The serial port closed successfully");
            } else {
                log(SerialApiManager.port, port, false, "Serial port closure failed: the serial port is not open");
            }

            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (serialPort != null) {
                serialPort.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
