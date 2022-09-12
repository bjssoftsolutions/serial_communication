/*
 * TransformUtils.java
 * Created by: Mahad Asghar on 18/08/2022.
 *
 *  Copyright © 2022 BjsSoftSolution. All rights reserved.
 */


package android_serialport_api.port;

import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Locale;
public class TransformUtils {

    /**
     * Hexadecimal numeric character set
     */
    private static String hexString = "0123456789ABCDEF";

    /**
     * ASCII string to hexadecimal number, for all characters (including Chinese)
     *
     * @param str
     * @return String
     */
    public static String asciiString2HexString(String str) throws UnsupportedEncodingException {

        byte[] bytes = null;
        bytes = str.getBytes("GBK");
        StringBuilder sb = new StringBuilder(bytes.length * 2);

        for (int i = 0; i < bytes.length; i++) {
            sb.append(hexString.charAt((bytes[i] & 0xf0) >> 4));
            sb.append(hexString.charAt((bytes[i] & 0x0f) >> 0));
        }
        return sb.toString();
    }

    /**
     * Decode hexadecimal digits into a string for all characters (including Chinese)
     *
     * @param bytes
     * @return String
     */
    public static String hexString2AsciiString(String bytes) throws UnsupportedEncodingException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream(bytes.length() / 2);

        for (int i = 0; i < bytes.length(); i += 2) {
            baos.write((hexString.indexOf(bytes.charAt(i)) << 4 | hexString.indexOf(bytes.charAt(i + 1))));
        }

        return new String(baos.toByteArray(), "GBK");

    }

    /**
     * Byte array to ASCII string
     *
     * @param buffer byte array
     * @param size   Length of data significant bits
     * @return ASCII
     */
    public static String byte2AsciiString(byte[] buffer, int size) {
        return new String(buffer, 0, size);
    }

    /**
     * A string to byte array
     *
     * @param str Ascii
     * @return byte array
     */
    public static byte[] AsciiString2byte(String str) {
        return str.getBytes();
    }

    /**
     * Byte array to hexadecimal string
     *
     * @param buffer byte array
     * @param size   Length of data significant bits
     * @return String
     */
    public static String bytes2HexString(byte[] buffer, int size) {
        StringBuffer sb = new StringBuffer();
        if (buffer == null || size <= 0) {
            return null;
        }
        for (int i = 0; i < size; i++) {
            String hex = Integer.toHexString(buffer[i] & 0xFF);
            if (hex.length() < 2) {
                sb.append("0");
            }
            sb.append(hex);
        }
        return sb.toString().toLowerCase(Locale.getDefault());
    }

    /**
     * An array of hexadecimal strings to bytes
     *
     * @param hex
     * @return
     */
    public static byte[] hexStringToBytes(String hex) {
        byte[] ret = new byte[hex.length() / 2];
        byte[] tmp = hex.getBytes();
        for (int i = 0; i < tmp.length / 2; i++) {
            ret[i] = uniteBytes(tmp[i * 2], tmp[i * 2 + 1]);
        }
        return ret;
    }

    /**
     * To combine two ASCII characters into one byte;Such as: "EF" -- -- > 0 xef
     *
     * @param src0 byte
     * @param src1 byte
     * @return byte
     */
    private static byte uniteBytes(byte src0, byte src1) {
        byte _b0 = Byte.decode("0x" + new String(new byte[]{src0}))
                .byteValue();
        _b0 = (byte) (_b0 << 4);
        byte _b1 = Byte.decode("0x" + new String(new byte[]{src1}))
                .byteValue();
        byte ret = (byte) (_b0 ^ _b1);
        return ret;
    }


}
