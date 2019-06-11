Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE773CDBD
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2019 15:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391496AbfFKN5A (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 11 Jun 2019 09:57:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:40026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391465AbfFKN46 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 11 Jun 2019 09:56:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F24F7AF0A;
        Tue, 11 Jun 2019 13:56:55 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [RFC 4/5] livepatch: Documentation of the new API for tracking system state changes
Date:   Tue, 11 Jun 2019 15:56:26 +0200
Message-Id: <20190611135627.15556-5-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190611135627.15556-1-pmladek@suse.com>
References: <20190611135627.15556-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Documentation explaining the motivation, capabilities, and usage
of the new API for tracking system state changes.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 Documentation/livepatch/index.rst        |  1 +
 Documentation/livepatch/system-state.rst | 80 ++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)
 create mode 100644 Documentation/livepatch/system-state.rst

diff --git a/Documentation/livepatch/index.rst b/Documentation/livepatch/index.rst
index edd291d51847..94bbbc2c8993 100644
--- a/Documentation/livepatch/index.rst
+++ b/Documentation/livepatch/index.rst
@@ -9,6 +9,7 @@ Kernel Livepatching
 
     livepatch
     callbacks
+    system-state
     cumulative-patches
     module-elf-format
     shadow-vars
diff --git a/Documentation/livepatch/system-state.rst b/Documentation/livepatch/system-state.rst
new file mode 100644
index 000000000000..3a35073a0b80
--- /dev/null
+++ b/Documentation/livepatch/system-state.rst
@@ -0,0 +1,80 @@
+====================
+System State Changes
+====================
+
+Some users are really reluctant to reboot a system. This brings the need
+to provide more livepatches and maintain some compatibility between them.
+
+Maintaining more livepatches is much easier with cumulative livepatches.
+Each new livepatch completely replaces any older one. It can keep,
+add, and even remove fixes. And it is typically safe to replace any version
+of the livepatch with any other one thanks to the atomic replace feature.
+
+The problems might come with shadow variables and callbacks. They might
+change the system behavior or state so that it is not longer safe to
+go back and use an older livepatch or the original kernel code. Also
+any new livepatch must be able to detect what changes have already been
+done by the already installed livepatches.
+
+This is where the livepatch system state tracking gets useful. It
+allows to:
+
+  - store data needed to manipulate and restore the system state
+
+  - define compatibility between livepatches using a change id
+    and version
+
+
+1. Livepatch system state API
+=============================
+
+The state of the system might get modified either by several livepatch callbacks
+or by the newly used code. Also it must be possible to find changes done by
+already installed livepatches.
+
+Each modified state is described by struct klp_state, see
+include/linux/livepatch.h.
+
+Each livepatch defines an array of struct klp_states. They mention
+all states that the livepatch modifies.
+
+The livepatch author must define the following two fields for each
+struct klp_state:
+
+  - *id*
+
+    - Non-zero number used to identify the affected system state.
+
+  - *version*
+
+    - Number describing the variant of the system state change that
+      is supported by the given livepatch.
+
+The state can be manipulated using two functions:
+
+  - *klp_get_state(patch, id)*
+
+    - Get struct klp_state associated with the given livepatch
+      and state id.
+
+  - *klp_get_prev_state(id)*
+
+    - Get struct klp_state associated with the given feature id and
+      already installed livepatches.
+
+1. Livepatch compatibility
+==========================
+
+The system state version is used to prevent loading incompatible livepatches.
+The check is done when the livepatch is enabled. The rules are:
+
+  - Any completely new system state modification is allowed.
+
+  - System state modifications with the same or higher version are allowed
+    for already modified system states.
+
+  - Cumulative livepatches must handle all system state modifications from
+    already installed livepatches.
+
+  - Non-cumulative livepatches are allowed to touch already modified
+    system states.
-- 
2.16.4

