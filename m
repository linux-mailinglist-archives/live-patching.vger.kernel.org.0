Return-Path: <live-patching+bounces-715-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF049992E6E
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2024 16:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF4411C2321C
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2024 14:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996261D88B3;
	Mon,  7 Oct 2024 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOTOgVJu"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D23C1D88A2;
	Mon,  7 Oct 2024 14:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728310165; cv=none; b=dcBqSueD/UwvwhCcVDi2v4hXxFa8BHMoKzrbtHxrOUW0qHMntmHOUEWgQgIZFQ3dy3vC7n6fFpsBdHUvo3pkxPrU+i4mr0MaqO8EO8HZohW4v83prqJDp7PjURpIi2u8Os+X7sFzXDct0IBrPJayOjwoytt3b5pllCdfd3ls+LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728310165; c=relaxed/simple;
	bh=mwC/Zq/zDGjHXDah/VAfeLUJVAyHaLbOTuZ3YjYbWio=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BxhvshxoMfErdKQWpyf24C4h11QgSW3Ua49PdMGziyn2ldCfTTRsERRnZOMh4P5t6uH4mfeG8s5LV7W1QwULM5j1xcSnFaqFxvQYvxVZvWimVn46QsxG+mZsfTa/PlxFhjIP1YTmKfomQuCGWV5XrcHAgXoHiqpkIwhgETNEy44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZOTOgVJu; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20b9b35c7c3so46945815ad.3;
        Mon, 07 Oct 2024 07:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728310163; x=1728914963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Uh81/2e9dkH9haM7zE5BAp4ehza0ejnMq9tdE5T+4I=;
        b=ZOTOgVJuZ9zI8pM5ZXY6NUc1/8KeIsp61OCX+a+es02zcMxsJVl5jhNfSaeZcBhxH/
         ydq/SGZrvYRHv+4k9HiL27X4ccDZmRnj3dFbRslBtgqIGn6ghi5JHctA9T+3t1uCTV3t
         6lrZiXWVHYf5I1P7SpDaKNLW5AYeM8JYDp4viJmjAOH0AkSJVcd/YKMMNna2f13XtgT5
         5bOuqKAAGIpNwwrYdGCtoaIXfTuc9il/5omSYYqLlm49t4zDBfllFqB10pjipAJFwP2z
         KEupNUedATesBkejNdjfs1cdUsZlC2/6EUrS5EyKVfZ/FeH0LQGoI2mLGPBGgbg/U9n8
         5teA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728310163; x=1728914963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Uh81/2e9dkH9haM7zE5BAp4ehza0ejnMq9tdE5T+4I=;
        b=e8dSErHQp40Cew5uXRrNTO9rO3T86Sl5Mda658HzJbqu59tmSuFwBiALFg25nyRH6s
         Nj1aTexz5c2rzpFeE5ApizuW42JSHPKexDf3XN7a+wlaRZeF3uEum79uB+gnxzww2rgz
         JNjcqDp/OVL9gVvF1sHjubZIh0iAezgq3k1u/hc/0ROWF+eBcLeaZfkA+Wpua98Owg73
         1sjqgpVq3KfekFNg8wmEo1NPvRGsmjbU8QWBZXk5X469SnOu0GUmXHyN0UYRclasGiVp
         wyk2nu0KDa3Xxec+WJbpE3/M+7b9lkdWY1F5mxO3jTFsoPC5j466vfzPLbOqBNzxA6Tu
         Cjbg==
X-Forwarded-Encrypted: i=1; AJvYcCWu0RqPg3wtoVb8QdRuFZLFx4XX4n17uHk9dQSe5LK2PPyoF58JU6W9N7K2ZmGii8ZVtkA+fH3psT1XpaQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAFLcGOp31v2ZQrd6bHLki5mZJDWYjM9LP+uRXV9DMvFZ3xzhT
	dUEw2q3hNdOrnREw/qHl0QaX1K1hJqUPGi/tjs8eWhZZ8ClvVgYs
X-Google-Smtp-Source: AGHT+IHhA0oLc96LbqOIZ+ZI2xOKquaGhL07fAkNGzq61epLEwnKgSyeRXdpXypYIbC/0gnSmTb7PA==
X-Received: by 2002:a17:902:da83:b0:20b:6a57:bf25 with SMTP id d9443c01a7336-20bfdfd521bmr204954735ad.20.1728310163412;
        Mon, 07 Oct 2024 07:09:23 -0700 (PDT)
Received: from B-M149MD6R-0150.lan ([2409:8a55:2e52:c0f1:4d08:3cf4:6043:d1e7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c13931185sm40303595ad.178.2024.10.07.07.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 07:09:22 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH V4 1/1] livepatch: Add stack_order sysfs attribute
Date: Mon,  7 Oct 2024 22:09:11 +0800
Message-Id: <20241007140911.49053-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20241007140911.49053-1-zhangwarden@gmail.com>
References: <20241007140911.49053-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add "stack_order" sysfs attribute which holds the order in which a live
patch module was loaded into the system. A user can then determine an
active live patched version of a function.

cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1

means that livepatch_1 is the first live patch applied

cat /sys/kernel/livepatch/livepatch_module/stack_order -> N

means that livepatch_module is the Nth live patch applied

Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Miroslav Benes <mbenes@suse.cz>
Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
---
 .../ABI/testing/sysfs-kernel-livepatch        |  9 +++++++
 kernel/livepatch/core.c                       | 24 +++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index 3735d868013d..73e40d02345e 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -55,6 +55,15 @@ Description:
 		An attribute which indicates whether the patch supports
 		atomic-replace.
 
+What:		/sys/kernel/livepatch/<patch>/stack_order
+Date:		Oct 2024
+KernelVersion:	6.13.0
+Description:
+		This attribute specifies the sequence in which live patch module
+		are applied to the system. If multiple live patches modify the same
+		function, the implementation with the biggest 'stack_order' number
+		is used, unless a transition is currently in progress.
+
 What:		/sys/kernel/livepatch/<patch>/<object>
 Date:		Nov 2014
 KernelVersion:	3.19.0
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 3c21c31796db..0cd39954d5a1 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -347,6 +347,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
  * /sys/kernel/livepatch/<patch>/replace
+ * /sys/kernel/livepatch/<patch>/stack_order
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
@@ -452,15 +453,38 @@ static ssize_t replace_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%d\n", patch->replace);
 }
 
+static ssize_t stack_order_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct klp_patch *patch, *this_patch;
+	int stack_order = 0;
+
+	this_patch = container_of(kobj, struct klp_patch, kobj);
+
+	mutex_lock(&klp_mutex);
+
+	klp_for_each_patch(patch) {
+		stack_order++;
+		if (patch == this_patch)
+			break;
+	}
+
+	mutex_unlock(&klp_mutex);
+
+	return sysfs_emit(buf, "%d\n", stack_order);
+}
+
 static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
 static struct kobj_attribute transition_kobj_attr = __ATTR_RO(transition);
 static struct kobj_attribute force_kobj_attr = __ATTR_WO(force);
 static struct kobj_attribute replace_kobj_attr = __ATTR_RO(replace);
+static struct kobj_attribute stack_order_kobj_attr = __ATTR_RO(stack_order);
 static struct attribute *klp_patch_attrs[] = {
 	&enabled_kobj_attr.attr,
 	&transition_kobj_attr.attr,
 	&force_kobj_attr.attr,
 	&replace_kobj_attr.attr,
+	&stack_order_kobj_attr.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(klp_patch);
-- 
2.18.2


