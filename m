Return-Path: <live-patching+bounces-2925-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4L+6GF8MGWp4pwgAu9opvQ
	(envelope-from <live-patching+bounces-2925-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:47:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A22A5FCD2F
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 830B7303C3E4
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 03:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28DF4347BDC;
	Fri, 29 May 2026 03:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kLM1+zry"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF505355F3A
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 03:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026368; cv=none; b=nyCId4vG3deOvJftpet7Fk4F0qSQ4ZMKOzZqvsJaKWtpx6f8vYlvHsxoY7noXgdy2zFWlw2LimeHnXQz5HmD/OMYQ0b+ibvLHIu6tt1SbZDD5tOGgvyTxSY1VDVe8NM27yHl0a1zv/mwWft6ykaj5hdwBzVBurfSXGLGGDq7B+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026368; c=relaxed/simple;
	bh=AgZMuvZEGbbDLTye2/VqUz2KyO0wWKHW6DHUDxV8WtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJkfDn+6YC6WRrSv1MtRR7Oa844VyLjSPeno4kWRep0N5mZPP5m/7R9EFKOOoN1l/P7RRJGLIILcCaTaLXjwP0DKsP5Ul1Nxl+43hI86Bb7jZ4zOQzhVl4JxaGeGq4vl/5ReVcctcZKwBtEgamiRGp0K5YViLCycvf5+8vAbO40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kLM1+zry; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36ad15213fbso3063128a91.0
        for <live-patching@vger.kernel.org>; Thu, 28 May 2026 20:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780026366; x=1780631166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJZ8Mt206Fj970nNYgxXwvqJVK6dXJxW5N1/K+QOL1Y=;
        b=kLM1+zryUKDzkL7p9xmbkdqfMb0ZU85aeFE9aDnX5PcElCOE4ipF8JDjHz+sI6QXVQ
         7F0QoC/Z8qAi+G1AkCebBHsW4OXCKxGnFTpCre0GNzLpMkcZulHRI+a9WqdksPgz7Spx
         Yyiw6dcSlJconleJ/qXXr1uZxFEtOrVsynYd1WYzUBY3NWjgEpAUSSZbvgFlvC78V1GH
         CgMr8VHlkvGfPzCx83+mQ2mFmd8a5F07BIPvTVqiXqN2Lr9mhRt/EhyzDFpfwqvdu1eT
         j/NO/QNmPWLksPmvegi7RJVsA3wzauTlgND8BZfZvfK/MqRoWfHsJjPzmZHGtTZJQW0y
         GbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780026366; x=1780631166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gJZ8Mt206Fj970nNYgxXwvqJVK6dXJxW5N1/K+QOL1Y=;
        b=mfEdWnBqWFJ4Lg6iBPf9kFeDvdL+DWR2hTdRf5S7hAmBtAuE6wFNl0x9+PtD+1LmV/
         EKY4u/+P4JAhZstnzgGqyHRNzcm147qjHjQ+L6xCcfD8zgtJi8G3yK8tR9xOjQutVmd0
         RPy9duhtCwVLjmdFpN+DGncClImettAdpcFX09vYYXCmj+uI47yKNNZc8/94unc5ERqn
         Gqc7G4AX/bzv6H2qyHoIG8GiQ2zw8S3m/bZoX/vpgIND73szWDlkECok0z/YKoZyEqaQ
         bpVa4vBJID762sBN9XOsEJEUBgFamAFij5okpKpb/koGm/xCv4exyT+/9+8c34dCqT47
         C0BA==
X-Gm-Message-State: AOJu0YzwdSLNbpcVXZ6KneqV02vXLt/pv6tLIUJZkXqshsHsAbUk01TA
	QOpP2APavvf/mIalt3MvHwUtxqIKn9G4i2KzAG29/Q8xeO3LBzGIOMlX
X-Gm-Gg: Acq92OGwNiC0QLeh4o4YALlQubrlkNkT7xIOn+QNLAY5HsUyAMJFBvzCtptbkzpF3iS
	rNSyK9WVnm3vgVOBRS6W/g8VdnVC6mj2/bI28+8jVgXFG6yK7HKmboUhD8v24fv1LbJivd+QuU8
	gHZ3fSSlDUW1JKoT49YanhkSTHOU53y4i9CSS04xscEgb/pUARBYvIFn+DVr27szyjhfKIXNOXf
	9aRqLrIOCVWcERxWZzrcVCXOCbs3rbb7/wNZbzYY+BFZHW6WX2yKQ/VS20gri8HrsrVxjVx8EBb
	httUKrXGb3VdG+1qsh0Rl3MMJe4yhNmb11xB6D68pmTraqW/Irao3P603CVSR03kyKKrurugbRd
	jzjdmYzWjL1cCYVBCtSIcIdlv9hN8WHNlH7OLiY8wnHptVKIb+iMj6TUladojpXW74KwT+poZdo
	eGAVmZ3GIazsxSS15laOwseHAqghAYhuQCELWCJIeOzueqzzis7kJxSP+vxsufjKi4zxv4038XS
	DVpuhgGNanvUQvg2gTYXGvGqJY=
X-Received: by 2002:a17:90b:3a50:b0:36b:769c:e5bb with SMTP id 98e67ed59e1d1-36bbcc145cfmr1394816a91.5.1780026365897;
        Thu, 28 May 2026 20:46:05 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2000:3837:ec96:b29a:f0bb:6d68])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc6a340b7sm298385a91.11.2026.05.28.20.46.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 28 May 2026 20:46:05 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 3/4] livepatch: deprecate stack_order
Date: Fri, 29 May 2026 11:45:41 +0800
Message-ID: <20260529034542.68766-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260529034542.68766-1-laoar.shao@gmail.com>
References: <20260529034542.68766-1-laoar.shao@gmail.com>
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
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2925-lists,live-patching=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[live-patching];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 0A22A5FCD2F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

stack_order is no longer needed for atomic-replace livepatches, as a
single function can only be modified by a unique replace_set.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../ABI/testing/sysfs-kernel-livepatch        |  1 +
 kernel/livepatch/core.c                       | 24 -------
 .../testing/selftests/livepatch/test-sysfs.sh | 69 -------------------
 3 files changed, 1 insertion(+), 93 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index 6d75235a6a2e..fddad93dba79 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -62,6 +62,7 @@ Description:
 		are applied to the system. If multiple live patches modify the same
 		function, the implementation with the biggest 'stack_order' number
 		is used, unless a transition is currently in progress.
+		<deprecated>
 
 What:		/sys/kernel/livepatch/<patch>/<object>
 Date:		Nov 2014
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 969fea2a9263..6d65f839f442 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -351,7 +351,6 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
  * /sys/kernel/livepatch/<patch>/replace_set
- * /sys/kernel/livepatch/<patch>/stack_order
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
@@ -457,38 +456,15 @@ static ssize_t replace_set_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%u\n", patch->replace_set);
 }
 
-static ssize_t stack_order_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buf)
-{
-	struct klp_patch *patch, *this_patch;
-	int stack_order = 0;
-
-	this_patch = container_of(kobj, struct klp_patch, kobj);
-
-	mutex_lock(&klp_mutex);
-
-	klp_for_each_patch(patch) {
-		stack_order++;
-		if (patch == this_patch)
-			break;
-	}
-
-	mutex_unlock(&klp_mutex);
-
-	return sysfs_emit(buf, "%d\n", stack_order);
-}
-
 static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
 static struct kobj_attribute transition_kobj_attr = __ATTR_RO(transition);
 static struct kobj_attribute force_kobj_attr = __ATTR_WO(force);
 static struct kobj_attribute replace_set_kobj_attr = __ATTR_RO(replace_set);
-static struct kobj_attribute stack_order_kobj_attr = __ATTR_RO(stack_order);
 static struct attribute *klp_patch_attrs[] = {
 	&enabled_kobj_attr.attr,
 	&transition_kobj_attr.attr,
 	&force_kobj_attr.attr,
 	&replace_set_kobj_attr.attr,
-	&stack_order_kobj_attr.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(klp_patch);
diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 58fe1d96997c..0c31759f34f6 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -21,8 +21,6 @@ check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
 check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
-check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
 check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
@@ -135,71 +133,4 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
-start_test "sysfs test stack_order value"
-
-load_lp $MOD_LIVEPATCH
-
-check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
-
-load_lp $MOD_LIVEPATCH2
-
-check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
-
-load_lp $MOD_LIVEPATCH3
-
-check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
-
-disable_lp $MOD_LIVEPATCH2
-unload_lp $MOD_LIVEPATCH2
-
-check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
-check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "2"
-
-disable_lp $MOD_LIVEPATCH3
-unload_lp $MOD_LIVEPATCH3
-
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-livepatch: '$MOD_LIVEPATCH': patching complete
-% insmod test_modules/$MOD_LIVEPATCH2.ko
-livepatch: enabling patch '$MOD_LIVEPATCH2'
-livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting patching transition
-livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': patching complete
-% insmod test_modules/$MOD_LIVEPATCH3.ko
-livepatch: enabling patch '$MOD_LIVEPATCH3'
-livepatch: '$MOD_LIVEPATCH3': initializing patching transition
-livepatch: '$MOD_LIVEPATCH3': starting patching transition
-livepatch: '$MOD_LIVEPATCH3': completing patching transition
-livepatch: '$MOD_LIVEPATCH3': patching complete
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
-livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% rmmod $MOD_LIVEPATCH2
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH3/enabled
-livepatch: '$MOD_LIVEPATCH3': initializing unpatching transition
-livepatch: '$MOD_LIVEPATCH3': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH3': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH3': unpatching complete
-% rmmod $MOD_LIVEPATCH3
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
-
 exit 0
-- 
2.47.3


