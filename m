Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E714C2200B2
	for <lists+live-patching@lfdr.de>; Wed, 15 Jul 2020 00:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgGNWc6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Jul 2020 18:32:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:16030 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgGNWc6 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Jul 2020 18:32:58 -0400
IronPort-SDR: 9I80EAYwOfu6kKh/k+qX2gZBbPWBhtLM6LFV4Nz+JFbmUP63LraV3zaHewylgOLvvJKu7N07Xj
 PuqZwIffLFIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="146547481"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="146547481"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 15:32:54 -0700
IronPort-SDR: Q1zB95eOaThLhwVPy2NGGLqkvn4J8UgIcPgQJjwzOZjaMbkRL4QNjUH5qwYcGLPa0vcdiO6hPl
 Jazij6bo7xKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="486037143"
Received: from pipper-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.46.185])
  by fmsmga005.fm.intel.com with ESMTP; 14 Jul 2020 15:32:43 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     x86@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jkosina@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        live-patching@vger.kernel.org (open list:LIVE PATCHING),
        Marco Elver <elver@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Nayna Jain <nayna@linux.ibm.com>,
        Omar Sandoval <osandov@fb.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v3 0/3] kprobes: Remove MODULES dependency
Date:   Wed, 15 Jul 2020 01:32:26 +0300
Message-Id: <20200714223239.1543716-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Remove MODULES dependency and migrate from module_alloc to the new
text_alloc() API Right now one has to compile LKM support only to enable
kprobes.  With this change applied, it is somewhat easier to create
custom test kernel's with a proper debugging capabilities, thus making
Linux more developer friendly.

Jarkko Sakkinen (3):
  kprobes: Add text_alloc() and text_free()
  module: Add lock_modules() and unlock_modules()
  kprobes: Flag out CONFIG_MODULES dependent code

 arch/Kconfig                |  2 +-
 arch/x86/Kconfig            |  3 ++
 arch/x86/kernel/Makefile    |  1 +
 arch/x86/kernel/module.c    | 49 -------------------------
 arch/x86/kernel/text.c      | 71 +++++++++++++++++++++++++++++++++++++
 include/linux/module.h      | 29 +++++++++++----
 include/linux/text.h        | 17 +++++++++
 kernel/kprobes.c            | 22 ++++++++++--
 kernel/livepatch/core.c     |  8 ++---
 kernel/module.c             | 70 ++++++++++++++++++++----------------
 kernel/trace/trace_kprobe.c | 20 +++++++++--
 11 files changed, 196 insertions(+), 96 deletions(-)
 create mode 100644 arch/x86/kernel/text.c
 create mode 100644 include/linux/text.h

-- 
2.25.1

