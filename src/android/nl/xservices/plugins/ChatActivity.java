package com.exchange.demoliveperson;

import android.app.Notification;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.INotificationSideChannel;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import androidx.fragment.app.FragmentTransaction;
import androidx.appcompat.app.AppCompatActivity;

import com.liveperson.infra.ConversationViewParams;
import com.liveperson.infra.ICallback;
import com.liveperson.infra.InitLivePersonProperties;
import com.liveperson.infra.LPAuthenticationParams;
import com.liveperson.infra.callbacks.InitLivePersonCallBack;
import com.liveperson.infra.messaging_ui.fragment.ConversationFragment;
import com.liveperson.messaging.sdk.api.LivePerson;
import com.liveperson.messaging.sdk.api.model.ConsumerProfile;
import com.exchange.demoliveperson.R;


/**
 * Created by nishant.singh on 20-03-2018.
 * Used as a LivePerson Fragment container.
 */

public class ChatActivity extends AppCompatActivity {
    private static final String TAG = ChatActivity.class.getSimpleName();
    private static final String LIVEPERSON_FRAGMENT = "liveperson_fragment";
    private ConversationFragment mConversationFragment;
    private Menu mMenu;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_custom);
        setTitle("Chat");

    }

    @Override
    protected void onStart(){
        super.onStart();
        initFragment();
        setUserProfile();
    }


    private void setUserProfile() {
            ConsumerProfile consumerProfile = new ConsumerProfile.Builder()
                    .setFirstName("han")
                    .setLastName("nguyen")
                    .setPhoneNumber("123456789" + "|" + "hanit0693@gmail.com")
                    .build();
            LivePerson.setUserProfile(consumerProfile);
    }



    @Override
    protected void onDestroy() {
        super.onDestroy();
    }


    private void initFragment() {
        mConversationFragment = (ConversationFragment) getSupportFragmentManager().findFragmentByTag(LIVEPERSON_FRAGMENT);
        Log.d(TAG, "initFragment. mConversationFragment = " + mConversationFragment);
        if (mConversationFragment == null) {
//            String authCode = SampleAppStorage.getInstance(ChatActivity.this).getAuthCode();
//            String publicKey = SampleAppStorage.getInstance(ChatActivity.this).getPublicKey();
            String authCode = "";
            String publicKey = "";

            Log.d(TAG, "initFragment. authCode = " + authCode);
            Log.d(TAG, "initFragment. publicKey = " + publicKey);
            LPAuthenticationParams authParams = new LPAuthenticationParams();
            authParams.setAuthKey(authCode);
            authParams.addCertificatePinningKey(publicKey);
            mConversationFragment = (ConversationFragment) LivePerson.getConversationFragment(authParams, new ConversationViewParams(false));

            if (isValidState()) {

                // Pending intent for image foreground service
                Intent notificationIntent = new Intent(this, ChatActivity.class);
                notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);
                LivePerson.setImageServicePendingIntent(pendingIntent);

                // Notification builder for image upload foreground service
                Notification.Builder uploadBuilder = new Notification.Builder(this.getApplicationContext());
                Notification.Builder downloadBuilder = new Notification.Builder(this.getApplicationContext());
                uploadBuilder.setContentTitle("Uploading image")
                        .setSmallIcon(android.R.drawable.arrow_up_float)
                        .setContentIntent(pendingIntent)
                        .setProgress(0, 0, true);

                downloadBuilder.setContentTitle("Downloading image")
                        .setSmallIcon(android.R.drawable.arrow_down_float)
                        .setContentIntent(pendingIntent)
                        .setProgress(0, 0, true);

                LivePerson.setImageServiceUploadNotificationBuilder(uploadBuilder);
                LivePerson.setImageServiceDownloadNotificationBuilder(downloadBuilder);


                FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
                ft.add(R.id.custom_fragment_container, mConversationFragment, LIVEPERSON_FRAGMENT).commitAllowingStateLoss();
            }
        } else {
            attachFragment();
        }
    }


    private boolean isValidState() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            return !isFinishing() && !isDestroyed();
        } else {
            return !isFinishing();
        }
    }

    private void attachFragment() {
        if (mConversationFragment.isDetached()) {
            Log.d(TAG, "initFragment. attaching fragment");
            if (isValidState()) {
                FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
                ft.attach(mConversationFragment).commitAllowingStateLoss();
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mConversationFragment != null) {
            attachFragment();
        }
    }


    @Override
    public void onBackPressed() {
        if (mConversationFragment == null || !mConversationFragment.onBackPressed()) {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        mMenu = menu;
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        return super.onOptionsItemSelected(item);
    }


    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        return true;
    }
}
