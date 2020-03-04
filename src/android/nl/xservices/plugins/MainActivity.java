package com.exchange.demoliveperson;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.AppCompatButton;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import com.liveperson.infra.InitLivePersonProperties;
import com.liveperson.infra.callbacks.InitLivePersonCallBack;
import com.liveperson.messaging.sdk.api.LivePerson;

import butterknife.BindView;

public class MainActivity extends AppCompatActivity {
    private static final String TAG = ChatActivity.class.getSimpleName();
    String BrandID = "2022139";
    String AppID = "com.exchange.demoliveperson";

    // @BindView(R.id.btn_sign_in)
    // AppCompatButton tvTitle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initLivePerson();

    }

    public void initLivePerson() {

        LivePerson.initialize(getApplicationContext(), new InitLivePersonProperties(BrandID, AppID, new InitLivePersonCallBack() {

            @Override
            public void onInitSucceed() {
                Log.i(TAG, "Liverperson SDK Initialized" + LivePerson.getSDKVersion());
            }

            @Override
            public void onInitFailed(Exception e) {
                Log.e(TAG, "Liverperson SDK Initialization Failed : " + e.getMessage());
            }
        }));
    }

    public void onClick(View view) {
        Intent intent = new Intent(this, ChatActivity.class);
        startActivity(intent);
    }
}
