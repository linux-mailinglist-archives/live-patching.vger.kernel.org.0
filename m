Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B133DF656
	for <lists+live-patching@lfdr.de>; Tue,  3 Aug 2021 22:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhHCUYf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 Aug 2021 16:24:35 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:38548 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhHCUYf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 Aug 2021 16:24:35 -0400
Received: by mail-pl1-f173.google.com with SMTP id e21so472127pla.5;
        Tue, 03 Aug 2021 13:24:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NmZex+6Op9y7wUYPQS8OIzRbsdWVbCNC7xgJvpuGlxw=;
        b=KDH8bfv5oMyY5AKSXIV5wGBfCqAsAaQ2RqLHc/dZMgBrPuEsjFgohvIz923USj3izT
         Uw1d46tkhdAKFDbF+u4byY4gKn6ac1QGGwJA9/Iz/mKfgaDhb+EVrgn9CCktQW9sVigN
         RJhhN+J1m7I0WSdwVtJ6jNwH6Ez8whnMnU1jJaEHJkckR3osrZ5QzyTtXVE1GQwtkVAN
         3G3djpqeXwHPquBZXStr8Y5W51foB9chT9bVqmhFUbQBCAyRHKkUquilKaXBNbNgwqQI
         NXTVqnfwd15DoT48fkMkT9IV8pd06YH1PJKsc8iFRuGKGmVH0SIqlTFQjh9YhoSLDUHA
         qB3A==
X-Gm-Message-State: AOAM533tAwgxJAxAceoYJQ7GbKkRVsPlg2+b/N/LJmh6zFoElf/+wiYh
        cawIghlCT8CxnE1i8At4TNc=
X-Google-Smtp-Source: ABdhPJw+aZZonqY3do/CGwyqdqTC3CBxnXZ8PuGvxuPOBoc9iE/lbUizj15hxKgIM8iByjeMfc0XNw==
X-Received: by 2002:aa7:9086:0:b029:39b:6377:17c1 with SMTP id i6-20020aa790860000b029039b637717c1mr24011596pfa.11.1628022262048;
        Tue, 03 Aug 2021 13:24:22 -0700 (PDT)
Received: from localhost ([191.96.121.85])
        by smtp.gmail.com with ESMTPSA id z15sm55906pfn.90.2021.08.03.13.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 13:24:21 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     lucas.demarchi@intel.com, linux-modules@vger.kernel.org
Cc:     live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        jeyu@kernel.org, osandov@fb.com, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH] libkmod-module: add support for a patient module removal option
Date:   Tue,  3 Aug 2021 13:24:17 -0700
Message-Id: <20210803202417.462197-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

When doing tests with modules such as scsi_debug, on test
frameworks such as fstests [0] you may run into situations
where false positives are triggered and a test fails but
the reality is that the test did not fail, but what did
fail was the removal of the module since the refcnt is
not yet 0, as there is a delay in between umount and the
module quiesces. This is documented on korg#21233 [1].

Although there are patches for fstests to account for
this [2] and work around it, a much suitable solution
long term is for these hacks to use a patient module
remover from modprobe directly. This patch does just
that, it adds the -p option and --remove-patiently to
modprobe which let's a removal attempt wait until the
refcnt is 0. This is useful for cases where you know the
refcnt is going to become 0, and it is just a matter of
time.

This adds a new call kmod_module_get_refcnt_wait() which
works just as kmod_module_get_refcnt() but gives you the
option to patiently wait. This then updates modprobe, rmmod
to support this feature usign the -p or --remove-patiently
argument.

[0] git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
[1] https://bugzilla.kernel.org/show_bug.cgi?id=21233
[2] https://lkml.kernel.org/r/20210727201045.2540681-1-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

Cc'ing folks who I think *might* be interested in a patient
module removal such as live-patching and blktests folks.

 libkmod/docs/libkmod-sections.txt  |  1 +
 libkmod/libkmod-module.c           | 50 ++++++++++++++++++++++++++++++
 libkmod/libkmod.h                  |  1 +
 libkmod/libkmod.sym                |  1 +
 libkmod/python/kmod/_libkmod_h.pxd |  1 +
 libkmod/python/kmod/module.pyx     |  4 +++
 man/modprobe.xml                   | 22 +++++++++++++
 man/rmmod.xml                      | 23 ++++++++++++++
 tools/modprobe.c                   | 11 +++++--
 tools/remove.c                     | 10 ++++--
 tools/rmmod.c                      |  9 ++++--
 11 files changed, 127 insertions(+), 6 deletions(-)

diff --git a/libkmod/docs/libkmod-sections.txt b/libkmod/docs/libkmod-sections.txt
index e59ab7a..311a19a 100644
--- a/libkmod/docs/libkmod-sections.txt
+++ b/libkmod/docs/libkmod-sections.txt
@@ -102,5 +102,6 @@ kmod_module_get_initstate
 kmod_module_initstate_str
 kmod_module_get_size
 kmod_module_get_refcnt
+kmod_module_get_refcnt_wait
 kmod_module_get_holders
 </SECTION>
diff --git a/libkmod/libkmod-module.c b/libkmod/libkmod-module.c
index 6e0ff1a..a609e6e 100644
--- a/libkmod/libkmod-module.c
+++ b/libkmod/libkmod-module.c
@@ -1915,6 +1915,56 @@ KMOD_EXPORT int kmod_module_get_refcnt(const struct kmod_module *mod)
 	return (int)refcnt;
 }
 
+/**
+ * kmod_module_get_refcnt_wait:
+ * @mod: kmod module
+ * @wait: if true will wait until the refcnt is 0 patiently forever
+ *
+ * Get the ref count of this @mod, as returned by Linux Kernel, by reading
+ * /sys filesystem and wait patiently until the refcnt is 0, if the wait bool
+ * argument is set to true, otherwise this behaves just as the call
+ * kmod_module_get_refcnt(). Enabling wait is useful if you know for sure that
+ * the module is quiescing soon, and so you should be able to remove it soon.
+ * If wait is enabled, we wait 1 second per iteration check on the refcnt.
+ *
+ * Returns: the reference count on success or < 0 on failure.
+ */
+KMOD_EXPORT int kmod_module_get_refcnt_wait(const struct kmod_module *mod, bool wait)
+{
+	char path[PATH_MAX];
+	long refcnt;
+	int fd, err;
+
+	if (mod == NULL)
+		return -ENOENT;
+
+	snprintf(path, sizeof(path), "/sys/module/%s/refcnt", mod->name);
+
+	while (true) {
+		fd = open(path, O_RDONLY|O_CLOEXEC);
+		if (fd < 0) {
+			err = -errno;
+			DBG(mod->ctx, "could not open '%s': %s\n",
+				path, strerror(errno));
+			return err;
+		}
+
+		err = read_str_long(fd, &refcnt, 10);
+		close(fd);
+		if (err < 0) {
+			ERR(mod->ctx, "could not read integer from '%s': '%s'\n",
+				path, strerror(-err));
+			return err;
+		}
+		if ((refcnt <= 0) || (refcnt > 0 && !wait))
+			break;
+		ERR(mod->ctx, "%s refcnt is %ld waiting for it to become 0\n", mod->name, refcnt);
+		sleep(1);
+	}
+
+	return (int)refcnt;
+}
+
 /**
  * kmod_module_get_holders:
  * @mod: kmod module
diff --git a/libkmod/libkmod.h b/libkmod/libkmod.h
index 3cab2e5..b8171d6 100644
--- a/libkmod/libkmod.h
+++ b/libkmod/libkmod.h
@@ -217,6 +217,7 @@ enum kmod_module_initstate {
 const char *kmod_module_initstate_str(enum kmod_module_initstate state);
 int kmod_module_get_initstate(const struct kmod_module *mod);
 int kmod_module_get_refcnt(const struct kmod_module *mod);
+int kmod_module_get_refcnt_wait(const struct kmod_module *mod, bool wait);
 struct kmod_list *kmod_module_get_holders(const struct kmod_module *mod);
 struct kmod_list *kmod_module_get_sections(const struct kmod_module *mod);
 const char *kmod_module_section_get_name(const struct kmod_list *entry);
diff --git a/libkmod/libkmod.sym b/libkmod/libkmod.sym
index 5f5e1fb..002d3ce 100644
--- a/libkmod/libkmod.sym
+++ b/libkmod/libkmod.sym
@@ -49,6 +49,7 @@ global:
 	kmod_module_initstate_str;
 	kmod_module_get_initstate;
 	kmod_module_get_refcnt;
+	kmod_module_get_refcnt_wait;
 	kmod_module_get_sections;
 	kmod_module_section_free_list;
 	kmod_module_section_get_name;
diff --git a/libkmod/python/kmod/_libkmod_h.pxd b/libkmod/python/kmod/_libkmod_h.pxd
index 7191953..2c744fc 100644
--- a/libkmod/python/kmod/_libkmod_h.pxd
+++ b/libkmod/python/kmod/_libkmod_h.pxd
@@ -99,6 +99,7 @@ cdef extern from 'libkmod/libkmod.h':
     # Information regarding "live information" from module's state, as
     # returned by kernel
     int kmod_module_get_refcnt(const_kmod_module_ptr mod)
+    int kmod_module_get_refcnt_wait(const_kmod_module_ptr mod, bool install)
     long kmod_module_get_size(const_kmod_module_ptr mod)
 
     # Information retrieved from ELF headers and section
diff --git a/libkmod/python/kmod/module.pyx b/libkmod/python/kmod/module.pyx
index 42aa92e..45fe774 100644
--- a/libkmod/python/kmod/module.pyx
+++ b/libkmod/python/kmod/module.pyx
@@ -72,6 +72,10 @@ cdef class Module (object):
         return _libkmod_h.kmod_module_get_refcnt(self.module)
     refcnt = property(fget=_refcnt_get)
 
+    def _refcnt_get_wait(self, wait=False):
+        return _libkmod_h.kmod_module_get_refcnt_wait(self.module, wait)
+    refcnt = property(fget=_refcnt_get_wait)
+
     def _size_get(self):
         return _libkmod_h.kmod_module_get_size(self.module)
     size = property(fget=_size_get)
diff --git a/man/modprobe.xml b/man/modprobe.xml
index 0372b6b..50730e0 100644
--- a/man/modprobe.xml
+++ b/man/modprobe.xml
@@ -388,6 +388,28 @@
           </para>
         </listitem>
       </varlistentry>
+      <varlistentry>
+        <term>
+          <option>-p</option>
+        </term>
+        <term>
+          <option>--remove-patiently</option>
+        </term>
+        <listitem>
+          <para>
+            This option causes <command>modprobe</command> to try to patiently
+            remove a module by waiting until its refcnt is 0. It checks the refcnt
+            and if its 0 it will immediately remove the module. If the refcnt is
+            not 0, it will sleep 1 second and check the refcnt again, and repeat
+            this until an error is found or the refcnt is 0. You can send a signal
+            to this command if you do not want to wait anymore.
+          </para>
+          <para>
+            Removing modules may be done by test infrastruture code, it can also
+            be done to remove a live kernel patch.
+          </para>
+        </listitem>
+      </varlistentry>
       <varlistentry>
         <term>
           <option>-S</option>
diff --git a/man/rmmod.xml b/man/rmmod.xml
index e7c7e5f..55df09d 100644
--- a/man/rmmod.xml
+++ b/man/rmmod.xml
@@ -39,6 +39,7 @@
     <cmdsynopsis>
       <command>rmmod</command>
       <arg><option>-f</option></arg>
+      <arg><option>-p</option></arg>
       <arg><option>-s</option></arg>
       <arg><option>-v</option></arg>
       <arg><replaceable>modulename</replaceable></arg>
@@ -92,6 +93,28 @@
           </para>
         </listitem>
       </varlistentry>
+      <varlistentry>
+        <term>
+          <option>-p</option>
+        </term>
+        <term>
+          <option>--remove-patiently</option>
+        </term>
+        <listitem>
+          <para>
+            This option tries to remove the module patiently by waiting
+            until the module refcnt is 0. It checks the refcnt
+            and if its 0 it will immediately remove the module. If the refcnt is
+            not 0, it will sleep 1 second and check the refcnt again, and repeat
+            this until an error is found or the refcnt is 0. You can send a signal
+            to this command if you do not want to wait anymore.
+          </para>
+          <para>
+            Removing modules may be done by test infrastruture code, it can also
+            be done to remove a live kernel patch.
+          </para>
+        </listitem>
+      </varlistentry>
       <varlistentry>
         <term>
           <option>-s</option>
diff --git a/tools/modprobe.c b/tools/modprobe.c
index 9387537..1151643 100644
--- a/tools/modprobe.c
+++ b/tools/modprobe.c
@@ -56,11 +56,13 @@ static int strip_modversion = 0;
 static int strip_vermagic = 0;
 static int remove_dependencies = 0;
 static int quiet_inuse = 0;
+static int do_remove_patient = 0;
 
-static const char cmdopts_s[] = "arRibfDcnC:d:S:sqvVh";
+static const char cmdopts_s[] = "arpRibfDcnC:d:S:sqvVh";
 static const struct option cmdopts[] = {
 	{"all", no_argument, 0, 'a'},
 	{"remove", no_argument, 0, 'r'},
+	{"remove-patiently", no_argument, 0, 'p'},
 	{"remove-dependencies", no_argument, 0, 5},
 	{"resolve-alias", no_argument, 0, 'R'},
 	{"first-time", no_argument, 0, 3},
@@ -107,6 +109,7 @@ static void help(void)
 		"\t                            be a module name to be inserted\n"
 		"\t                            or removed (-r)\n"
 		"\t-r, --remove                Remove modules instead of inserting\n"
+		"\t-p, --remove-patiently      Patiently wait until the refcnt is 0 to remove\n"
 		"\t    --remove-dependencies   Also remove modules depending on it\n"
 		"\t-R, --resolve-alias         Only lookup and print alias and exit\n"
 		"\t    --first-time            Fail if module already inserted or removed\n"
@@ -424,7 +427,7 @@ static int rmmod_do_module(struct kmod_module *mod, int flags)
 	}
 
 	if (!ignore_loaded && !cmd) {
-		int usage = kmod_module_get_refcnt(mod);
+		int usage = kmod_module_get_refcnt_wait(mod, do_remove_patient);
 
 		if (usage > 0) {
 			if (!quiet_inuse)
@@ -785,6 +788,10 @@ static int do_modprobe(int argc, char **orig_argv)
 		case 'r':
 			do_remove = 1;
 			break;
+		case 'p':
+			do_remove = 1;
+			do_remove_patient = 1;
+			break;
 		case 5:
 			remove_dependencies = 1;
 			break;
diff --git a/tools/remove.c b/tools/remove.c
index 387ef0e..313c7ed 100644
--- a/tools/remove.c
+++ b/tools/remove.c
@@ -27,9 +27,12 @@
 
 #include "kmod.h"
 
-static const char cmdopts_s[] = "h";
+static int do_remove_patient = 0;
+
+static const char cmdopts_s[] = "hp";
 static const struct option cmdopts[] = {
 	{"help", no_argument, 0, 'h'},
+	{"remove-patiently", no_argument, 0, 'p'},
 	{ }
 };
 
@@ -74,7 +77,7 @@ static int check_module_inuse(struct kmod_module *mod) {
 		return -EBUSY;
 	}
 
-	ret = kmod_module_get_refcnt(mod);
+	ret = kmod_module_get_refcnt_wait(mod, do_remove_patient);
 	if (ret > 0) {
 		ERR("Module %s is in use\n", kmod_module_get_name(mod));
 		return -EBUSY;
@@ -101,6 +104,9 @@ static int do_remove(int argc, char *argv[])
 		case 'h':
 			help();
 			return EXIT_SUCCESS;
+		case 'p':
+			do_remove_patient = 1;
+			break;
 
 		default:
 			ERR("Unexpected getopt_long() value '%c'.\n", c);
diff --git a/tools/rmmod.c b/tools/rmmod.c
index 3942e7b..16ce642 100644
--- a/tools/rmmod.c
+++ b/tools/rmmod.c
@@ -35,10 +35,12 @@
 #define DEFAULT_VERBOSE LOG_ERR
 static int verbose = DEFAULT_VERBOSE;
 static int use_syslog;
+static int do_remove_patient;
 
-static const char cmdopts_s[] = "fsvVwh";
+static const char cmdopts_s[] = "fpsvVwh";
 static const struct option cmdopts[] = {
 	{"force", no_argument, 0, 'f'},
+	{"remove-patiently", no_argument, 0, 'p'},
 	{"syslog", no_argument, 0, 's'},
 	{"verbose", no_argument, 0, 'v'},
 	{"version", no_argument, 0, 'V'},
@@ -93,7 +95,7 @@ static int check_module_inuse(struct kmod_module *mod) {
 		return -EBUSY;
 	}
 
-	ret = kmod_module_get_refcnt(mod);
+	ret = kmod_module_get_refcnt_wait(mod, do_remove_patient);
 	if (ret > 0) {
 		ERR("Module %s is in use\n", kmod_module_get_name(mod));
 		return -EBUSY;
@@ -120,6 +122,9 @@ static int do_rmmod(int argc, char *argv[])
 		case 'f':
 			flags |= KMOD_REMOVE_FORCE;
 			break;
+		case 'p':
+			do_remove_patient = 1;
+			break;
 		case 's':
 			use_syslog = 1;
 			break;
-- 
2.30.2

