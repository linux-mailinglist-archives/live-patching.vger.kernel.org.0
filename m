Return-Path: <live-patching+bounces-32-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF357E7DF7
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 18:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A04811C20949
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 17:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF371DDFA;
	Fri, 10 Nov 2023 17:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fLXFEINx"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A4E63B4
	for <live-patching@vger.kernel.org>; Fri, 10 Nov 2023 17:05:08 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CC542C3C;
	Fri, 10 Nov 2023 09:05:06 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 49B871F8BB;
	Fri, 10 Nov 2023 17:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1699635905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ojdUKEsAIrqTJ0c75S6e7/nz7HiBRgbaDZ3Fw43TrDk=;
	b=fLXFEINxO320OU0b8WGezlJG9FPN24JvmElIR1mJJ+X3NyVAVy7SbZHp8vlGMFQ9h20HHC
	GArKtx+0n1PQJl+3kVWIzfW6+ovagm/qyoK0hvnI4arWW/HKgSqvsTGLLYVc6Gtta0bcqc
	8Ng6v+kTDfvGBDuSkdQ7gWck7BRRLFo=
Received: from alley.suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
	by relay2.suse.de (Postfix) with ESMTP id DD21D2C24F;
	Fri, 10 Nov 2023 17:05:04 +0000 (UTC)
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [POC 1/7] livepatch: Add callbacks for introducing and removing states
Date: Fri, 10 Nov 2023 18:04:22 +0100
Message-Id: <20231110170428.6664-2-pmladek@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231110170428.6664-1-pmladek@suse.com>
References: <20231110170428.6664-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The basic livepatch functionality is to redirect problematic functions
to a fixed or improved variants. In addition, there are two features
helping with more problematic situations:

  + pre_patch(), post_patch(), pre_unpatch(), post_unpatch() callbacks
    might be called before and after the respective transitions.
    For example, post_patch() callback might enable some functionality
    at the end of the transition when the entire system is using
    the new code.

  + Shadow variables allow to add new items into structures or other
    data objects.

The practice has shown that these features were hard to use with the atomic
replace feature. The new livepatch usually just adds more fixes. But it
might also remove problematic ones.

Originally, any version of the livepatch was allowed to replace any older
or newer version of the patch. It was not clear how to handle the extra
features. The new patch did not know whether to run the callbacks or
if the changes were already done by the current livepatch. Or if it has
to revert some changes or free shadow variables whey they would not longer
be supported.

It was even more complicated because only the callbacks from the newly
installed livepatch were called. It means that older livepatch might
not be able to revert changes supported only by newer livepatches.

The above problems were supposed to be solved by adding livepatch
states. Each livepatch might define which states are supported. The states
are versioned. The livepatch core checks if the newly installed livepatch
is able to handle all states used by the currently installed livepatch.

Though the practice has shown that the states API was not easy to use
either. It was not well connected with the callbacks and shadow variables.
The states are per-patch. The callbacks are per-object. The livepatch
does not know about the supported shadow variables at all.

As a first step, new per-state callbacks are introduced:

  + "setup" is called before the livepatch is applied but only when
      the state is new.

      It might be used to allocate some memory. Or it might
      check if the state change is safe on the running system.

      If it fails, the patch will not be enabled.

  + "enable" is called after the livepatch is applied but only when
      the state is new.

      It might be used to enable using some functionality provided by
      the livepatch after the entire system is livepatched.

  + "disable" is called before the livepatch is disabled or replaced.

      When replacing, the callback is called only when the new livepatch
      does not support the related state. And it uses the implementation
      from the to-be-replaced livepatch. The to-be-replaced livepatch
      needed the callback to allow disabling the livepatch anyway.
      The new livepatch does not need to know anything about the state.

      It might be used to disable using some functionality which will
      not longer be supported after the livepatch gets disabled.

  + "release" is called after the livepatch was disabled or replaced.
     There are the same rules for replacement as for "disable" callback.

      It might be used for freeing some memory or unused shadow variables.

These callbacks are going to replace the existing ones. It would cause
some changes:

   + The new callbacks are not called when a livepatched object is
     loaded or removed later.

     The practice shows that per-object callbacks are not worth
     supporting. In a rare case, when a per-object callback is needed.
     the livepatch might register a custom module notifier.

   + The new callbacks are called only when the state is introduced
     or removed. It does not handle the situation when the newly
     installed livepatch continues using an existing state.

     The practice shows that this is exactly what is needed. In the rare
     case when this is not enough, an extra takeover might be done in
     the module->init() callback.

The per-state callbacks are called in similar code paths as the per-object
ones. Especially, the ordering against the other operations is the same.
Though, there are some obvious and less obvious changes:

  + The per-state callbacks are called for the entire patch instead
    of loaded object. It means that they called outside the for-each-object
    cycle.

  + The per-state callbacks are called when a state is introduced
    or obsoleted. Both variants might happen when the atomic replace
    is used.

  + In __klp_enable_patch(), the per-state callbacks are called before
    the smp_wmb() while the per-object ones are called later.

    The new location makes more sense. The setup of the state should
    be ready before processes start being transferred.

    The per-object callbacks were called after the barrier. They were
    using and already existing for-cycle. And nobody did mind about
    the ordering.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h     |  28 ++++++++
 kernel/livepatch/core.c       |  19 +++++-
 kernel/livepatch/state.c      | 118 ++++++++++++++++++++++++++++++++++
 kernel/livepatch/state.h      |   9 +++
 kernel/livepatch/transition.c |   8 +++
 5 files changed, 180 insertions(+), 2 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 9b9b38e89563..c2a39e5f5b66 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -129,15 +129,43 @@ struct klp_object {
 	bool patched;
 };
 
+struct klp_patch;
+struct klp_state;
+
+/**
+ * struct klp_state_callbacks - callbacks manipulating the state
+ * @setup:	executed before code patching when the state is added
+ * @enable:	executed after code patching when the state is added
+ * @disable:	executed before code unpatching when the state is removed
+ * @release:	executed after code unpatching when the state is removed
+ * @setup_succeeded: internal state used by a rollback on error
+ *
+ * All callbacks are optional.
+ *
+ * @setup callback returns 0 on success and an error code otherwise.
+ * Any error prevents enabling the livepatch. @disable() callbacks
+ * are then called to rollback @enable callbacks which has already
+ * succeeded before.
+ */
+struct klp_state_callbacks {
+	int (*setup)(struct klp_patch *patch, struct klp_state *state);
+	void (*enable)(struct klp_patch *patch, struct klp_state *state);
+	void (*disable)(struct klp_patch *patch, struct klp_state *state);
+	void (*release)(struct klp_patch *patch, struct klp_state *state);
+	bool setup_succeeded;
+};
+
 /**
  * struct klp_state - state of the system modified by the livepatch
  * @id:		system state identifier (non-zero)
  * @version:	version of the change
+ * @callbacks:	optional callbacks used when introducing or removing the state
  * @data:	custom data
  */
 struct klp_state {
 	unsigned long id;
 	unsigned int version;
+	struct klp_state_callbacks callbacks;
 	void *data;
 };
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 61328328c474..a4a3fe7907ad 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -975,6 +975,8 @@ static int __klp_disable_patch(struct klp_patch *patch)
 
 	klp_init_transition(patch, KLP_UNPATCHED);
 
+	klp_disable_states(patch);
+
 	klp_for_each_object(patch, obj)
 		if (obj->patched)
 			klp_pre_unpatch_callback(obj);
@@ -1010,6 +1012,13 @@ static int __klp_enable_patch(struct klp_patch *patch)
 
 	klp_init_transition(patch, KLP_PATCHED);
 
+	ret = klp_setup_states(patch);
+	if (ret)
+		goto err;
+
+	if (patch->replace)
+		klp_disable_obsolete_states(patch);
+
 	/*
 	 * Enforce the order of the func->transition writes in
 	 * klp_init_transition() and the ops->func_stack writes in
@@ -1027,14 +1036,14 @@ static int __klp_enable_patch(struct klp_patch *patch)
 		if (ret) {
 			pr_warn("pre-patch callback failed for object '%s'\n",
 				klp_is_module(obj) ? obj->name : "vmlinux");
-			goto err;
+			goto err_states;
 		}
 
 		ret = klp_patch_object(obj);
 		if (ret) {
 			pr_warn("failed to patch object '%s'\n",
 				klp_is_module(obj) ? obj->name : "vmlinux");
-			goto err;
+			goto err_states;
 		}
 	}
 
@@ -1043,6 +1052,12 @@ static int __klp_enable_patch(struct klp_patch *patch)
 	klp_try_complete_transition();
 
 	return 0;
+
+err_states:
+	if (patch->replace)
+		klp_enable_obsolete_states(patch);
+
+	klp_release_states(patch);
 err:
 	pr_warn("failed to enable patch '%s'\n", patch->mod->name);
 
diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
index 2565d039ade0..6693d808106b 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -117,3 +117,121 @@ bool klp_is_patch_compatible(struct klp_patch *patch)
 
 	return true;
 }
+
+bool is_state_in_other_patches(struct klp_patch *patch, struct klp_state *state)
+{
+	struct klp_patch *old_patch;
+	struct klp_state *old_state;
+
+	klp_for_each_patch(old_patch) {
+		if (old_patch == patch)
+			continue;
+
+		klp_for_each_state(old_patch, old_state) {
+			if (old_state->id == state->id)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+int klp_setup_states(struct klp_patch *patch)
+{
+	struct klp_state *state;
+	int err;
+
+	klp_for_each_state(patch, state) {
+		if (!is_state_in_other_patches(patch, state) &&
+		    state->callbacks.setup) {
+
+			err = state->callbacks.setup(patch, state);
+			if (err)
+				goto err;
+		}
+
+		state->callbacks.setup_succeeded = true;
+	}
+
+	return 0;
+
+err:
+	klp_release_states(patch);
+	return err;
+}
+
+void klp_enable_states(struct klp_patch *patch)
+{
+	struct klp_state *state;
+
+	klp_for_each_state(patch, state) {
+		if (is_state_in_other_patches(patch, state))
+			continue;
+
+		if (!state->callbacks.enable)
+			continue;
+
+		state->callbacks.enable(patch, state);
+	}
+}
+
+void klp_disable_states(struct klp_patch *patch)
+{
+	struct klp_state *state;
+
+	klp_for_each_state(patch, state) {
+		if (is_state_in_other_patches(patch, state))
+			continue;
+
+		if (!state->callbacks.disable)
+			continue;
+
+		state->callbacks.disable(patch, state);
+	}
+}
+
+void klp_release_states(struct klp_patch *patch)
+{
+	struct klp_state *state;
+
+	klp_for_each_state(patch, state) {
+		if (is_state_in_other_patches(patch, state))
+			continue;
+
+		if (!state->callbacks.release)
+			continue;
+
+		if (state->callbacks.setup_succeeded)
+			state->callbacks.release(patch, state);
+	}
+}
+
+void klp_enable_obsolete_states(struct klp_patch *patch)
+{
+	struct klp_patch *old_patch;
+
+	klp_for_each_patch(old_patch) {
+		if (old_patch != patch)
+			klp_enable_states(old_patch);
+	}
+}
+
+void klp_disable_obsolete_states(struct klp_patch *patch)
+{
+	struct klp_patch *old_patch;
+
+	klp_for_each_patch(old_patch) {
+		if (old_patch != patch)
+			klp_disable_states(old_patch);
+	}
+}
+
+void klp_release_obsolete_states(struct klp_patch *patch)
+{
+	struct klp_patch *old_patch;
+
+	klp_for_each_patch(old_patch) {
+		if (old_patch != patch)
+			klp_release_states(old_patch);
+	}
+}
diff --git a/kernel/livepatch/state.h b/kernel/livepatch/state.h
index 49d9c16e8762..e9940e7f00dd 100644
--- a/kernel/livepatch/state.h
+++ b/kernel/livepatch/state.h
@@ -5,5 +5,14 @@
 #include <linux/livepatch.h>
 
 bool klp_is_patch_compatible(struct klp_patch *patch);
+int klp_setup_states(struct klp_patch *patch);
+void klp_enable_states(struct klp_patch *patch);
+void klp_disable_states(struct klp_patch *patch);
+void klp_release_states(struct klp_patch *patch);
+
+void klp_enable_obsolete_states(struct klp_patch *patch);
+void klp_disable_obsolete_states(struct klp_patch *patch);
+void klp_release_obsolete_states(struct klp_patch *patch);
+
 
 #endif /* _LIVEPATCH_STATE_H */
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index e54c3d60a904..cfa1ab10feb7 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -12,6 +12,7 @@
 #include <linux/static_call.h>
 #include "core.h"
 #include "patch.h"
+#include "state.h"
 #include "transition.h"
 
 #define MAX_STACK_ENTRIES  100
@@ -101,6 +102,7 @@ static void klp_complete_transition(void)
 	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
 		klp_unpatch_replaced_patches(klp_transition_patch);
 		klp_discard_nops(klp_transition_patch);
+		klp_release_obsolete_states(klp_transition_patch);
 	}
 
 	if (klp_target_state == KLP_UNPATCHED) {
@@ -140,6 +142,12 @@ static void klp_complete_transition(void)
 		task->patch_state = KLP_UNDEFINED;
 	}
 
+	if (klp_target_state == KLP_PATCHED) {
+		klp_enable_states(klp_transition_patch);
+	} else if (klp_target_state == KLP_UNPATCHED) {
+		klp_release_states(klp_transition_patch);
+	}
+
 	klp_for_each_object(klp_transition_patch, obj) {
 		if (!klp_is_object_loaded(obj))
 			continue;
-- 
2.35.3


