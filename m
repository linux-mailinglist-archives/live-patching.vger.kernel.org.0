Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BBF193BC5
	for <lists+live-patching@lfdr.de>; Thu, 26 Mar 2020 10:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgCZJ0I (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Mar 2020 05:26:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:45810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727729AbgCZJ0H (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Mar 2020 05:26:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C6AE8AC5F;
        Thu, 26 Mar 2020 09:26:05 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com
Cc:     x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz, andrew.cooper3@citrix.com, jbeulich@suse.com,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v3 0/2] x86/xen: Make idle tasks reliable
Date:   Thu, 26 Mar 2020 10:26:01 +0100
Message-Id: <20200326092603.7230-1-mbenes@suse.cz>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The unwinder reports idle tasks' stack on XEN PV as unreliable which
complicates things for at least live patching. The two patches in the
series try to amend that by using similar approach as non-XEN x86 does.

v2->v3:
- change prototype of asm_cpu_bringup_and_idle()
- replace %_ASM_SP with %rsp and %esp respectively
- fix build for !CONFIG_XEN_PV_SMP

v1->v2:
- call instruction used instead of push+jmp
- initial_stack used directly

v1 https://lore.kernel.org/live-patching/20200312142007.11488-1-mbenes@suse.cz/
v2 https://lore.kernel.org/live-patching/20200319095606.23627-1-mbenes@suse.cz/

Miroslav Benes (2):
  x86/xen: Make the boot CPU idle task reliable
  x86/xen: Make the secondary CPU idle tasks reliable

 arch/x86/xen/smp_pv.c   |  3 ++-
 arch/x86/xen/xen-head.S | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

-- 
2.25.1

