Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19FA6E1DF
	for <lists+live-patching@lfdr.de>; Fri, 19 Jul 2019 09:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfGSHlG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Jul 2019 03:41:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:50082 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbfGSHlG (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Jul 2019 03:41:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA1CDAC68;
        Fri, 19 Jul 2019 07:41:04 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 4/5] livepatch: Documentation of the new API for tracking system state changes
Date:   Fri, 19 Jul 2019 09:40:33 +0200
Message-Id: <20190719074034.29761-5-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190719074034.29761-1-pmladek@suse.com>
References: <20190719074034.29761-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Documentation explaining the motivation, capabilities, and usage
of the new API for tracking system state changes.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 Documentation/livepatch/index.rst        |   1 +
 Documentation/livepatch/system-state.rst | 167 +++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+)
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
index 000000000000..f04ef2b9089a
--- /dev/null
+++ b/Documentation/livepatch/system-state.rst
@@ -0,0 +1,167 @@
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
+2. Livepatch compatibility
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
+
+3. Supported scenarios
+======================
+
+Livepatches have their life-cycle and the same is true for the system
+state changes. Every compatible livepatch has to support the following
+scenarios:
+
+  - Modify the system state when the livepatch gets enabled and the state
+    has not been already modified by a livepatches that are being
+    replaced.
+
+  - Take over or update the system state modification when is has already
+    been done by a livepatch that is being replaced.
+
+  - Restore the original state when the livepatch is disabled.
+
+  - Restore the previous state when the transition is reverted.
+    It might be the orignal system state or the state modification
+    done by livepatches that were being replaced.
+
+  - Remove any already made changes when error occurs and the livepatch
+    cannot get enabled.
+
+4. Expected usage
+=================
+
+System states are usually modified by livepatch callbacks. The expected
+role of each callback is as follows:
+
+*pre_patch()*
+
+  - Allocate *state->data* when necessary. The allocation might fail
+    and *pre_patch()* is the only callback that could stop loading
+    of the livepatch. The allocation is not needed when the data
+    are already provided by previously installed livepatches.
+
+  - Do any other preparatory action that is needed by
+    the new code even before the transition gets finished.
+    For example, initialize *state->data*.
+
+    The system state itself is typically modified in *post_patch()*
+    when the entire system is able to handle it.
+
+  - Clean up its own mess in case of error. It might be done by a custom
+    code or by calling *post_unpatch()* explicitly.
+
+*post_patch()*
+
+  - Copy *state->data* from the previous livepatch when they are
+    compatible.
+
+  - Do the actual system state modification. Eventually allow
+    the new code to use it.
+
+  - Make sure that *state->data* has all necessary information.
+
+  - Free *state->data* from replaces livepatches when they are
+    not longer needed.
+
+*pre_unpatch()*
+
+  - Prevent the code, added by the livepatch, relying on the system
+    state change.
+
+  - Revert the system state modification..
+
+*post_unpatch()*
+
+  - Distinguish transition reverse and livepatch disabling by
+    checking *klp_get_prev_state()*.
+
+  - In case of transition reverse, restore the previous system
+    state. It might mean doing nothing.
+
+  - Remove any not longer needed setting or data.
+
+.. note::
+
+   *pre_unpatch()* typically does symmetric operations to *post_patch()*.
+   Except that it is called only when the livepatch is being disabled.
+   Therefore it does not need to care about any previously installed
+   livepatch.
+
+   *post_unpatch()* typically does symmetric operations to *pre_patch()*.
+   It might be called also during the transition reverse. Therefore it
+   has to handle the state of the previously installed livepatches.
-- 
2.16.4

