Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2539543E0E1
	for <lists+live-patching@lfdr.de>; Thu, 28 Oct 2021 14:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhJ1M0u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Oct 2021 08:26:50 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:54171 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhJ1M0r (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Oct 2021 08:26:47 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Hg4Vm6B4Xz9sSg;
        Thu, 28 Oct 2021 14:24:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LcTfRu4VdTXV; Thu, 28 Oct 2021 14:24:16 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Hg4Vl5Ffdz9sSx;
        Thu, 28 Oct 2021 14:24:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9DD228B763;
        Thu, 28 Oct 2021 14:24:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id W7VTTWHSEaOY; Thu, 28 Oct 2021 14:24:15 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.232.214])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 30A6F8B78D;
        Thu, 28 Oct 2021 14:24:15 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.16.1/8.16.1) with ESMTPS id 19SCO6vZ194383
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 14:24:06 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.16.1/8.16.1/Submit) id 19SCO50i194382;
        Thu, 28 Oct 2021 14:24:05 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        live-patching@vger.kernel.org
Subject: [PATCH v1 0/5] Implement livepatch on PPC32
Date:   Thu, 28 Oct 2021 14:24:00 +0200
Message-Id: <cover.1635423081.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1635423843; l=817; s=20211009; h=from:subject:message-id; bh=Kpfi8u6BYe1lB+LwyFewbJpGh40Ydk0cPIy4xtozaU4=; b=f0o8yLCQzjOdho2S2LrY3195nnMIi9FpAKMSzkL2Gm0p8wQjfmelld6x0/1vGqOLSZgLUIiZ9oyk s0Ym1Z0mC4KouO6TCSH6KOCQ42eska6ueLMRxnJXjoQfjyXfnjpM
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

This series implements livepatch on PPC32.

This is largely copied from what's done on PPC64.

Christophe Leroy (5):
  livepatch: Fix build failure on 32 bits processors
  powerpc/ftrace: No need to read LR from stack in _mcount()
  powerpc/ftrace: Add module_trampoline_target() for PPC32
  powerpc/ftrace: Activate HAVE_DYNAMIC_FTRACE_WITH_REGS on PPC32
  powerpc/ftrace: Add support for livepatch to PPC32

 arch/powerpc/Kconfig                  |   2 +-
 arch/powerpc/include/asm/livepatch.h  |   4 +-
 arch/powerpc/kernel/module_32.c       |  33 +++++
 arch/powerpc/kernel/trace/ftrace.c    |  53 +++-----
 arch/powerpc/kernel/trace/ftrace_32.S | 187 ++++++++++++++++++++++++--
 kernel/livepatch/core.c               |   4 +-
 6 files changed, 230 insertions(+), 53 deletions(-)

-- 
2.31.1

