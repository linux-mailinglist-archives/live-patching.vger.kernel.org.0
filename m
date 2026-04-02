Return-Path: <live-patching+bounces-2277-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0NzXNIE3zmmAmAYAu9opvQ
	(envelope-from <live-patching+bounces-2277-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 11:31:45 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB56386F59
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 11:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CFAC530B51C3
	for <lists+live-patching@lfdr.de>; Thu,  2 Apr 2026 09:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA785396D36;
	Thu,  2 Apr 2026 09:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwjBuQCg"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A397F3921DF
	for <live-patching@vger.kernel.org>; Thu,  2 Apr 2026 09:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775122014; cv=none; b=NGVeXo9H0JSW/ciMEMGaV8dO+jKE1yxl/oSzlVb28ZEVqRkH8zBLBWSJ8MFYBtKrDyyeH8oOgTtZAFGZ6w4COsivdUNc/iqhxtTQ6lH2mN/ajOGGPHUYtP0oBZjD+2Eht5KWsg3XcIp+pqT17SJuCOC5CkdOEem6K7WFGpa23Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775122014; c=relaxed/simple;
	bh=fg9gtssW70rqBjzjZemwy81+H2Jd6oM+l/xkQy5zuS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSFw2DPa7ZcvtaAJimHPQGpPzL+MnOhIKrSdkHLkFLFlC800vuwTvVuGjgO0jWWE1cCBFvy1Cy0XbfCGyenTbT7iboNqop+GjFATetjVav5yLPOFZw4X3eRXVmYlXXLHUhE2IjJMwaWLFl0cl0htfxbMyyCstJqrMwH/Re8Ioi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NwjBuQCg; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35d96be7c13so363054a91.0
        for <live-patching@vger.kernel.org>; Thu, 02 Apr 2026 02:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775122004; x=1775726804; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcS6+ltlajemy60nMyxmGDon25GNRE0B5Cl/4uAqhyI=;
        b=NwjBuQCg+b08pUjtJ4kKR6QxL3EofbU+P1etAguRY5SkyGw65JUgXjogeGYGpXAacV
         N2UDTdgGH9KEx4RsQJ1sx654k6ZKfMOxAssT7RmifOy3UF7MmhNdppcmSe5eu+ycS92o
         VgOuVvYdMw/Qjz7qLB1LosBadeghQhTHXkyyxKSWWIuFyYiO0rIBYNxWYcLy87KijYqF
         J6nEjtHYuHfygTZF4dGZK9wZruYwpNEieAuNUD6Z+F7V1AjJCLD9+5dKfMHjG+E4SvFt
         1bP2XQy4J2We3hdie9ogx7N266tIguejWg+kF8jS+kL/Kz0Wx3pg2JQ8H2GuBiSyMMRy
         BtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775122004; x=1775726804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CcS6+ltlajemy60nMyxmGDon25GNRE0B5Cl/4uAqhyI=;
        b=ktBYWDyAtTMv+ZyirBmfY4egCjcHl5THNcdPM0jX22YYw3lNGkuv4IL07DfMsb/vNi
         kFmcFq4ZXfmyU1+AEf9n+nt8M7n4tf+xahhMWFQi/D0YwwuVGJtYVOH8MEhgiwDM+t3G
         Pff07MktyyGuNNvfCe4eRkoBpWec8bXSLZmoSlqiMkcn1KKIuWuJWl40kaYOMH/QfGOw
         Ki3sATyR8+5y1CivvMrwSF3IYUmToCPpQ9fRSoE3dBB4b5FwrKyxgIBIjqA0fiBAfUwH
         0p26Z8lTBxZZTpxvZ9mBVLJrwFAw2jXVl1D4I1fEJBnFOz18LoDt+/CUfno4DgD9rtJ8
         2CTw==
X-Gm-Message-State: AOJu0YzpsH0Kr2CbhHvFRZgO8UI+irLhJif/WZ1oIIpdV6JchBApbUCd
	dR17wVkzdBvSM8mibcLwqQXmEq8nr9TX3ZkLzI/wlIiv8bcv+OpyvPdv
X-Gm-Gg: AeBDieuOygF7Sx0BRsch7P7dr2yFu/KGGlllg5KTKY4WLAj5SDxT4SgrhsdwPVKCRwk
	Q8fl6SrS3bbpeATWR/mi62NIKzE5l8cMYOFgJtTSM9zbC5iN187aGSmMuS5+tsx86T0wC9+IQc0
	nsaQNfkys4j5IqMdULRHSsNRzusI46A5nHlqyiWSCBaEBHWmoevGFKPs9bCgn78SqFC7Xfn3ugm
	VrXLLPTCvjdsxwg0AxjXzzc3n1TkKAqXfvoIFikRePb3l30gnpWQh9V5db/UhptBgb3FLXqw/Gv
	c7UqcRSor6pHDtDqJDeLI19heE0+eH19eGQx3/RYLXw+lXGcxqGHCpSFmH/3kHOIljBI+9xuPhs
	T1VfWA7Q97ceAaGSCTuWnOWVdjl3TiQaiAQlc6Ya4BFd+aONAIMXH//f0AczHdw8etnzox+7CZQ
	+dBBuQuuDSrAby/TKvBYtJymNHtciWWGieQ/3RBYfuZ9sB
X-Received: by 2002:a17:90b:4a48:b0:35d:9fe9:f830 with SMTP id 98e67ed59e1d1-35dd684eacamr1324687a91.12.1775122003834;
        Thu, 02 Apr 2026 02:26:43 -0700 (PDT)
Received: from yafangs-Air ([2409:891f:1aa0:8613:19f3:7bee:2e41:149e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dd35f50e9sm2227645a91.6.2026.04.02.02.26.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Apr 2026 02:26:43 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	kpsingh@kernel.org,
	mattbobrowski@google.com,
	song@kernel.org,
	jolsa@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	memxor@gmail.com,
	yonghong.song@linux.dev
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
Date: Thu,  2 Apr 2026 17:26:06 +0800
Message-ID: <20260402092607.96430-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260402092607.96430-1-laoar.shao@gmail.com>
References: <20260402092607.96430-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2277-lists,live-patching=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 7CB56386F59
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a new replaceable attribute to allow the coexistence of both
atomic-replace and non-atomic-replace livepatches. If replaceable is set to
0, the livepatch will not be replaced by a subsequent atomic-replace
operation.

This is a preparatory patch for following changes.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/livepatch.h |  2 ++
 kernel/livepatch/core.c   | 44 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index ba9e3988c07c..d88a6966e5f2 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -124,6 +124,7 @@ struct klp_state {
  * @objs:	object entries for kernel objects to be patched
  * @states:	system states that can get modified
  * @replace:	replace all actively used patches
+ * @replaceable:	whether this patch can be replaced or not
  * @list:	list node for global list of actively used patches
  * @kobj:	kobject for sysfs resources
  * @obj_list:	dynamic list of the object entries
@@ -138,6 +139,7 @@ struct klp_patch {
 	struct klp_object *objs;
 	struct klp_state *states;
 	bool replace;
+	bool replaceable;
 
 	/* internal */
 	struct list_head list;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 28d15ba58a26..04f9e84f114f 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -351,6 +351,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
  * /sys/kernel/livepatch/<patch>/replace
+ * /sys/kernel/livepatch/<patch>/replaceable
  * /sys/kernel/livepatch/<patch>/stack_order
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
@@ -478,17 +479,60 @@ static ssize_t stack_order_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%d\n", stack_order);
 }
 
+static ssize_t replaceable_store(struct kobject *kobj, struct kobj_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct klp_patch *patch;
+	bool replaceable;
+	int ret;
+
+	ret = kstrtobool(buf, &replaceable);
+	if (ret)
+		return ret;
+
+	patch = container_of(kobj, struct klp_patch, kobj);
+
+	mutex_lock(&klp_mutex);
+
+	if (patch->replaceable == replaceable)
+		goto out;
+
+	if (patch == klp_transition_patch) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	patch->replaceable = replaceable;
+
+out:
+	mutex_unlock(&klp_mutex);
+
+	if (ret)
+		return ret;
+	return count;
+}
+static ssize_t replaceable_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *buf)
+{
+	struct klp_patch *patch;
+
+	patch = container_of(kobj, struct klp_patch, kobj);
+	return sysfs_emit(buf, "%d\n", patch->replaceable);
+}
+
 static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
 static struct kobj_attribute transition_kobj_attr = __ATTR_RO(transition);
 static struct kobj_attribute force_kobj_attr = __ATTR_WO(force);
 static struct kobj_attribute replace_kobj_attr = __ATTR_RO(replace);
 static struct kobj_attribute stack_order_kobj_attr = __ATTR_RO(stack_order);
+static struct kobj_attribute replaceable_kobj_attr = __ATTR_RW(replaceable);
 static struct attribute *klp_patch_attrs[] = {
 	&enabled_kobj_attr.attr,
 	&transition_kobj_attr.attr,
 	&force_kobj_attr.attr,
 	&replace_kobj_attr.attr,
 	&stack_order_kobj_attr.attr,
+	&replaceable_kobj_attr.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(klp_patch);
-- 
2.47.3


