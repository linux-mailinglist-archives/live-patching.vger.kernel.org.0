Return-Path: <live-patching+bounces-1744-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4826EBCEBCC
	for <lists+live-patching@lfdr.de>; Sat, 11 Oct 2025 01:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D5D82352BE0
	for <lists+live-patching@lfdr.de>; Fri, 10 Oct 2025 23:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D9E27B4E4;
	Fri, 10 Oct 2025 23:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntc37yHn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E462367D7
	for <live-patching@vger.kernel.org>; Fri, 10 Oct 2025 23:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760137353; cv=none; b=NoFcr4oR2xEsABNCvuVDupxf2pu++tCN9rU0LbSE84hbsa40j+IRtX5mpBPE3UeriHZt756YpL+NgIQsvOyn7fiHPlOK43HlJl4NA2nNsO12o3oW+sGIKQiKAciUqQvx8NWiXkzzdjZYvS9tScibHvcHbghS1lvJHiGt2L9CdXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760137353; c=relaxed/simple;
	bh=sZyLjT9mZjuuTzDbd+1DvFTCecM20X/AzHziSKco8sY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cZkeIQCBQ+jGDtOzFwwiA0vaB1vZmBOBF4+aN/F7p8YuIDiqNJbZ4TcBVrvCAFkhl+slD0QRvx/PysvkqN+lgq58gq5i20EcidUuaBmInQVMXHb9onlxKpjXfIfhPaSQq/zRfbRQPnGoFQiW6e0usQiq1yyZoJd4kkHlC2zg2mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntc37yHn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04626C4CEF1;
	Fri, 10 Oct 2025 23:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760137352;
	bh=sZyLjT9mZjuuTzDbd+1DvFTCecM20X/AzHziSKco8sY=;
	h=From:To:Cc:Subject:Date:From;
	b=ntc37yHnKlQtt9xM18yiIS64X6ECTgD50/ENBjSACyQYXvhxS+XOsXcAHkNwdkJnX
	 mbZqZvaHeqPs8tdpRCKriR2fSrdRyssgh0Z4VR93weiBfkabmeIr8FEWdOaUDjE0Yc
	 fNPX4rn5FLj2PF5pCcbjNkU2lx9fUr6mqXBqgOM6q1sEqzZz8puC8VWM256rQ7E+7O
	 wQPwKuZVz+FmUdQ7LZP5+nI1ghv5p69FTGQpgB33bcdzY31qtQOz3WREcKWTMpcpIm
	 NuKj+WodZcaedWb5uuG/lEB0aXJvTopYvS4ecysEgJnwQXJ76ukfv+KN7xPvXC0qx9
	 kd+V4dr4pbVCw==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH] livepatch: Match old_sympos 0 and 1 in klp_find_func()
Date: Fri, 10 Oct 2025 16:02:23 -0700
Message-ID: <20251010230223.4013896-1-song@kernel.org>
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

Signed-off-by: Song Liu <song@kernel.org>

---

This is to avoid a corner case I hit in testing.

I had two versions of kpatch-build, one assigns old_sympos == 0 for
unique local functions, the other assigns old_sympos == 1 for unique
local functions. Both versions work fine by themselves.

However, when we do patch upgrade (with the replace flag) with a
patch built with one version of kpatch-build to replace the same fix
bult with the other version of kpatch-build, we hit errors like:

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

Yes, this is a really rare case, and the toolchain (kpatch-build) should
be consistent with old_sympos. But I think we may want to fix the
behavior in kernel just in case.
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


