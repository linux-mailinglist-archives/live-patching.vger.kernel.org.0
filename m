Return-Path: <live-patching+bounces-976-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2302DA11BC5
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 354411674A4
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD46232434;
	Wed, 15 Jan 2025 08:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="l+0cuuGF";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="l+0cuuGF"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B691EBFE8;
	Wed, 15 Jan 2025 08:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929496; cv=none; b=AUNzzJNe0LfMFqT+kdMfZZTkcu7sjKgR8ZP1o9oIFxCbJ2zEbbOSc5M/hzzxGwGjCkYmmSoawBwpToyZl67NPCzrY6U7UUXbXfLuVfZlsS+CVhGNyrsR2ReSquIQrnQ1HNcZyTAqPdiRTt0lf1OBmH4PBWFAPKrA0fCpaxMOF0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929496; c=relaxed/simple;
	bh=/mtuB6dYrr4Qb/i7KWC8ooLs647ThT15uWaV103bjqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maDNrxJXB+v9mW2vbeT1mvRgdYFAgF9bLi0zu6PyFwenjE1V0xcCUiQl+y0QIX9jrXoxjrg29s+koCA1gmfrjRZcurFhCa8TI0G1Vxb0Pu4fIpAKsy/GragKXH2vrFT06Qresh9VC/b/aZhBkW2GNpZZmVtfAvY0tesq3+mwQGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=l+0cuuGF; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=l+0cuuGF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 918B31F37C;
	Wed, 15 Jan 2025 08:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SIO0qTKUq1SL9yKK5f8/GqngZfCP5mRjvgBeKwJ0RWs=;
	b=l+0cuuGFjHABFnA4N/ro30Q4TWMIjLTlwWmo+HedJH7+rLNTcQVPpN33JLYA5ir6mS3y3b
	CmV3F8hCR9xUQi9c/Rk2JzO1wNwSMzAqkbRau5yDOktPSnEq0zTX9ebksPKbxqIAu5olas
	D6rKFBJ5tNcmNMXAM66b4VCCyzu51/M=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SIO0qTKUq1SL9yKK5f8/GqngZfCP5mRjvgBeKwJ0RWs=;
	b=l+0cuuGFjHABFnA4N/ro30Q4TWMIjLTlwWmo+HedJH7+rLNTcQVPpN33JLYA5ir6mS3y3b
	CmV3F8hCR9xUQi9c/Rk2JzO1wNwSMzAqkbRau5yDOktPSnEq0zTX9ebksPKbxqIAu5olas
	D6rKFBJ5tNcmNMXAM66b4VCCyzu51/M=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 01/19] livepatch: Add callbacks for introducing and removing  states
Date: Wed, 15 Jan 2025 09:24:13 +0100
Message-ID: <20250115082431.5550-2-pmladek@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115082431.5550-1-pmladek@suse.com>
References: <20250115082431.5550-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

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
to revert some changes or free shadow variables whey they would no longer
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

  + "pre_patch" is called before the livepatch is applied but only when
      the state is new.

      It might be used to allocate some memory. Or it might
      check if the state change is safe on the running system.

      If it fails, the patch will not be enabled.

  + "post_patch" is called after the livepatch is applied but only when
      the state is new.

      It might be used to enable using some functionality provided by
      the livepatch after the entire system is livepatched.

  + "pre_unpatch" is called before the livepatch is disabled or replaced.

      When using the atomic replace, the callback is called only when
      the new livepatch does not support the related state. And it uses
      the implementation from the to-be-replaced livepatch.

      The to-be-replaced livepatch needed the callback to allow disabling
      the livepatch anyway. The new livepatch does not need to know
      anything about the state.

      It might be used to disable some functionality which will no longer
      be supported after the livepatch gets disabled.

  + "post_unpatch" is called after the livepatch was disabled or replaced.
     There are the same rules for the atomic replace replacement as for
     "pre_patch" callback.

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
    be ready before the system processes start being transitioned.

    The per-object callbacks were called after the barrier. They were
    using and already existing for-cycle. Nobody though about the potential
    ordering problem when it was implemented.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h     |  34 ++++++++
 kernel/livepatch/core.c       |   9 +++
 kernel/livepatch/state.c      | 141 ++++++++++++++++++++++++++++++++++
 kernel/livepatch/state.h      |   8 ++
 kernel/livepatch/transition.c |  15 ++++
 5 files changed, 207 insertions(+)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..79dddf3dbd52 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -129,15 +129,49 @@ struct klp_object {
 	bool patched;
 };
 
+struct klp_patch;
+struct klp_state;
+
+/**
+ * struct klp_state_callbacks - callbacks manipulating the state
+ * @pre_patch:		 executed only when the state is being enabled
+ *			 before code patching
+ * @post_patch:		 executed only when the state is being enabled
+ *			 after code patching
+ * @pre_unpatch:	 executed only when the state is being disabled
+ *			 before code unpatching
+ * @post_unpatch:	 executed only when the state is being disabled
+ *			 after code unpatching
+ * @pre_patch_succeeded: internal state used by a rollback on error
+ *
+ * All callbacks are optional.
+ *
+ * @pre_patch callback returns 0 on success and an error code otherwise.
+ *
+ * Any error prevents enabling the livepatch. @post_unpatch() callbacks are
+ * then called to rollback @pre_patch callbacks which has already succeeded
+ * before. Also @post_patch callbacks are called for to-be-removed states
+ * to rollback pre_unpatch() callbacks when they were called.
+ */
+struct klp_state_callbacks {
+	int (*pre_patch)(struct klp_patch *patch, struct klp_state *state);
+	void (*post_patch)(struct klp_patch *patch, struct klp_state *state);
+	void (*pre_unpatch)(struct klp_patch *patch, struct klp_state *state);
+	void (*post_unpatch)(struct klp_patch *patch, struct klp_state *state);
+	bool pre_patch_succeeded;
+};
+
 /**
  * struct klp_state - state of the system modified by the livepatch
  * @id:		system state identifier (non-zero)
  * @version:	version of the change
+ * @callbacks:	optional callbacks used when enabling or disabling the state
  * @data:	custom data
  */
 struct klp_state {
 	unsigned long id;
 	unsigned int version;
+	struct klp_state_callbacks callbacks;
 	void *data;
 };
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 3c21c31796db..527fdb0a6b0a 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -986,6 +986,8 @@ static int __klp_disable_patch(struct klp_patch *patch)
 
 	klp_init_transition(patch, KLP_TRANSITION_UNPATCHED);
 
+	klp_states_pre_unpatch(patch);
+
 	klp_for_each_object(patch, obj)
 		if (obj->patched)
 			klp_pre_unpatch_callback(obj);
@@ -1021,6 +1023,13 @@ static int __klp_enable_patch(struct klp_patch *patch)
 
 	klp_init_transition(patch, KLP_TRANSITION_PATCHED);
 
+	ret = klp_states_pre_patch(patch);
+	if (ret)
+		goto err;
+
+	if (patch->replace)
+		klp_states_pre_unpatch_replaced(patch);
+
 	/*
 	 * Enforce the order of the func->transition writes in
 	 * klp_init_transition() and the ops->func_stack writes in
diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
index 2565d039ade0..bf7ed988d2bb 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -117,3 +117,144 @@ bool klp_is_patch_compatible(struct klp_patch *patch)
 
 	return true;
 }
+
+static bool is_state_in_other_patches(struct klp_patch *patch,
+				      struct klp_state *state)
+{
+	struct klp_patch *p;
+	struct klp_state *s;
+
+	klp_for_each_patch(p) {
+		if (p == patch)
+			continue;
+
+		klp_for_each_state(p, s) {
+			if (s->id == state->id)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+int klp_states_pre_patch(struct klp_patch *patch)
+{
+	struct klp_state *state;
+
+	klp_for_each_state(patch, state) {
+		if (!is_state_in_other_patches(patch, state) &&
+		    state->callbacks.pre_patch) {
+			int err;
+
+			err = state->callbacks.pre_patch(patch, state);
+			if (err)
+				return err;
+		}
+
+		state->callbacks.pre_patch_succeeded = true;
+	}
+
+	return 0;
+}
+
+void klp_states_post_patch(struct klp_patch *patch)
+{
+	struct klp_state *state;
+
+	klp_for_each_state(patch, state) {
+		if (is_state_in_other_patches(patch, state))
+			continue;
+
+		if (state->callbacks.post_patch)
+			state->callbacks.post_patch(patch, state);
+	}
+}
+
+void klp_states_pre_unpatch(struct klp_patch *patch)
+{
+	struct klp_state *state;
+
+	klp_for_each_state(patch, state) {
+		if (is_state_in_other_patches(patch, state))
+			continue;
+
+		if (state->callbacks.pre_unpatch)
+			state->callbacks.pre_unpatch(patch, state);
+	}
+}
+
+void klp_states_post_unpatch(struct klp_patch *patch)
+{
+	struct klp_state *state;
+
+	klp_for_each_state(patch, state) {
+		if (is_state_in_other_patches(patch, state))
+			continue;
+
+		/*
+		 * This only occurs when a transition is canceled after
+		 * a preparation step failed.
+		 */
+		if (!state->callbacks.pre_patch_succeeded)
+			continue;
+
+		if (state->callbacks.post_unpatch)
+			state->callbacks.post_unpatch(patch, state);
+
+		state->callbacks.pre_patch_succeeded = 0;
+	}
+}
+
+/*
+ * Make it clear when pre_unpatch() callbacks need to be reverted
+ * in case of failure.
+ */
+static bool klp_states_pre_unpatch_replaced_called;
+
+void klp_states_pre_unpatch_replaced(struct klp_patch *patch)
+{
+	struct klp_patch *old_patch;
+
+	/* Make sure that it was cleared at the end of the last transition. */
+	WARN_ON(klp_states_pre_unpatch_replaced_called);
+
+	klp_for_each_patch(old_patch) {
+		if (old_patch != patch)
+			klp_states_pre_unpatch(old_patch);
+	}
+
+	klp_states_pre_unpatch_replaced_called = true;
+}
+
+void klp_states_post_unpatch_replaced(struct klp_patch *patch)
+{
+	struct klp_patch *old_patch;
+
+	klp_for_each_patch(old_patch) {
+		if (old_patch != patch)
+			klp_states_post_unpatch(old_patch);
+	}
+
+	/* Reset for the next transition. */
+	klp_states_pre_unpatch_replaced_called = false;
+}
+
+void klp_states_post_patch_replaced(struct klp_patch *patch)
+{
+	struct klp_patch *old_patch;
+
+	/*
+	 * This only occurs when a transition is canceled after
+	 * a preparation step failed.
+	 */
+	if (!klp_states_pre_unpatch_replaced_called)
+		return;
+
+	klp_for_each_patch(old_patch) {
+		if (old_patch != patch)
+			klp_states_post_patch(old_patch);
+	}
+
+	/* Reset for the next transition. */
+	klp_states_pre_unpatch_replaced_called = false;
+}
diff --git a/kernel/livepatch/state.h b/kernel/livepatch/state.h
index 49d9c16e8762..65c0c2cde04c 100644
--- a/kernel/livepatch/state.h
+++ b/kernel/livepatch/state.h
@@ -5,5 +5,13 @@
 #include <linux/livepatch.h>
 
 bool klp_is_patch_compatible(struct klp_patch *patch);
+int klp_states_pre_patch(struct klp_patch *patch);
+void klp_states_post_patch(struct klp_patch *patch);
+void klp_states_pre_unpatch(struct klp_patch *patch);
+void klp_states_post_unpatch(struct klp_patch *patch);
+
+void klp_states_pre_unpatch_replaced(struct klp_patch *patch);
+void klp_states_post_unpatch_replaced(struct klp_patch *patch);
+void klp_states_post_patch_replaced(struct klp_patch *patch);
 
 #endif /* _LIVEPATCH_STATE_H */
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c101..f3dce9fe9897 100644
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
 	if (klp_transition_patch->replace && klp_target_state == KLP_TRANSITION_PATCHED) {
 		klp_unpatch_replaced_patches(klp_transition_patch);
 		klp_discard_nops(klp_transition_patch);
+		klp_states_post_unpatch_replaced(klp_transition_patch);
 	}
 
 	if (klp_target_state == KLP_TRANSITION_UNPATCHED) {
@@ -140,6 +142,19 @@ static void klp_complete_transition(void)
 		task->patch_state = KLP_TRANSITION_IDLE;
 	}
 
+	if (klp_target_state == KLP_TRANSITION_PATCHED) {
+		klp_states_post_patch(klp_transition_patch);
+	} else if (klp_target_state == KLP_TRANSITION_UNPATCHED) {
+		/*
+		 * Re-enable states which should have been replaced but
+		 * the transition was cancelled or reverted.
+		 */
+		if (klp_transition_patch->replace)
+			klp_states_post_patch_replaced(klp_transition_patch);
+
+		klp_states_post_unpatch(klp_transition_patch);
+	}
+
 	klp_for_each_object(klp_transition_patch, obj) {
 		if (!klp_is_object_loaded(obj))
 			continue;
-- 
2.47.1


