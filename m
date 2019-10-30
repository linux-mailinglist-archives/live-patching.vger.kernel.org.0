Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012CEE9F67
	for <lists+live-patching@lfdr.de>; Wed, 30 Oct 2019 16:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfJ3Pn1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 30 Oct 2019 11:43:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:35702 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727478AbfJ3Pn1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 30 Oct 2019 11:43:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B84E8B46C;
        Wed, 30 Oct 2019 15:43:24 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 3/5] livepatch: Allow to distinguish different version of system state changes
Date:   Wed, 30 Oct 2019 16:43:11 +0100
Message-Id: <20191030154313.13263-4-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191030154313.13263-1-pmladek@suse.com>
References: <20191030154313.13263-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The atomic replace runs pre/post (un)install callbacks only from the new
livepatch. There are several reasons for this:

  + Simplicity: clear ordering of operations, no interactions between
	old and new callbacks.

  + Reliability: only new livepatch knows what changes can already be made
	by older livepatches and how to take over the state.

  + Testing: the atomic replace can be properly tested only when a newer
	livepatch is available. It might be too late to fix unwanted effect
	of callbacks from older	livepatches.

It might happen that an older change is not enough and the same system
state has to be modified another way. Different changes need to get
distinguished by a version number added to struct klp_state.

The version can also be used to prevent loading incompatible livepatches.
The check is done when the livepatch is enabled. The rules are:

  + Any completely new system state modification is allowed.

  + System state modifications with the same or higher version are allowed
    for already modified system states.

  + Cumulative livepatches must handle all system state modifications from
    already installed livepatches.

  + Non-cumulative livepatches are allowed to touch already modified
    system states.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
---
 include/linux/livepatch.h |  2 ++
 kernel/livepatch/core.c   |  8 ++++++++
 kernel/livepatch/state.c  | 36 ++++++++++++++++++++++++++++++++++++
 kernel/livepatch/state.h  |  9 +++++++++
 4 files changed, 55 insertions(+)
 create mode 100644 kernel/livepatch/state.h

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 726947338fd5..e894e74905f3 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -133,10 +133,12 @@ struct klp_object {
 /**
  * struct klp_state - state of the system modified by the livepatch
  * @id:		system state identifier (non-zero)
+ * @version:	version of the change
  * @data:	custom data
  */
 struct klp_state {
 	unsigned long id;
+	unsigned int version;
 	void *data;
 };
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 1e1d87ead55c..c3512e7e0801 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -22,6 +22,7 @@
 #include <asm/cacheflush.h>
 #include "core.h"
 #include "patch.h"
+#include "state.h"
 #include "transition.h"
 
 /*
@@ -1009,6 +1010,13 @@ int klp_enable_patch(struct klp_patch *patch)
 
 	mutex_lock(&klp_mutex);
 
+	if (!klp_is_patch_compatible(patch)) {
+		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
+			patch->mod->name);
+		mutex_unlock(&klp_mutex);
+		return -EINVAL;
+	}
+
 	ret = klp_init_patch_early(patch);
 	if (ret) {
 		mutex_unlock(&klp_mutex);
diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
index 6ab15b642c0a..7ee19476de9d 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -9,6 +9,7 @@
 
 #include <linux/livepatch.h>
 #include "core.h"
+#include "state.h"
 #include "transition.h"
 
 #define klp_for_each_state(patch, state)		\
@@ -81,3 +82,38 @@ struct klp_state *klp_get_prev_state(unsigned long id)
 	return last_state;
 }
 EXPORT_SYMBOL_GPL(klp_get_prev_state);
+
+/* Check if the patch is able to deal with the existing system state. */
+static bool klp_is_state_compatible(struct klp_patch *patch,
+				    struct klp_state *old_state)
+{
+	struct klp_state *state;
+
+	state = klp_get_state(patch, old_state->id);
+
+	/* A cumulative livepatch must handle all already modified states. */
+	if (!state)
+		return !patch->replace;
+
+	return state->version >= old_state->version;
+}
+
+/*
+ * Check that the new livepatch will not break the existing system states.
+ * Cumulative patches must handle all already modified states.
+ * Non-cumulative patches can touch already modified states.
+ */
+bool klp_is_patch_compatible(struct klp_patch *patch)
+{
+	struct klp_patch *old_patch;
+	struct klp_state *old_state;
+
+	klp_for_each_patch(old_patch) {
+		klp_for_each_state(old_patch, old_state) {
+			if (!klp_is_state_compatible(patch, old_state))
+				return false;
+		}
+	}
+
+	return true;
+}
diff --git a/kernel/livepatch/state.h b/kernel/livepatch/state.h
new file mode 100644
index 000000000000..49d9c16e8762
--- /dev/null
+++ b/kernel/livepatch/state.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LIVEPATCH_STATE_H
+#define _LIVEPATCH_STATE_H
+
+#include <linux/livepatch.h>
+
+bool klp_is_patch_compatible(struct klp_patch *patch);
+
+#endif /* _LIVEPATCH_STATE_H */
-- 
2.16.4

