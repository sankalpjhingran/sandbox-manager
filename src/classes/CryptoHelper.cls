/**
 * Created by sankalp.jhingran on 2/22/23.
 */

// TODO: Use this class to save the value for custom settings data and any secrets
public with sharing class CryptoHelper {
    public static String encrypt(String toEncrypt){
        Crypto_Secret__c setting = Crypto_Secret__c.getOrgDefaults();
        Blob cryptoKey = EncodingUtil.base64Decode(setting.Crypto_Key__c);

        Blob data = Blob.valueOf(toEncrypt);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data);
        String encryptedDataStr = EncodingUtil.base64Encode(encryptedData);

        return encryptedDataStr;
    }

    public static String decrypt(String toDecrypt){
        Blob encryptedData = EncodingUtil.base64Decode(toDecrypt);
        Crypto_Secret__c setting = Crypto_Secret__c.getOrgDefaults();
        Blob cryptoKey = EncodingUtil.base64Decode(setting.Crypto_Key__c);

        Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey, encryptedData);

        return decryptedData.toString();
    }
}