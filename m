Return-Path: <live-patching+bounces-2341-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mBPHFHYn3WlpaQkAu9opvQ
	(envelope-from <live-patching+bounces-2341-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:27:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 091033F1688
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6A3B7301BEBF
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 17:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3133644C7;
	Mon, 13 Apr 2026 17:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PAxciVqa"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A8C35FF6C
	for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 17:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776101197; cv=none; b=frhJEaTCSA4deAZO4u5lTfNDiUevy5eeeqLjxuI4fWmCBcitcV1CRnyOM+1y1FasvVIQJXMAopvKXuqJFutz65wSNhOwB87JU6UrES77OQKmBjKep8b2iY3A7ClEE7PaZcRbsaphsZhlTCqF10/JqpzWQfZ1KROx2l3EnsAofUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776101197; c=relaxed/simple;
	bh=GkImtgPH5yic9Ot61eWgr3BScmsVfGafIFT0QgZX3FM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jMpOpAPW3iedJqsUTzxSG16ljg0GDjjs+90DjG2uAdkSxfegfmC4ANXzC24SXPspuoD8yMkP9FowpjkzZ/Pl58qYT1Nlf/ko+i0rtapLvVzm6xrBRU4zu04gIMExtvXt1HM9BWV5NorQFUKusJE2IKl0M7CXsUYU65b3oBZNZgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PAxciVqa; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488ba6366a7so58610715e9.0
        for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 10:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776101194; x=1776705994; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ps4HVEOSSbu/h7yu9FHjVcTeRvNxChd6+ToWK5CE2C0=;
        b=PAxciVqaqBHl73RGaP4qaUW8TI/aP1VyCVFqITZytIfh3WxKMXbw/0MclMYjWmVWwT
         1fFbvyyEv8zbS18KVwu6+1Q5tIAPK21Kub34qMu/asgWP+O6WslFAskAbTA74S4eNm2a
         D19PfxPgj0/H5ix3l+XDwt5Wr/yhwQKuvhJe/permnt9XQ3dF2rdtVz82le7zUXQp4IO
         7tLajGse0lINJFI/KxXvWpmMSY236ZWZxdAtodlHjK85bqnSO6yi+I62bPb+UPTwDO17
         2GbE6WC55R48uSPfCxPP4zFHeIcoKcXstHK8unSBSgquHLQeNpPN+BojYS1n9buy7rC4
         Udmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776101194; x=1776705994;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ps4HVEOSSbu/h7yu9FHjVcTeRvNxChd6+ToWK5CE2C0=;
        b=AGNQhJ7ewOoEKokVTCvPA6gcDcCo/gpuxxAOwh3VyLyV5SoOsuCDOqnUdXoFBhNri2
         Va2lVIg/eEfWgts2X/OWFBCIOwrsr6MBJK6OOP6MrUWdhmhVuCoQP/Y7FbjRzeiSIuRc
         B/sJRvE1fIVQj2abAy1MQip+7E9W0rFOvRA8XIfNbbV03qDuMnAUK6C/AGDQYELqplxw
         HFUhtTDiQXLIjrvFBK/yC/8xOvVV4NVMYOrRxY21pNueBAcSx3ifXWdBEZ1Mnkeij5O0
         EyMWg9R/TzxcrnWoUfe3fd156wUBg7rGVxbgnhX7BXqLf5UwYbjlaIphB732PccKXkdR
         xA4w==
X-Gm-Message-State: AOJu0Ywx3rT2ex9A4Wt1fUTY5uedXIucQkct0dsyDiT07MzyeDy7J1GW
	KnCjDb2+APHzTKY5N4BhNMCOvb425DbxtZyl3M3hRR5Jl+kGQ33KYt1OVbVhsiQpOFA=
X-Gm-Gg: AeBDievsgYIX5UsmLuBvjoEDFvITPzxwvlu9fmnWcvgTyUt2vsAqiAJRq8yHMSuWOsh
	mS+EQtrPhtw1a88e2ovrZUCo9NMiSAzXQh/SL6JnEPI9N9ApR7DZyH7TloQZroetwokxvX+QUbX
	hyWgZ2mmjmCaZyyMwdP3zRzfRbpwxhM+jSbD7Yv5bi6jQF3y4DXeUtYYAQbedCadL4QoHLipSRb
	KkKs9Sq/WZz6UTgdt7IkE9Y3UYW2wfVyetuGvcV9K3WWYALtmmGi14gh50LR+FiBu8sdTzFHEmg
	anlmjdJvxcZEyxXIkamGq+4JjjCvnuXoHj1oYGvkKb/7ykI4/8Zhf3QXAbV6IE5hsq6zR3qTQVw
	SlyslVdRkbY4pBfPrVjQ1bjJ/w7/pvB0FbQ+ObVFoDqAYk00+qJR26x/XZp4O6Uba6F94bq5VVk
	YoPLDUv76Mr3m1vv0GMyxyW1E=
X-Received: by 2002:a05:600c:1987:b0:485:5ba3:37d8 with SMTP id 5b1f17b1804b1-488d67bf736mr190320525e9.5.1776101194126;
        Mon, 13 Apr 2026 10:26:34 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5734a94sm298657835e9.0.2026.04.13.10.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 10:26:33 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 13 Apr 2026 14:26:15 -0300
Subject: [PATCH v2 4/6] selftests: livepatch: Check if patched sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-lp-tests-old-fixes-v2-4-367c7cb5006f@suse.com>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
In-Reply-To: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776101176; l=3362;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=GkImtgPH5yic9Ot61eWgr3BScmsVfGafIFT0QgZX3FM=;
 b=x1Jqnz232Y2Za2WGjjWfQd5sf/VY9g4jnieH3D05KdD08Fl0IZT2uyS7vvQTiJMoyD36/rUmX
 Vw++e7EU4bKD+DegBw3ogKat+B/o2Iu1JOaF6CtLHYRI4C61jPZfyUf
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2341-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Queue-Id: 091033F1688
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In order to run the selftests on older kernels, check if given kernel
has support for the attribute. If the attribute is not supported, skip
the checks.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-sysfs.sh | 38 +++++++++++++++----------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 58fe1d96997c..a2d649404a63 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -8,6 +8,8 @@ MOD_LIVEPATCH=test_klp_livepatch
 MOD_LIVEPATCH2=test_klp_callbacks_demo
 MOD_LIVEPATCH3=test_klp_syscall
 
+HAS_PATCH_ATTR=0
+
 setup_config
 
 # - load a livepatch and verifies the sysfs entries work as expected
@@ -25,8 +27,12 @@ check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
-check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
+
+if does_sysfs_exists "$MOD_LIVEPATCH/vmlinux" "patched"; then
+	check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
+	check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
+	HAS_PATCH_ATTR=1
+fi
 
 disable_lp $MOD_LIVEPATCH
 
@@ -45,23 +51,24 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
-start_test "sysfs test object/patched"
+if [[ "$HAS_PATCH_ATTR" == "1" ]]; then
+	start_test "sysfs test object/patched"
 
-MOD_LIVEPATCH=test_klp_callbacks_demo
-MOD_TARGET=test_klp_callbacks_mod
-load_lp $MOD_LIVEPATCH
+	MOD_LIVEPATCH=test_klp_callbacks_demo
+	MOD_TARGET=test_klp_callbacks_mod
+	load_lp $MOD_LIVEPATCH
 
-# check the "patch" file changes as target module loads/unloads
-check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
-load_mod $MOD_TARGET
-check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "1"
-unload_mod $MOD_TARGET
-check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
+	# check the "patch" file changes as target module loads/unloads
+	check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
+	load_mod $MOD_TARGET
+	check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "1"
+	unload_mod $MOD_TARGET
+	check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
 
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
+	disable_lp $MOD_LIVEPATCH
+	unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/test_klp_callbacks_demo.ko
+	check_result "% insmod test_modules/test_klp_callbacks_demo.ko
 livepatch: enabling patch 'test_klp_callbacks_demo'
 livepatch: 'test_klp_callbacks_demo': initializing patching transition
 test_klp_callbacks_demo: pre_patch_callback: vmlinux
@@ -87,6 +94,7 @@ livepatch: 'test_klp_callbacks_demo': completing unpatching transition
 test_klp_callbacks_demo: post_unpatch_callback: vmlinux
 livepatch: 'test_klp_callbacks_demo': unpatching complete
 % rmmod test_klp_callbacks_demo"
+fi
 
 start_test "sysfs test replace enabled"
 

-- 
2.52.0


