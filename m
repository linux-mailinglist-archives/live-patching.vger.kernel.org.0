Return-Path: <live-patching+bounces-1748-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC30BD5837
	for <lists+live-patching@lfdr.de>; Mon, 13 Oct 2025 19:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD9B6404294
	for <lists+live-patching@lfdr.de>; Mon, 13 Oct 2025 17:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52BC23081D5;
	Mon, 13 Oct 2025 17:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwE1q+CD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0203081B1
	for <live-patching@vger.kernel.org>; Mon, 13 Oct 2025 17:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760376625; cv=none; b=eeNcSRj79WDC3CuCVPaHLXZr3UXpFMwhGLpsZkCRv2Tht44B0jsiZWDLqq8yda0DAdtHOkMYlrM/5l6mgX5/nPKcBUbga4k9bZSs8w48X3Rugf4XMWbfg5LE2FarK+z+3FE8AmDVRqMsarfpsbSbW9VcUgC9PBq+tr89hAd/ZXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760376625; c=relaxed/simple;
	bh=zQV1gpWGYuZuVay/3o8NCpySDiHKZnCHoQUgXSR9Eis=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s2KfV5jldBDklAdLAiGnAh7yW0tXDZjkgwCJdlFrnfUeRmKSolT6wU8MPvf5fhvg8dmJd6SXnAqaCAWfuLiUBTZbeWZ5Rb0s/PPnsGC8iJgvqYSoLVuysX+ZOv43OE6jlXZrxrXPO7WlqpgykEONhreUhLspcZeSlQO7t5lMnho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwE1q+CD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F9BC4CEFE;
	Mon, 13 Oct 2025 17:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760376624;
	bh=zQV1gpWGYuZuVay/3o8NCpySDiHKZnCHoQUgXSR9Eis=;
	h=From:To:Cc:Subject:Date:From;
	b=uwE1q+CD9zMetuB1Zccs63UPgvY6O8ZZRA51tyzLQ4HtkpILUucz3AWvq0lky90XW
	 vTHk10OYZ8/BXPJTArKIdi3V3Xza4oaUhVyKKjP/YxBFQC6kv9QF/wElPm1hcWDG76
	 GkzJzmnpNex/19Q9Gu9tZR+oadH17A6u12MhrMEPq5awTVR7k3o0AjSuBuekR1+ng2
	 dF3ffJ2vLUwDngL1HAlnZ/mIPWuh6yWMw6jpktjdUESnUJiXeBWR7XBIC6BZzynEER
	 q9mJhk0Nwxgmy8V5HZndXaZHa5KjyTjoYKVDy+dmWi38edWHaC/Ihk+hUfWQ5eieqy
	 0mcQrdd9HEMoA==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v2] livepatch: Match old_sympos 0 and 1 in klp_find_func()
Date: Mon, 13 Oct 2025 10:30:19 -0700
Message-ID: <20251013173019.990707-1-song@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When there is only one function of the same name, old_sympos of 0 and 1
are logically identical. Match them in klp_find_func().

This is to avoid a corner case with different toolchain behavior.

In this specific issue, issue two versions of kpatch-build were used to
build livepatch for the same kernel. One assigns old_sympos == 0 for
unique local functions, the other assigns old_sympos == 1 for unique
local functions. Both versions work fine by themselves. (PS: This
behavior change was introduced in a downstream version of kpatch-build.
This change does not exist in upstream kpatch-build.)

However, during livepatch upgrade (with the replace flag set) from a
patch built with one version of kpatch-build to the same fix built with
the other version of kpatch-build, livepatching fails with errors like:

[   14.218706] sysfs: cannot create duplicate filename 'xxx/somefunc,1'
...
[   14.219466] Call Trace:
[   14.219468]  <TASK>
[   14.219469]  dump_stack_lvl+0x47/0x60
[   14.219474]  sysfs_warn_dup.cold+0x17/0x27
[   14.219476]  sysfs_create_dir_ns+0x95/0xb0
[   14.219479]  kobject_add_internal+0x9e/0x260
[   14.219483]  kobject_add+0x68/0x80
[   14.219485]  ? kstrdup+0x3c/0xa0
[   14.219486]  klp_enable_patch+0x320/0x830
[   14.219488]  patch_init+0x443/0x1000 [ccc_0_6]
[   14.219491]  ? 0xffffffffa05eb000
[   14.219492]  do_one_initcall+0x2e/0x190
[   14.219494]  do_init_module+0x67/0x270
[   14.219496]  init_module_from_file+0x75/0xa0
[   14.219499]  idempotent_init_module+0x15a/0x240
[   14.219501]  __x64_sys_finit_module+0x61/0xc0
[   14.219503]  do_syscall_64+0x5b/0x160
[   14.219505]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[   14.219507] RIP: 0033:0x7f545a4bd96d
...
[   14.219516] kobject: kobject_add_internal failed for somefunc,1 with
    -EEXIST, don't try to register things with the same name ...

This happens because klp_find_func() thinks somefunc with old_sympos==0
is not the same as somefunc with old_sympos==1, and klp_add_object_nops
adds another xxx/func,1 to the list of functions to patch.

Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/livepatch/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 0e73fac55f8e..53c3b9b40c8b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -88,8 +88,14 @@ static struct klp_func *klp_find_func(struct klp_object *obj,
 	struct klp_func *func;
 
 	klp_for_each_func(obj, func) {
+		/*
+		 * Besides identical old_sympos, also condiser old_sympos
+		 * of 0 and 1 are identical.
+		 */
 		if ((strcmp(old_func->old_name, func->old_name) == 0) &&
-		    (old_func->old_sympos == func->old_sympos)) {
+		    ((old_func->old_sympos == func->old_sympos) ||
+		     (old_func->old_sympos == 0 && func->old_sympos == 1) ||
+		     (old_func->old_sympos == 1 && func->old_sympos == 0))) {
 			return func;
 		}
 	}
-- 
2.47.3


