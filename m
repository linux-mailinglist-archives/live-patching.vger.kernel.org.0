Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341F418B09D
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2020 10:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCSJ4M (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Mar 2020 05:56:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:35468 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbgCSJ4M (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Mar 2020 05:56:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C6909AE59;
        Thu, 19 Mar 2020 09:56:10 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com
Cc:     x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz, andrew.cooper3@citrix.com,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v2 1/2] x86/xen: Make the boot CPU idle task reliable
Date:   Thu, 19 Mar 2020 10:56:05 +0100
Message-Id: <20200319095606.23627-2-mbenes@suse.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200319095606.23627-1-mbenes@suse.cz>
References: <20200319095606.23627-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The unwinder reports the boot CPU idle task's stack on XEN PV as
unreliable, which affects at least live patching. There are two reasons
for this. First, the task does not follow the x86 convention that its
stack starts at the offset right below saved pt_regs. It allows the
unwinder to easily detect the end of the stack and verify it. Second,
startup_xen() function does not store the return address before jumping
to xen_start_kernel() which confuses the unwinder.

Amend both issues by moving the starting point of initial stack in
startup_xen() and storing the return address before the jump, which is
exactly what call instruction does.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/x86/xen/xen-head.S | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 1d0cee3163e4..edc776af0e0a 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -35,7 +35,11 @@ SYM_CODE_START(startup_xen)
 	rep __ASM_SIZE(stos)
 
 	mov %_ASM_SI, xen_start_info
-	mov $init_thread_union+THREAD_SIZE, %_ASM_SP
+#ifdef CONFIG_X86_64
+	mov initial_stack(%rip), %_ASM_SP
+#else
+	mov pa(initial_stack), %_ASM_SP
+#endif
 
 #ifdef CONFIG_X86_64
 	/* Set up %gs.
@@ -51,7 +55,7 @@ SYM_CODE_START(startup_xen)
 	wrmsr
 #endif
 
-	jmp xen_start_kernel
+	call xen_start_kernel
 SYM_CODE_END(startup_xen)
 	__FINIT
 #endif
-- 
2.25.1

