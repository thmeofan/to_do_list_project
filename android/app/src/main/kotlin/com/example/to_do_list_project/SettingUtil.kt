package com.example.to_do_list_project

import android.content.Context
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi

@RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
fun isTimeAutomatic(context: Context): Boolean {
    return Settings.Global.getInt(
        context.contentResolver,
        Settings.Global.AUTO_TIME,
        0
    ) == 1;
}