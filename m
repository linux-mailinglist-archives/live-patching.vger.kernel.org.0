Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC70A111A0
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 04:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfEBCkA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 May 2019 22:40:00 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:53521 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726394AbfEBCj7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 May 2019 22:39:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id DDA98665;
        Wed,  1 May 2019 22:32:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 01 May 2019 22:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=FagCvmI1U0HfabmZwTDJmNDrGd+04zAITdsAF93zdAs=; b=Vonorg/p
        FFsWZgK9AwNtue/HI9/nQ4s1QMKx0WGllSeulZZkhLnwnm9xPZ8E2SYNO7/i01j2
        N/rlBDdiul6CehOrF5U3y6LpDLb3MQjg5ogPvXC1aZ65QXfjz+Dh24EMGhmWLXEL
        LFsQya0tuQ5wyvo1IKFb7pkOJ3fQYlh9PnQpNJPGIs9hAIT302T+f4cy4mnLD9rT
        dbFwBPJMdb7og7Dq73i4aLe4hglF47ALThcrCRUi5GsUJ+cJasnfkwzg5Cwe0Rrf
        gSPzby2aaczb/YDJvIo2nXwyrky0gGDkXVNM35V8v/LQlfhPPmvIYIo3g0fYNa3R
        5lCvAccVLPRMdw==
X-ME-Sender: <xms:zlbKXKdBgVG9cDFuScsjMooNPWGL9hQwrqHx_kDHEPdgNz1FY7tv1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieekgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:zlbKXLHkJUh6JhQNeKo3HO5AgWFCuTZJaMjqMDfFlJi9KM4guXBeKg>
    <xmx:zlbKXD3417cta6diyPfU9JBm0Ola3n61-swtZQ4KmNfMaanX18gU5g>
    <xmx:zlbKXDmq2JMD1aW9ksk5R7bp8Gdhk45GssS0sziwVrp6AxUfzyogpA>
    <xmx:zlbKXKKiYN3xDyQWekoA0bcw9Z7cAv0ErdEdOZDkjUIhtc3p3Qr3kw>
Received: from eros.localdomain (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0925AE4382;
        Wed,  1 May 2019 22:32:42 -0400 (EDT)
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
Subject: [RFC PATCH 4/5] kobject: Add kobject initialized predicate
Date:   Thu,  2 May 2019 12:31:41 +1000
Message-Id: <20190502023142.20139-5-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502023142.20139-1-tobin@kernel.org>
References: <20190502023142.20139-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

A call to kobject_init() is required to be paired with a call to
kobject_put() in order to correctly free up the kobject.  During cleanup
functions it would be useful to know if a kobject was initialized in
order to correctly pair the call to kobject_put().  For example this is
necessary if we attempt to initialize multiple objects on a list and one
fails - in order to correctly do cleanup we need to know which objects
have been initialized.

Add a predicate kobject_is_initialized() to the kobject API.  This
function maintains the kobject layer of abstraction; simply returns
kobj->state_initialized.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 include/linux/kobject.h |  2 ++
 lib/kobject.c           | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 1ab0d624fb36..65a317b65d9c 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -100,6 +100,8 @@ int kobject_init_and_add(struct kobject *kobj,
 			 struct kobj_type *ktype, struct kobject *parent,
 			 const char *fmt, ...);
 
+extern bool kobject_is_initialized(struct kobject *kobj);
+
 extern void kobject_del(struct kobject *kobj);
 
 extern struct kobject * __must_check kobject_create(void);
diff --git a/lib/kobject.c b/lib/kobject.c
index 0181f102cd1c..ecddf417f452 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -366,6 +366,18 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
 }
 EXPORT_SYMBOL(kobject_init);
 
+/**
+ * kobject_is_initialized() - Kobject initialized predicate.
+ * @kobj: The kobject to query
+ *
+ * Return: True if @kobj has been initialized.
+ */
+bool kobject_is_initialized(struct kobject *kobj)
+{
+	return kobj->state_initialized;
+}
+EXPORT_SYMBOL(kobject_is_initialized);
+
 static __printf(3, 0) int kobject_add_varg(struct kobject *kobj,
 					   struct kobject *parent,
 					   const char *fmt, va_list vargs)
-- 
2.21.0

