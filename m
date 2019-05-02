Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98EEF111A7
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 04:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfEBCkT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 May 2019 22:40:19 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:35797 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726387AbfEBCj7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 May 2019 22:39:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 8A12F661;
        Wed,  1 May 2019 22:32:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 01 May 2019 22:32:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=mJppJN/yvnZhTI/+iVBtiobnBONgEpn2WiqOjq41o6U=; b=ZvMqQtsI
        viW8LB+LC/s/b2wMQI+Zjz8vBgJ9Frcj8oQV342JWI6hngdMcl0db+9av8UPW4LJ
        M3zpICrs5ORRiTWXrU+NFE0bKbA63NzuBwazdAOzLnxs0ixfbt0CTttatdKq3Jyv
        60qMf9r7FTe7sVXlor2BJNb09sj3py0NFIERXnhr8HUwDwGOR/r0UV7GSb8THMXJ
        1ivRt641wkQ1ACBQCib3fJO0AgoHvfMgU5xhRVBvzKzQewjVofcgbibCWB3BcFFL
        BIFkdC0Fu1AxuAo3yAC6tH0BamH4rssqB642Tye6XZ4W3I42oQzufDYlPyF3DYmg
        DwZvSdJVe2F1gQ==
X-ME-Sender: <xms:ylbKXEsPo7zpXypHa8MisRZPPsJ0Wl4XhZdX0SZoUp1eyUw2txUWnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieekgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:y1bKXFvac5Xgn1_3qpPZuAOj31LWaz2xyLnfS58YwufYLueXbbxrzw>
    <xmx:y1bKXKynELBO5psyNEVhmZ8iHuzBbIQlqTNqrIBdF-n4dt2rdnxy9Q>
    <xmx:y1bKXLj1Sre8b1LS7xQTNhQL7TYhgaDGeyU70xMCKAc7pTnar2ITEQ>
    <xmx:y1bKXPo_6bXv6yJNkiIim7P2YsGbAWIeErcjtWjD9NZhXWRv3-zr_Q>
Received: from eros.localdomain (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1F29FE4176;
        Wed,  1 May 2019 22:32:38 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/5] kobject: Fix kernel-doc comment first line
Date:   Thu,  2 May 2019 12:31:40 +1000
Message-Id: <20190502023142.20139-4-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502023142.20139-1-tobin@kernel.org>
References: <20190502023142.20139-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

kernel-doc comments have a prescribed format.  This includes parenthesis
on the function name.  To be _particularly_ correct we should also
capitalise the brief description and terminate it with a period.

In preparation for adding/updating kernel-doc function comments clean up
the ones currently present.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 lib/kobject.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 3eacd5b4643f..0181f102cd1c 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -18,7 +18,7 @@
 #include <linux/random.h>
 
 /**
- * kobject_namespace - return @kobj's namespace tag
+ * kobject_namespace() - Return @kobj's namespace tag.
  * @kobj: kobject in question
  *
  * Returns namespace tag of @kobj if its parent has namespace ops enabled
@@ -36,7 +36,7 @@ const void *kobject_namespace(struct kobject *kobj)
 }
 
 /**
- * kobject_get_ownership - get sysfs ownership data for @kobj
+ * kobject_get_ownership() - Get sysfs ownership data for @kobj.
  * @kobj: kobject in question
  * @uid: kernel user ID for sysfs objects
  * @gid: kernel group ID for sysfs objects
@@ -264,7 +264,7 @@ static int kobject_add_internal(struct kobject *kobj)
 }
 
 /**
- * kobject_set_name_vargs - Set the name of an kobject
+ * kobject_set_name_vargs() - Set the name of a kobject.
  * @kobj: struct kobject to set the name of
  * @fmt: format string used to build the name
  * @vargs: vargs to format the string.
@@ -304,7 +304,7 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 }
 
 /**
- * kobject_set_name - Set the name of a kobject
+ * kobject_set_name() - Set the name of a kobject.
  * @kobj: struct kobject to set the name of
  * @fmt: format string used to build the name
  *
@@ -326,7 +326,7 @@ int kobject_set_name(struct kobject *kobj, const char *fmt, ...)
 EXPORT_SYMBOL(kobject_set_name);
 
 /**
- * kobject_init - initialize a kobject structure
+ * kobject_init() - Initialize a kobject structure.
  * @kobj: pointer to the kobject to initialize
  * @ktype: pointer to the ktype for this kobject.
  *
@@ -382,7 +382,7 @@ static __printf(3, 0) int kobject_add_varg(struct kobject *kobj,
 }
 
 /**
- * kobject_add - the main kobject add function
+ * kobject_add() - The main kobject add function.
  * @kobj: the kobject to add
  * @parent: pointer to the parent of the kobject.
  * @fmt: format to name the kobject with.
@@ -430,7 +430,8 @@ int kobject_add(struct kobject *kobj, struct kobject *parent,
 EXPORT_SYMBOL(kobject_add);
 
 /**
- * kobject_init_and_add - initialize a kobject structure and add it to the kobject hierarchy
+ * kobject_init_and_add() - Initialize a kobject structure and add it to
+ *                          the kobject hierarchy.
  * @kobj: pointer to the kobject to initialize
  * @ktype: pointer to the ktype for this kobject.
  * @parent: pointer to the parent of this kobject.
@@ -457,7 +458,7 @@ int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
 EXPORT_SYMBOL_GPL(kobject_init_and_add);
 
 /**
- * kobject_rename - change the name of an object
+ * kobject_rename() - Change the name of an object.
  * @kobj: object in question.
  * @new_name: object's new name
  *
@@ -524,7 +525,7 @@ int kobject_rename(struct kobject *kobj, const char *new_name)
 EXPORT_SYMBOL_GPL(kobject_rename);
 
 /**
- * kobject_move - move object to another parent
+ * kobject_move() - Move object to another parent.
  * @kobj: object in question.
  * @new_parent: object's new parent (can be NULL)
  */
@@ -577,7 +578,7 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
 EXPORT_SYMBOL_GPL(kobject_move);
 
 /**
- * kobject_del - unlink kobject from hierarchy.
+ * kobject_del() - Unlink kobject from hierarchy.
  * @kobj: object.
  */
 void kobject_del(struct kobject *kobj)
@@ -599,7 +600,7 @@ void kobject_del(struct kobject *kobj)
 EXPORT_SYMBOL(kobject_del);
 
 /**
- * kobject_get - increment refcount for object.
+ * kobject_get() - Increment refcount for object.
  * @kobj: object.
  */
 struct kobject *kobject_get(struct kobject *kobj)
@@ -692,7 +693,7 @@ static void kobject_release(struct kref *kref)
 }
 
 /**
- * kobject_put - decrement refcount for object.
+ * kobject_put() - Decrement refcount for object.
  * @kobj: object.
  *
  * Decrement the refcount, and if 0, call kobject_cleanup().
@@ -721,7 +722,7 @@ static struct kobj_type dynamic_kobj_ktype = {
 };
 
 /**
- * kobject_create - create a struct kobject dynamically
+ * kobject_create() - Create a struct kobject dynamically.
  *
  * This function creates a kobject structure dynamically and sets it up
  * to be a "dynamic" kobject with a default release function set up.
@@ -744,8 +745,8 @@ struct kobject *kobject_create(void)
 }
 
 /**
- * kobject_create_and_add - create a struct kobject dynamically and register it with sysfs
- *
+ * kobject_create_and_add() - Create a struct kobject dynamically and
+ *                            register it with sysfs.
  * @name: the name for the kobject
  * @parent: the parent kobject of this kobject, if any.
  *
@@ -776,7 +777,7 @@ struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
 EXPORT_SYMBOL_GPL(kobject_create_and_add);
 
 /**
- * kset_init - initialize a kset for use
+ * kset_init() - Initialize a kset for use.
  * @k: kset
  */
 void kset_init(struct kset *k)
@@ -818,7 +819,7 @@ const struct sysfs_ops kobj_sysfs_ops = {
 EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
 
 /**
- * kset_register - initialize and add a kset.
+ * kset_register() - Initialize and add a kset.
  * @k: kset.
  */
 int kset_register(struct kset *k)
@@ -838,7 +839,7 @@ int kset_register(struct kset *k)
 EXPORT_SYMBOL(kset_register);
 
 /**
- * kset_unregister - remove a kset.
+ * kset_unregister() - Remove a kset.
  * @k: kset.
  */
 void kset_unregister(struct kset *k)
@@ -851,7 +852,7 @@ void kset_unregister(struct kset *k)
 EXPORT_SYMBOL(kset_unregister);
 
 /**
- * kset_find_obj - search for object in kset.
+ * kset_find_obj() - Search for object in kset.
  * @kset: kset we're looking in.
  * @name: object's name.
  *
@@ -899,7 +900,7 @@ static struct kobj_type kset_ktype = {
 };
 
 /**
- * kset_create - create a struct kset dynamically
+ * kset_create() - Create a struct kset dynamically.
  *
  * @name: the name for the kset
  * @uevent_ops: a struct kset_uevent_ops for the kset
@@ -943,7 +944,7 @@ static struct kset *kset_create(const char *name,
 }
 
 /**
- * kset_create_and_add - create a struct kset dynamically and add it to sysfs
+ * kset_create_and_add() - Create a struct kset dynamically and add it to sysfs.
  *
  * @name: the name for the kset
  * @uevent_ops: a struct kset_uevent_ops for the kset
-- 
2.21.0

