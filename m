Return-Path: <live-patching+bounces-982-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F92A11BDA
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCDF3161A73
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E251E7C2C;
	Wed, 15 Jan 2025 08:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mCj1zjcm";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eTeQb9jr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF571E7C1B;
	Wed, 15 Jan 2025 08:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929559; cv=none; b=fH69iaab3MzBkUsUdxXUgT46dss8goCGO6Sqqx5R0+piLdK1kcvAJ1gXKebuJlwRjbBH5S2IpwuWgeNNMSFZUi6R1Ie91OiQDNgDTJ3XIYCVIowYBGNhiOHehMfIM0aRBs7Tfh5KjqCGffjcoa3beqWWJgND+tlT9jQ0f84o+lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929559; c=relaxed/simple;
	bh=Or8V4YstlDyzCXeFBs/XuDB0ivkcgQDmP10vjcrnEGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO4CnpuavBadmOGwYdUGrW7E68uXYWtLD4kQzeaVoy5lFi67oREsgU7PeSUpzTuc5qJZI/3rkgryvUsNKlTlUBUPzk2KWY/KI/rVMIK6n+PrXp9E0NgqEMLBbFQNlL1Rhwh8TaZdh3Gl/6RAUNH1g20cVWVcxHsw9r4mxzm3sBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mCj1zjcm; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eTeQb9jr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id D6D391F37C;
	Wed, 15 Jan 2025 08:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ieNcANd9y+chKXgFAQhmhObhpsD2MZA9EtaeYXczQi0=;
	b=mCj1zjcmQTXxJqQY+7CrSFV3MMoGdaR9z9+U0Ut842uCjkaEVpREt6Whpv7ismZQnj0R9+
	NzboOas6V0vSEQWDvWxw5eUi9FyBOEXDBz/Gsj/tzNIxibO4U42bqhugqSo78+nt0KTN4B
	+8IH1Yem638PksqfdEvyWms3j9W14cY=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ieNcANd9y+chKXgFAQhmhObhpsD2MZA9EtaeYXczQi0=;
	b=eTeQb9jrPbTWHLWfpHSGFCminuQnpR4/PjbPL033IR252o1LJRsdNmskx6bvLUWRtJb6PU
	qrlpm9imsFi3qimbhIMmKuwkd/XeQYFl94pzE7u+t6T+QOfVeIG32UyAWOMRWuvgt5GHVN
	wP2Blvi5H1OY5iLIz/TzDTPpzkKHLN0=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 07/19] selftests/livepatch: Substitute hard-coded /sys/module path
Date: Wed, 15 Jan 2025 09:24:19 +0100
Message-ID: <20250115082431.5550-8-pmladek@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115082431.5550-1-pmladek@suse.com>
References: <20250115082431.5550-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLj3e56pwiuh8u4wxetmhsq5s5)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pathway.suse.cz:helo,suse.com:email,suse.com:mid]
X-Spam-Score: -6.80
X-Spam-Flag: NO

Substitute hard-coded /sys/module path with $SYSFS_MODULE_DIR.
It is going to be used even more often in the upcoming selftests.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 tools/testing/selftests/livepatch/functions.sh | 18 ++++++++++--------
 .../selftests/livepatch/test-callbacks.sh      |  2 +-
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index e5d06fb40233..3f86b89e6ea7 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -6,7 +6,9 @@
 
 MAX_RETRIES=600
 RETRY_INTERVAL=".1"	# seconds
-SYSFS_KERNEL_DIR="/sys/kernel"
+SYSFS_DIR="/sys"
+SYSFS_KERNEL_DIR="$SYSFS_DIR/kernel"
+SYSFS_MODULE_DIR="$SYSFS_DIR/module"
 SYSFS_KLP_DIR="$SYSFS_KERNEL_DIR/livepatch"
 SYSFS_DEBUG_DIR="$SYSFS_KERNEL_DIR/debug"
 SYSFS_KPROBES_DIR="$SYSFS_DEBUG_DIR/kprobes"
@@ -160,7 +162,7 @@ function __load_mod() {
 	fi
 
 	# Wait for module in sysfs ...
-	loop_until '[[ -e "/sys/module/$mod" ]]' ||
+	loop_until '[[ -e "$SYSFS_MODULE_DIR/$mod" ]]' ||
 		die "failed to load module $mod"
 }
 
@@ -228,7 +230,7 @@ function unload_mod() {
 	local mod="$1"
 
 	# Wait for module reference count to clear ...
-	loop_until '[[ $(cat "/sys/module/$mod/refcnt") == "0" ]]' ||
+	loop_until '[[ $(cat "$SYSFS_MODULE_DIR/$mod/refcnt") == "0" ]]' ||
 		die "failed to unload module $mod (refcnt)"
 
 	log "% rmmod $mod"
@@ -238,8 +240,8 @@ function unload_mod() {
 	fi
 
 	# Wait for module in sysfs ...
-	loop_until '[[ ! -e "/sys/module/$mod" ]]' ||
-		die "failed to unload module $mod (/sys/module)"
+	loop_until '[[ ! -e "$SYSFS_MODULE_DIR/$mod" ]]' ||
+		die "failed to unload module $mod ($SYSFS_MODULE_DIR)"
 }
 
 # unload_lp(modname) - unload a kernel module with a livepatch
@@ -269,11 +271,11 @@ function set_pre_patch_ret {
 	local mod="$1"; shift
 	local ret="$1"
 
-	log "% echo $ret > /sys/module/$mod/parameters/pre_patch_ret"
-	echo "$ret" > /sys/module/"$mod"/parameters/pre_patch_ret
+	log "% echo $ret > $SYSFS_MODULE_DIR/$mod/parameters/pre_patch_ret"
+	echo "$ret" > $SYSFS_MODULE_DIR/"$mod"/parameters/pre_patch_ret
 
 	# Wait for sysfs value to hold ...
-	loop_until '[[ $(cat "/sys/module/$mod/parameters/pre_patch_ret") == "$ret" ]]' ||
+	loop_until '[[ $(cat "$SYSFS_MODULE_DIR/$mod/parameters/pre_patch_ret") == "$ret" ]]' ||
 		die "failed to set pre_patch_ret parameter for $mod module"
 }
 
diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index 37bbc3fb2780..a65fd860662e 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -303,7 +303,7 @@ livepatch: '$MOD_LIVEPATCH': starting patching transition
 livepatch: '$MOD_LIVEPATCH': completing patching transition
 $MOD_LIVEPATCH: post_patch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH': patching complete
-% echo -19 > /sys/module/$MOD_LIVEPATCH/parameters/pre_patch_ret
+% echo -19 > $SYSFS_MODULE_DIR/$MOD_LIVEPATCH/parameters/pre_patch_ret
 % insmod test_modules/$MOD_TARGET.ko
 livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
 $MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-- 
2.47.1


