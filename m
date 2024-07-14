Return-Path: <live-patching+bounces-389-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2CBD930B6D
	for <lists+live-patching@lfdr.de>; Sun, 14 Jul 2024 22:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5772B281585
	for <lists+live-patching@lfdr.de>; Sun, 14 Jul 2024 20:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3766813B5B9;
	Sun, 14 Jul 2024 20:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+9T/hAq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDC47492
	for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 20:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720987219; cv=none; b=qlSAxK7nR5AU+YqA4snjVOUz3jQBFt8+IcLCZCNbL9WffMuvkhN+V/dXjZEjOo3Qb0ZMePEsTn0kontMzZoul5gI3Pvh8EzJDGTidkQKML92zxTaPmlSDCN0Iht42KXVs4dH1VH3IbQZjsRAOrCR2dRKd458b/oxj4aPQgtUzok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720987219; c=relaxed/simple;
	bh=z+4AC7YURCo4fhWKdlo/fqZcOsVrUOLciJ+J80+VNS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifClVIt+3c2j1nPJN4D6kIZ06T5BRyYMKW0qVxSNKHkAxswFlPizbYjxtmyPyQnmyPJLSiNEdkon4aTrpOGnqd7gIBf9A1plccbR65rWjMKemmPj7ubIQxBkMIfeTfzBw65irYXVB8B+G5DJWlgCkvUSjR3PpxwBya5Bw67sd6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C+9T/hAq; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-36796d2e5a9so2169546f8f.3
        for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 13:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720987215; x=1721592015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXvuK/0Cd3EeetqLlLDGknFsfaQuvKc1CBsdWqpPV+o=;
        b=C+9T/hAq7lI+kVVUG/iyT4ZrxMtfAGodTZ/mg89TskyvsQLSxi14+qqD3DyZ5dr+C2
         /p2wYTR0E12O/ds+GEs8pmzbcV+KMuRO/SNLnEoiUvDy2FFTIpLhCbLpED76OJ3bbw5Z
         RZlvWhwuxnLclKCGdUXHNRA407wvdX/s5i1GCPWLZRe71aziMdzoPVuhY4NNCc2zZ7rE
         iUTE5HKLowIvB8yGUImnXuWtR9v6CYhWNJzOkILhHXv1CSQNUdbQ1G35Yx7vYQLIPVYD
         p3q/7lUthiIyJipqBswsiS2t5yu4cT0UheID0tivZxHPVGfZpwNa9MaqfUUSkS0Oa552
         fGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720987215; x=1721592015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LXvuK/0Cd3EeetqLlLDGknFsfaQuvKc1CBsdWqpPV+o=;
        b=apMXIUyOuUuPj6b60A6uH1MEGNCgAEpkoGtR2C2w6c5/bMwaCnX4m1PzqQqRbudfje
         7nPHSD+i6EgiRHdVDcTBWkKL3/k/crAM2XRqJfwVJNQYKAcqOUDnldwwGAbA5cp+MENE
         mcmq6L74ygIHbU+lRGMCb1/1jgfRM+GLgJGVpOYmah96h49NpdEiTCIx28wczfCbu7Jv
         ACGySu3HA6A35YMOK/r0uBqagVmdyXYDtoO97aevasDe8siFREuldREsKVYfK/zbFWM/
         nO4EErZ3aHNeR9KVclO+U21wMDcpILsoyjyI40RnQFhUhtRA+dXS6FSFvrcCAKkyTZgW
         ImfA==
X-Gm-Message-State: AOJu0YzI6/iqo6VDI4EA7+KuyDiIkrIVPItDXIn3XkGsA/uegYelNKbI
	I1mYRO7vSzrtroHoWNsgqOEZR7d7jSTVJ12R1IGXlTaYsQhoq7OgCOEHjIHEZwg=
X-Google-Smtp-Source: AGHT+IGCnyOTNAYnPuEj1hgKiKr+TCX42Nd6xFQ3/+QIBXecQii0VuE4AL6I+Un2eFExe0Xm3VDkRw==
X-Received: by 2002:a5d:4848:0:b0:367:94ff:6835 with SMTP id ffacd0b85a97d-367cea67ecemr10822727f8f.18.1720987215410;
        Sun, 14 Jul 2024 13:00:15 -0700 (PDT)
Received: from roman-work.. ([77.222.27.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5edb525sm61145985e9.34.2024.07.14.13.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 13:00:15 -0700 (PDT)
From: raschupkin.ri@gmail.com
To: live-patching@vger.kernel.org,
	joe.lawrence@redhat.com,
	pmladek@suse.com,
	mbenes@suse.cz,
	jikos@kernel.org,
	jpoimboe@kernel.org
Cc: Roman Rashchupkin <raschupkin.ri@gmail.com>
Subject: [PATCH 1/2] [PATCH] livepatch: support of modifying refcount_t without underflow after unpatch.
Date: Sun, 14 Jul 2024 21:59:33 +0200
Message-ID: <20240714195958.692313-2-raschupkin.ri@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240714195958.692313-1-raschupkin.ri@gmail.com>
References: <20240714195958.692313-1-raschupkin.ri@gmail.com>
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


