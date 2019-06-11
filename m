Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239D23CDC2
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2019 15:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391443AbfFKN44 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 11 Jun 2019 09:56:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:39986 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391439AbfFKN4y (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 11 Jun 2019 09:56:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2E53AEBB;
        Tue, 11 Jun 2019 13:56:52 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [RFC 2/5] livepatch: Basic API to track system state changes
Date:   Tue, 11 Jun 2019 15:56:24 +0200
Message-Id: <20190611135627.15556-3-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190611135627.15556-1-pmladek@suse.com>
References: <20190611135627.15556-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

This is another step how to help maintaining more livepatches.

One big help was the atomic replace and cumulative livepatches. These
livepatches replaces the already installed ones. Therefore it should
be enough when each cumulative livepatch is consistent.

The problems might come with shadow variables and callbacks. They might
change the system behavior or state so that it is not longer safe to
go back and use an older livepatch or the original kernel code. Also
any new livepatch must be able to detect what changes have already been
done by the already installed livepatches.

This is where the livepatch system state tracking gets useful. It
allows to:

  - find whether a system state has already been modified by
    previous livepatches

  - store data needed to manipulate and restore the system state

The information about the manipulated system states is stored in an
array of struct klp_state. There are two functions that allow
to find this structure for a given struct klp_patch or for
already installed (replaced) livepatches.

The dependencies are going to be solved by a version field added later.
The only important information is that it will be allowed to modify
the same state by more non-cumulative livepatches. It is the same logic
as that it is allowed to modify the same function several times.
The livepatch author is responsible for preventing incompatible
changes.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h | 15 +++++++++
 kernel/livepatch/Makefile |  2 +-
 kernel/livepatch/state.c  | 83 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 1 deletion(-)
 create mode 100644 kernel/livepatch/state.c

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index eeba421cc671..591abdee30d7 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -132,10 +132,21 @@ struct klp_object {
 	bool patched;
 };
 
+/**
+ * struct klp_state - state of the system modified by the livepatch
+ * @id:		system state identifier (non zero)
+ * @data:	custom data
+ */
+struct klp_state {
+	int id;
+	void *data;
+};
+
 /**
  * struct klp_patch - patch structure for live patching
  * @mod:	reference to the live patch module
  * @objs:	object entries for kernel objects to be patched
+ * @states:	system states that can get modified
  * @replace:	replace all actively used patches
  * @list:	list node for global list of actively used patches
  * @kobj:	kobject for sysfs resources
@@ -150,6 +161,7 @@ struct klp_patch {
 	/* external */
 	struct module *mod;
 	struct klp_object *objs;
+	struct klp_state *states;
 	bool replace;
 
 	/* internal */
@@ -220,6 +232,9 @@ void *klp_shadow_get_or_alloc(void *obj, unsigned long id,
 void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor);
 void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
 
+struct klp_state *klp_get_state(struct klp_patch *patch, int id);
+struct klp_state *klp_get_prev_state(int id);
+
 #else /* !CONFIG_LIVEPATCH */
 
 static inline int klp_module_coming(struct module *mod) { return 0; }
diff --git a/kernel/livepatch/Makefile b/kernel/livepatch/Makefile
index cf9b5bcdb952..cf03d4bdfc66 100644
--- a/kernel/livepatch/Makefile
+++ b/kernel/livepatch/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_LIVEPATCH) += livepatch.o
 
-livepatch-objs := core.o patch.o shadow.o transition.o
+livepatch-objs := core.o patch.o shadow.o state.o transition.o
diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
new file mode 100644
index 000000000000..f8822b71f96e
--- /dev/null
+++ b/kernel/livepatch/state.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * system_state.c - State of the system modified by livepatches
+ *
+ * Copyright (C) 2019 SUSE
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/livepatch.h>
+#include "core.h"
+#include "transition.h"
+
+#define klp_for_each_state(patch, state)		\
+	for (state = patch->states; state && state->id; state++)
+
+/**
+ * klp_get_state() - get information about system state modified by
+ *	the given patch
+ * @patch:	livepatch that modifies the given system state
+ * @id:		custom identifier of the modified system state
+ *
+ * Checks whether the given patch modifies to given system state.
+ *
+ * The function can be called either from pre/post (un)patch
+ * callbacks or from the kernel code added by the livepatch.
+ *
+ * Return: pointer to struct klp_state when found, otherwise NULL.
+ */
+struct klp_state *klp_get_state(struct klp_patch *patch, int id)
+{
+	struct klp_state *state;
+
+	klp_for_each_state(patch, state) {
+		if (state->id == id)
+			return state;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(klp_get_state);
+
+/**
+ * klp_get_prev_state() - get information about system state modified by
+ *	the already installed livepatches
+ * @id:		custom identifier of the modified system state
+ *
+ * Checks whether already installed livepatches modify the given
+ * system state.
+ *
+ * The same system state can be modified by more non-cumulative
+ * livepatches. It is expected that the latest livepatch has
+ * the most up-to-date information.
+ *
+ * The function can be called only during transition when a new
+ * livepatch is being enabled or when such a transition is reverted.
+ * It is typically called only from from pre/post (un)patch
+ * callbacks.
+ *
+ * Return: pointer to the latest struct klp_state from already
+ *	installed livepatches, NULL when not found.
+ */
+struct klp_state *klp_get_prev_state(int id)
+{
+	struct klp_patch *patch;
+	struct klp_state *state, *last_state = NULL;
+
+	if (WARN_ON_ONCE(!klp_transition_patch))
+		return NULL;
+
+	klp_for_each_patch(patch) {
+		if (patch == klp_transition_patch)
+			goto out;
+
+		state = klp_get_state(patch, id);
+		if (state)
+			last_state = state;
+	}
+
+out:
+	return last_state;
+}
+EXPORT_SYMBOL_GPL(klp_get_prev_state);
-- 
2.16.4

