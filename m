Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDFE224324
	for <lists+live-patching@lfdr.de>; Fri, 17 Jul 2020 20:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgGQSbN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jul 2020 14:31:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48254 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgGQSbM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jul 2020 14:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595010670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=y2xAxagpZEc0mZ8kCd/GscfUspmOueQdt1IrRm5lgEk=;
        b=AJYp3VyoYbBz8K7DQLnLEO/IhIHgRjaUuUDQU9+RanGm57SmmQG9vqNTXgyzK3lXabDIPl
        M3SVRf7zqIkdpYmcDz+Y/STZH7K9cglh0mVETRENlGX/DrlLRELvh6MkvQ9+NmUvs/sD+/
        PWFhugvwBwLGL8I82e8YZYBhepRumBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-LNVP4hAMPM2X4PxGAtNubw-1; Fri, 17 Jul 2020 14:31:06 -0400
X-MC-Unique: LNVP4hAMPM2X4PxGAtNubw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFE5D8015FB;
        Fri, 17 Jul 2020 18:31:05 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-144.rdu2.redhat.com [10.10.118.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43CC86FECD;
        Fri, 17 Jul 2020 18:31:05 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] Revert "kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled"
Date:   Fri, 17 Jul 2020 13:29:48 -0500
Message-Id: <696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Use of the new -flive-patching flag was introduced with the following
commit:

  43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")

This flag has several drawbacks:

- It disables some optimizations, so it can have a negative effect on
  performance.

- According to the GCC documentation it's not compatible with LTO, which
  will become a compatibility issue as LTO support gets upstreamed in
  the kernel.

- It was intended to be used for source-based patch generation tooling,
  as opposed to binary-based patch generation tooling (e.g.,
  kpatch-build).  It probably should have at least been behind a
  separate config option so as not to negatively affect other livepatch
  users.

- Clang doesn't have the flag, so as far as I can tell, this method of
  generating patches is incompatible with Clang, which like LTO is
  becoming more mainstream.

- It breaks GCC's implicit noreturn detection for local functions.  This
  is the cause of several "unreachable instruction" objtool warnings.

- The broken noreturn detection is an obvious GCC regression, but we
  haven't yet gotten GCC developers to acknowledge that, which doesn't
  inspire confidence in their willingness to keep the feature working as
  optimizations are added or changed going forward.

- While there *is* a distro which relies on this flag for their distro
  livepatch module builds, there's not a publicly documented way to
  create safe livepatch modules with it.  Its use seems to be based on
  tribal knowledge.  It serves no benefit to those who don't know how to
  use it.

  (In fact, I believe the current livepatch documentation and samples
  are misleading and dangerous, and should be corrected.  Or at least
  amended with a disclaimer.  But I don't feel qualified to make such
  changes.)

Also, we have an idea for using objtool to detect function changes,
which could potentially obsolete the need for this flag anyway.

At this point the flag has no benefits for upstream which would
counteract the above drawbacks.  Revert it until it becomes more ready.

This reverts commit 43bd3a95c98e1a86b8b55d97f745c224ecff02b9.

Fixes: 43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---

NOTE: I tried to be objective, factual, and thorough, to the best of my
knowledge.  Any suggestions for corrections to the commit message are
definitely welcome.

 Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Makefile b/Makefile
index 0b5f8538bde5..3b37d25aa028 100644
--- a/Makefile
+++ b/Makefile
@@ -876,10 +876,6 @@ KBUILD_CFLAGS_KERNEL += -ffunction-sections -fdata-sections
 LDFLAGS_vmlinux += --gc-sections
 endif
 
-ifdef CONFIG_LIVEPATCH
-KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
-endif
-
 ifdef CONFIG_SHADOW_CALL_STACK
 CC_FLAGS_SCS	:= -fsanitize=shadow-call-stack
 KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
-- 
2.25.4

