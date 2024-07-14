Return-Path: <live-patching+bounces-387-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AB4C930B6A
	for <lists+live-patching@lfdr.de>; Sun, 14 Jul 2024 21:59:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95DDA1F21844
	for <lists+live-patching@lfdr.de>; Sun, 14 Jul 2024 19:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D0113C810;
	Sun, 14 Jul 2024 19:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l/lgz7pU"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1705B200A0
	for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 19:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720987169; cv=none; b=cdymfiGShdPQbvI/dPzwKbc8D9ucOUr/iuwUPQLNX0vCabzWWt74NOEWBd5vpSWI+ktAQK/6rKlPZS7PUsNOgFv43hNZEOABWXehWejfE2+LsuauJSJ5hor5PvwUfix1a7mRktIL5J22qo7xRtxVc114lkoJbRWd9nxhsuEAkgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720987169; c=relaxed/simple;
	bh=z+4AC7YURCo4fhWKdlo/fqZcOsVrUOLciJ+J80+VNS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PMfMTqNO1Vq8gcHYvsCQetefWoN566bOPLU0wXaKpFiuI59ZfWv3NrRQrHAMfWSJgmWZTq/UxoSJJmLPSdMAm9HfHY1pf1yxZ80Zu67ZApoaTNsCwu183vgV9bdluGHW81El5w7zuFHSd/nBJMGlHKEVBqkgKJiQ28Jnp3FMGf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l/lgz7pU; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-427ad8bd88eso2613535e9.2
        for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 12:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720987165; x=1721591965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LXvuK/0Cd3EeetqLlLDGknFsfaQuvKc1CBsdWqpPV+o=;
        b=l/lgz7pU1YBR89nc8NCdun9OQbcDmN4tekoi7L6ESqHsTYw0A74uiwcuRv8laIyzwY
         CqhqaRUKzL04fDmNv3T9nGuU3PxWbhBJ2ztqSRmzEh6ib70xpDAVzAsW9atApEsWTGOj
         BqEEH2/HUUY/kVQM+dW/vLBXBzGyBdCUwKlQk6G4QEyt05d/aTjwbD1oMrYsXYJCmUIK
         bayp2NmAL3ognMcQVsAuPoJ6GkNJJ03RPEHYEr3Cnmmjr1NOLDSp3wRzRXLukcwdNbv4
         YOqWJJMfS9BFtw1FRzyH3kQFseKSiFaKV/J1hhN+yp2ui7IBtePbk4b4iU5WHKc2NDJ+
         rdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720987165; x=1721591965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LXvuK/0Cd3EeetqLlLDGknFsfaQuvKc1CBsdWqpPV+o=;
        b=HBEccgnL3dFfaLUyQloJJ2XYXrYbeAu5v5WmsTz5Ko+bFWclp/IJ/ZZB1+xN7suFMW
         Edht+2tjNQ/WkJ0tZBwuVz/8S6fuejSQJC/oe/SBmfYZAPrnNYaRSu2Wjx7CFy9ceX2z
         ItmJGOBiOttfgSsgaRPDfdYvDSUY2+CE67ZsrUYZYWFWOXbrMIeTYCZaIwO/asLuWWWq
         b3rjGSgY6XLuP4ZNTt3u1kmL09+q00l7KfqL2LFR+bj0+s4pEsyC34pi8pYklbt9RebA
         N3dqltIEezzl3SsVl2A5+DPq+5cXPTDyWkU/2QThDx3INKTLTHmdi1ZMAmKfpdV9Tw/i
         1Sqw==
X-Gm-Message-State: AOJu0YzW5sVDlmwzTEkMQgEorqRwl3K2qmbPARmfLOHJxQ8yTIF/ZALt
	5FulZigS94AJzx2pAB22ctlMF2lAW0HUkqPIuAsz1Dw+9aisZG4Y2gzQf7GCVhQ=
X-Google-Smtp-Source: AGHT+IEQO0DvYKGztPRmZhOlcYwkvBPu2we8S/GCm9aucOebf2+HfEWLqwC7KoDfgWHwzr8nByva6g==
X-Received: by 2002:a05:600c:4c8a:b0:426:6e93:4ad0 with SMTP id 5b1f17b1804b1-426707d7977mr121907925e9.17.1720987165470;
        Sun, 14 Jul 2024 12:59:25 -0700 (PDT)
Received: from roman-work.. ([77.222.27.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f25a957sm95253895e9.13.2024.07.14.12.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 12:59:25 -0700 (PDT)
From: raschupkin.ri@gmail.com
To: live-patching@vger.kernel.org,
	joe.lawrence@redhat.com,
	pmladek@suse.com,
	mbenes@suse.cz,
	jikos@kernel.org,
	jpoimboe@kernel.org
Cc: Roman Rashchupkin <raschupkin.ri@gmail.com>
Subject: [PATCH 1/2] [PATCH] livepatch: support of modifying refcount_t without underflow after unpatch.
Date: Sun, 14 Jul 2024 21:59:21 +0200
Message-ID: <20240714195922.692261-1-raschupkin.ri@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roman Rashchupkin <raschupkin.ri@gmail.com>

CVE fixes sometimes add refcount_inc/dec() pairs to the code with existing refcount_t.
Two problems arise when applying live-patch in this case:
1) After refcount_t is being inc() during system is live-patched, after unpatch the counter value
will not be valid, as corresponing dec() would never be called.
2) Underflows are possible in runtime in case dec() is called before
corresponding inc() in the live-patched code.

Proposed kprefcount_t functions are using following approach to solve these two problems:
1) In addition to original refcount_t, temporary refcount_t is allocated, and after
unpatch it is just removed. This way system is safe with correct refcounting while patch is applied,
and no underflow would happend after unpatch.
2) For inc/dec() added by live-patch code, one bit in reference-holder structure is used
(unsigned char *ref_holder, kprefholder_flag). In case dec() is called first, it is just ignored
as ref_holder bit would still not be initialized.

Signed-off-by: Roman Rashchupkin <raschupkin.ri@gmail.com>
---
 include/linux/livepatch_refcount.h | 19 +++++++
 kernel/livepatch/Makefile          |  2 +-
 kernel/livepatch/kprefcount.c      | 89 ++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/livepatch_refcount.h
 create mode 100644 kernel/livepatch/kprefcount.c

diff --git a/include/linux/livepatch_refcount.h b/include/linux/livepatch_refcount.h
new file mode 100644
index 000000000000..02f9e7eeadb2
--- /dev/null
+++ b/include/linux/livepatch_refcount.h
@@ -0,0 +1,19 @@
+#ifndef __KP_REFCOUNT_T__
+#define __KP_REFCOUNT_T__
+
+#include <linux/refcount.h>
+
+typedef struct kprefcount_struct {
+	refcount_t *refcount;
+	refcount_t kprefcount;
+	spinlock_t lock;
+} kprefcount_t;
+
+kprefcount_t *kprefcount_alloc(refcount_t *refcount, gfp_t flags);
+void kprefcount_free(kprefcount_t *kp_ref);
+int kprefcount_read(kprefcount_t *kp_ref);
+void kprefcount_inc(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
+void kprefcount_dec(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
+bool kprefcount_dec_and_test(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
+
+#endif
diff --git a/kernel/livepatch/Makefile b/kernel/livepatch/Makefile
index cf03d4bdfc66..8ff0926372c2 100644
--- a/kernel/livepatch/Makefile
+++ b/kernel/livepatch/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_LIVEPATCH) += livepatch.o
 
-livepatch-objs := core.o patch.o shadow.o state.o transition.o
+livepatch-objs := core.o patch.o shadow.o state.o transition.o kprefcount.o
diff --git a/kernel/livepatch/kprefcount.c b/kernel/livepatch/kprefcount.c
new file mode 100644
index 000000000000..6878033c5ddc
--- /dev/null
+++ b/kernel/livepatch/kprefcount.c
@@ -0,0 +1,89 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/refcount.h>
+#include <linux/livepatch_refcount.h>
+
+MODULE_LICENSE("GPL");
+
+kprefcount_t *kprefcount_alloc(refcount_t *refcount, gfp_t flags)
+{
+	kprefcount_t *kp_ref = kmalloc(sizeof(kprefcount_t), flags);
+	if (!kp_ref)
+		return 0;
+	kp_ref->refcount = refcount;
+	refcount_set(&kp_ref->kprefcount, 1);
+	spin_lock_init(&kp_ref->lock);
+	return kp_ref;
+}
+EXPORT_SYMBOL(kprefcount_alloc);
+
+void kprefcount_free(kprefcount_t *kp_ref)
+{
+	kfree(kp_ref);
+}
+EXPORT_SYMBOL(kprefcount_free);
+
+static bool kprefcount_check_owner(unsigned char *ref_holder, int kprefholder_flag)
+{
+	if (!ref_holder)
+		return true;
+	return (*ref_holder) & kprefholder_flag;
+}
+
+int kprefcount_read(kprefcount_t *kp_ref)
+{
+	return refcount_read(kp_ref->refcount) + refcount_read(&kp_ref->kprefcount) - 1;
+}
+EXPORT_SYMBOL(kprefcount_read);
+
+void kprefcount_inc(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag)
+{
+	spin_lock(&kp_ref->lock);
+	BUG_ON(ref_holder && kprefcount_check_owner(ref_holder, kprefholder_flag));
+	if (ref_holder)
+		*ref_holder |= kprefholder_flag;
+	refcount_inc(&kp_ref->kprefcount);
+	spin_unlock(&kp_ref->lock);
+}
+EXPORT_SYMBOL(kprefcount_inc);
+
+static int kprefcount_dec_locked(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag)
+{
+	if (!kprefcount_check_owner(ref_holder, kprefholder_flag))
+		return -1;
+	if (ref_holder) {
+		*ref_holder &= !kprefholder_flag;
+		refcount_dec(&kp_ref->kprefcount);
+	} else
+		refcount_dec(kp_ref->refcount);
+	return 0;
+}
+
+void kprefcount_dec(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag)
+{
+	spin_lock(&kp_ref->lock);
+	kprefcount_dec_locked(kp_ref, ref_holder, kprefholder_flag);
+	spin_unlock(&kp_ref->lock);
+
+}
+EXPORT_SYMBOL(kprefcount_dec);
+
+bool kprefcount_dec_and_test(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag)
+{
+	spin_lock(&kp_ref->lock);
+	if (kprefcount_dec_locked(kp_ref, ref_holder, kprefholder_flag)) {
+		spin_unlock(&kp_ref->lock);
+		return false;
+	}
+	if (kprefcount_read(kp_ref) == 0) {
+		spin_unlock(&kp_ref->lock);
+		return true;
+	}
+	spin_unlock(&kp_ref->lock);
+	return false;
+}
+EXPORT_SYMBOL(kprefcount_dec_and_test);
-- 
2.43.0


