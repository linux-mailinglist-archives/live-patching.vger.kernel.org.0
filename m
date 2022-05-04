Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339D4519FCE
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 14:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349895AbiEDMsN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 08:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349760AbiEDMsL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 08:48:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AA333A28;
        Wed,  4 May 2022 05:44:36 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651668274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sq/ZfBcYwetCSwS2b1v/F95/fw7AV7LRpm+RRYHMFhE=;
        b=4LWsQTH00ijleaQppiO3t8PwIRNvsJhi/eaxp4c661QYRYPdB4cMYRmZ2AlTcV3WLjOG8o
        J6sJDVQAiE1Olv9kL3csyNnzQuaTuS+FafrD/tY5H5CqzmHvtfdYLpdfh+em2X4yhnURPz
        5ejAoq1JTlKnXNijQcsdCfPiy03bMSYE4kCzpnwWRfVG/Mfk2Hk+riC4kyoY7TmIU2N+LQ
        Obyf54E9NIzYmCbgqGo/YlHa5BbfymuLpPosjLnP1Xq4LlkP9Pf7KZEn1+32jwnC7dde87
        1h1r7r//juLKkspYnPZKmaS+OxFef7aCxie9xUjUNLd+JTgheZaaVwb3ueN9UA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651668274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sq/ZfBcYwetCSwS2b1v/F95/fw7AV7LRpm+RRYHMFhE=;
        b=a3BzJFbdP8WFS+URRo5HLJW0zwxmJmB1YnqUzTPzxTZlU1IyBpvvjRlqKVB97dk/CgfJln
        ha3SjskYj8+MG7Cg==
To:     Seth Forshee <sforshee@digitalocean.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] entry/kvm: Make vCPU tasks exit to userspace when a
 livepatch is pending
In-Reply-To: <20220503174934.2641605-1-sforshee@digitalocean.com>
References: <20220503174934.2641605-1-sforshee@digitalocean.com>
Date:   Wed, 04 May 2022 14:44:34 +0200
Message-ID: <87mtfxjwlp.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 03 2022 at 12:49, Seth Forshee wrote:
> diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
> index 6813171afccb..bf79e4cbb5a2 100644
> --- a/include/linux/entry-kvm.h
> +++ b/include/linux/entry-kvm.h
> @@ -17,8 +17,8 @@
>  #endif
>  
>  #define XFER_TO_GUEST_MODE_WORK						\
> -	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL |	\
> -	 _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
> +	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |	\
> +	 _TIF_NOTIFY_SIGNAL | _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)

as the 0-day robot has demonstrated already, this cannot compile on
architectures which do not provide _TIF_PATCH_PENDING...

Something like the below is required.

Thanks,

        tglx
---
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -3,6 +3,7 @@
 #define __LINUX_ENTRYCOMMON_H
 
 #include <linux/static_call_types.h>
+#include <linux/entry-defs.h>
 #include <linux/ptrace.h>
 #include <linux/syscalls.h>
 #include <linux/seccomp.h>
@@ -11,18 +12,6 @@
 #include <asm/entry-common.h>
 
 /*
- * Define dummy _TIF work flags if not defined by the architecture or for
- * disabled functionality.
- */
-#ifndef _TIF_PATCH_PENDING
-# define _TIF_PATCH_PENDING		(0)
-#endif
-
-#ifndef _TIF_UPROBE
-# define _TIF_UPROBE			(0)
-#endif
-
-/*
  * SYSCALL_WORK flags handled in syscall_enter_from_user_mode()
  */
 #ifndef ARCH_SYSCALL_WORK_ENTER
--- /dev/null
+++ b/include/linux/entry-defs.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_ENTRYDEFS_H
+#define __LINUX_ENTRYDEFS_H
+
+#include <linux/thread_info.h>
+
+/*
+ * Define dummy _TIF work flags if not defined by the architecture or for
+ * disabled functionality.
+ */
+#ifndef _TIF_PATCH_PENDING
+# define _TIF_PATCH_PENDING		(0)
+#endif
+
+#ifndef _TIF_UPROBE
+# define _TIF_UPROBE			(0)
+#endif
+
+#endif
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -4,6 +4,7 @@
 
 #include <linux/static_call_types.h>
 #include <linux/resume_user_mode.h>
+#include <linux/entry-defs.h>
 #include <linux/syscalls.h>
 #include <linux/seccomp.h>
 #include <linux/sched.h>
