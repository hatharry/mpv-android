#include <jni.h>
#include <stdlib.h>
#include <string.h>

#include <mpv/client.h>

#include "jni_utils.h"
#include "log.h"
#include "globals.h"

extern "C" {
    jni_func(jint, setOptionString, jstring option, jstring value);

    jni_func(jobject, getPropertyInt, jstring property);
    jni_func(void, setPropertyInt, jstring property, jobject value);
    jni_func(jobject, getPropertyDouble, jstring property);
    jni_func(void, setPropertyDouble, jstring property, jobject value);
    jni_func(jobject, getPropertyBoolean, jstring property);
    jni_func(void, setPropertyBoolean, jstring property, jobject value);
    jni_func(jobject, getPropertyCache, jstring property);
    jni_func(jstring, getPropertyString, jstring jproperty);
    jni_func(void, setPropertyString, jstring jproperty, jstring jvalue);

    jni_func(void, observeProperty, jstring property, jint format);
}

jni_func(jint, setOptionString, jstring joption, jstring jvalue) {
    if (!g_mpv)
        die("mpv is not initialized");

    const char *option = env->GetStringUTFChars(joption, NULL);
    const char *value = env->GetStringUTFChars(jvalue, NULL);

    int result = mpv_set_option_string(g_mpv, option, value);

    env->ReleaseStringUTFChars(joption, option);
    env->ReleaseStringUTFChars(jvalue, value);

    return result;
}

static int common_get_property(JNIEnv *env, jstring jproperty, mpv_format format, void *output) {
    if (!g_mpv)
        die("get_property called but mpv is not initialized");

    const char *prop = env->GetStringUTFChars(jproperty, NULL);
    int result = mpv_get_property(g_mpv, prop, format, output);
    if (result < 0)
        ALOGE("mpv_get_property(%s) format %d returned error %s", prop, format, mpv_error_string(result));
    env->ReleaseStringUTFChars(jproperty, prop);

    return result;
}

static int common_set_property(JNIEnv *env, jstring jproperty, mpv_format format, void *value) {
    if (!g_mpv)
        die("set_property called but mpv is not initialized");

    const char *prop = env->GetStringUTFChars(jproperty, NULL);
    int result = mpv_set_property(g_mpv, prop, format, value);
    if (result < 0)
        ALOGE("mpv_set_property(%s, %p) format %d returned error %s", prop, value, format, mpv_error_string(result));
    env->ReleaseStringUTFChars(jproperty, prop);

    return result;
}

jni_func(jobject, getPropertyInt, jstring jproperty) {
    int64_t value = 0;
    if (common_get_property(env, jproperty, MPV_FORMAT_INT64, &value) < 0)
        return NULL;
    return env->NewObject(java_Integer, java_Integer_init, (jint)value);
}

jni_func(jobject, getPropertyDouble, jstring jproperty) {
    double value = 0;
    if (common_get_property(env, jproperty, MPV_FORMAT_DOUBLE, &value) < 0)
        return NULL;
    return env->NewObject(java_Double, java_Double_init, (jdouble)value);
}

jni_func(jobject, getPropertyBoolean, jstring jproperty) {
    int value = 0;
    if (common_get_property(env, jproperty, MPV_FORMAT_FLAG, &value) < 0)
        return NULL;
    return env->NewObject(java_Boolean, java_Boolean_init, (jboolean)value);
}

jni_func(jobject, getPropertyCache, jstring jproperty) {
    mpv_node node[4];
    if (common_get_property(env, env->NewStringUTF("demuxer-cache-state"), MPV_FORMAT_NODE, &node[0]) < 0)
        return NULL;

    for (int i = 0; i < node[0].u.list->num; i++) {
        if (!strcmp(node[0].u.list->keys[i], "seekable-ranges")) {
            node[1] = node[0].u.list->values[i];
            break;
        }
    }
	if (node[1].format != MPV_FORMAT_NODE_ARRAY || node[1].u.list->num <= 0)
		return NULL;

    node[2] = node[1].u.list->values[0];
	if (node[2].format != MPV_FORMAT_NODE_MAP || node[2].u.list->num <= 0)
		return NULL;

    for (int i = 0; i < node[2].u.list->num; i++) {
        if (!strcmp(node[2].u.list->keys[i], env->GetStringUTFChars(jproperty, NULL))) {
            node[3] = node[2].u.list->values[i];
            break;
        }
    }
	if (node[3].format != MPV_FORMAT_DOUBLE)
		return NULL;

    return env->NewObject(java_Double, java_Double_init, (jdouble)node[3].u.double_);
}

jni_func(jstring, getPropertyString, jstring jproperty) {
    char *value;
    if (common_get_property(env, jproperty, MPV_FORMAT_STRING, &value) < 0)
        return NULL;
    jstring jvalue = env->NewStringUTF(value);
    mpv_free(value);
    return jvalue;
}

jni_func(void, setPropertyInt, jstring jproperty, jobject jvalue) {
    int64_t value = env->CallIntMethod(jvalue, java_Integer_intValue);
    common_set_property(env, jproperty, MPV_FORMAT_INT64, &value);
}

jni_func(void, setPropertyDouble, jstring jproperty, jobject jvalue) {
    double value = env->CallDoubleMethod(jvalue, java_Double_doubleValue);
    common_set_property(env, jproperty, MPV_FORMAT_DOUBLE, &value);
}

jni_func(void, setPropertyBoolean, jstring jproperty, jobject jvalue) {
    int value = env->CallBooleanMethod(jvalue, java_Boolean_booleanValue);
    common_set_property(env, jproperty, MPV_FORMAT_FLAG, &value);
}

jni_func(void, setPropertyString, jstring jproperty, jstring jvalue) {
    const char *value = env->GetStringUTFChars(jvalue, NULL);
    common_set_property(env, jproperty, MPV_FORMAT_STRING, &value);
    env->ReleaseStringUTFChars(jvalue, value);
}

jni_func(void, observeProperty, jstring property, jint format) {
    if (!g_mpv)
        die("mpv is not initialized");
    const char *prop = env->GetStringUTFChars(property, NULL);
    mpv_observe_property(g_mpv, 0, prop, (mpv_format)format);
    env->ReleaseStringUTFChars(property, prop);
}
