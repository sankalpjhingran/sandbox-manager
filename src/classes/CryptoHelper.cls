/**
 * Created by sankalp.jhingran on 2/22/23.
 */

// TODO: Use this class to save the value for custom settings data and any secrets
public with sharing class CryptoHelper {
    public static String encrypt(String toEncrypt){
        Blob cryptoKey = Crypto.generateAesKey(128);
        Blob data = Blob.valueOf(toEncrypt);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data);
        String encryptedDataStr = EncodingUtil.base64Encode(encryptedData);

        return encryptedDataStr;
    }

    public static String decrypt(String toDecrypt){
        Blob encryptedData = EncodingUtil.base64Decode(toDecrypt);
        Blob cryptoKey = Crypto.generateAesKey(128);
        Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey, encryptedData);

        return decryptedData.toString();
    }
}