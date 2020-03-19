Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC3618B098
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2020 10:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgCSJ4M (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Mar 2020 05:56:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:35442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726895AbgCSJ4M (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Mar 2020 05:56:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3D1FEAD9A;
        Thu, 19 Mar 2020 09:56:10 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com
Cc:     x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz, andrew.cooper3@citrix.com,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v2 0/2] x86/xen: Make idle tasks reliable
Date:   Thu, 19 Mar 2020 10:56:04 +0100
Message-Id: <20200319095606.23627-1-mbenes@suse.cz>
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

v1->v2:
- call instruction used instead of push+jmp
- initial_stack used directly

There is a thing which makes me slightly uncomfortable. s/jmp/call/
means that, theoretically, the called function could return. GCC then
generates not so nice code and there is
asm_cpu_bringup_and_idle+0x5/0x1000 symbol last on the stack due to
alignment in asm/x86/xen/xen-head.S which could be confusing.
Practically it is all fine, because neither xen_start_kernel(), nor
cpu_bringup_and_idle() return (there is unbounded loop in
cpu_startup_entry() around do_idle()). __noreturn annotation of these
functions did not help.

So I don't think it is really a problem, but one may wonder.

Miroslav Benes (2):
  x86/xen: Make the boot CPU idle task reliable
  x86/xen: Make the secondary CPU idle tasks reliable

 arch/x86/xen/smp_pv.c   |  3 ++-
 arch/x86/xen/xen-head.S | 16 ++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

-- 
2.25.1

