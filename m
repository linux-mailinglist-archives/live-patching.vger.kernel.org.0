Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B4D1832B7
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2020 15:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbgCLOUS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Mar 2020 10:20:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:58356 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727340AbgCLOUM (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Mar 2020 10:20:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3CAA6B2F1;
        Thu, 12 Mar 2020 14:20:10 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com
Cc:     x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH 1/2] x86/xen: Make the boot CPU idle task reliable
Date:   Thu, 12 Mar 2020 15:20:06 +0100
Message-Id: <20200312142007.11488-2-mbenes@suse.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200312142007.11488-1-mbenes@suse.cz>
References: <20200312142007.11488-1-mbenes@suse.cz>
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
startup_xen() and storing the return address before the jump.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/x86/xen/xen-head.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 1d0cee3163e4..642f346bfe02 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -35,7 +35,7 @@ SYM_CODE_START(startup_xen)
 	rep __ASM_SIZE(stos)
 
 	mov %_ASM_SI, xen_start_info
-	mov $init_thread_union+THREAD_SIZE, %_ASM_SP
+	mov $init_thread_union+THREAD_SIZE-SIZEOF_PTREGS, %_ASM_SP
 
 #ifdef CONFIG_X86_64
 	/* Set up %gs.
@@ -51,7 +51,9 @@ SYM_CODE_START(startup_xen)
 	wrmsr
 #endif
 
+	push $1f
 	jmp xen_start_kernel
+1:
 SYM_CODE_END(startup_xen)
 	__FINIT
 #endif
-- 
2.25.1

