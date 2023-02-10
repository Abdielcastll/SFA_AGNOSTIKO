#Newland
-keep class android.newland.**  { *; }
-keep class com.newland.emv.**  { *; }
-keep class com.newland.emvl2.**  { *; }
-keep class com.newland.intelligent.**  { *; }
-keep class com.newland.sdk.me.**  { *; }
-keep class com.newland.sdk.module.**  { *; }

#Newland NSDK
-keep class com.newland.sdk.emvl3.**  { *; }
-keep class com.newland.nsdk.**  { *; }

#PAX
-keep class com.pax.dal.**  { *; }
-keep class com.pax.jemv.**  { *; }
-keep class com.pax.neptunelite.api.Nepcore  { *; }
-keep class com.pax.neptunelite.api.NeptuneLiteUser  { *; }

#Newpos
-keep class com.newpos.bypay.**  { *; }
-keepclassmembers class ** {
  public void onFinish();
  public void onSearchResult(int);
  public void onSearchResult(int,com.pos.device.magcard.MagneticCard);
  public void onSearchResult(int,int);
  public int apduExchange(byte[],int[],byte[]);
  public int candidateAppsSelection();
  public int getAmount(int[],int[]);
  public int getOfflinePin(int,com.pos.device.ped.RsaPinKey,byte[],byte[]);
  public int pinVerifyResult(int);
  public void multiLanguageSelection();
  public int getPin(int[],byte[]);
  public int checkOnlinePIN();
  public int checkCertificate();
  public int onlineTransactionProcess(byte[],byte[],int[],byte[],int[],byte[],int[],byte[]);
  public int issuerReferralProcess();
  public int adviceProcess(int);
  public int checkRevocationCertificate(int,byte[],byte[]);
  public int checkExceptionFile(int,byte[],int);
  public int getTransactionLogAmount(int,byte[],int);
  public void onChange(int);
  public void onPinBlock(int,byte[]);
  public void onResult(int,com.pos.device.printer.PrintTask);
  public void onFinish(int);
}

#Sunmi
-keep class android.os.SystemProperties  { *; }

-printusage ./proguardusage.txt
