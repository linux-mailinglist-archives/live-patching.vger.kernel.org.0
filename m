Return-Path: <live-patching+bounces-2801-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DZ1NG6NBGoALgIAu9opvQ
	(envelope-from <live-patching+bounces-2801-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 16:40:46 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B4575535461
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 16:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 54BC0305D75F
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 14:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00DA433CEA8;
	Wed, 13 May 2026 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ji0MTpl5"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1479F407582
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 14:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778682849; cv=none; b=Ad1/tj59JNJn3xkHb98k6SVne6oZFri2ZLPzwU7cyijOjQmXUYY9klJsEZKvvUF0pLAUU/HNxyHR/S8r+bwT6iKo1y7xCxUMUh1NO7sx4mw3ZyJqw27nbLeBZwwf3XoM7inO88y0P0xB0v5sLWVrxbWfqpcuq+9kWfgUthbw7Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778682849; c=relaxed/simple;
	bh=RErMzmxymh5088TnVXowo5Onmi4XlDidT4EMrjAyPiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAwWBRcbi+kOszhbrzwofDmF2WnUA+S5W/992H1wf4z83AhTZedOt7xScMd4T7JdBD7ikvj3NgC88gYLtl2J3K61+jOubTN/GoMx++g6Rr25NFMEFMtwFRaUYJJgt6VnspUBDTYLi+CR9csTlBYWyIoeUNBT2Pnrb8EgG6u6O6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ji0MTpl5; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-835386ff122so6466648b3a.3
        for <live-patching@vger.kernel.org>; Wed, 13 May 2026 07:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778682847; x=1779287647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F54ZeypN8opA6ITdcjZQvs2yQZKtEmFVGhULwSYETpY=;
        b=Ji0MTpl5CRqwqwbNZjflsxetXyX7NLz8HRtKoo5rrRNG5VhJYVPyU+kMZusqRD17ad
         LkXNeTeMU+3VCs8rptfMG2Y+BW/0E6xcZU/bB4vOdd/PDGgUOVM3QS+GHNZ7MxTPR5rO
         ee8Ujoq3vyTdCIr0vYQo1SsR804mIbQ6V6rVpv8ypBGmpRvlXeyPZ+vbapOo7W4eJmsp
         CkNEv2QUW5frN4Rk6gLLyhzWE9cKZ2Ed3r4k4BbmLIFXDEAyzbB8BMMOSa7CfCkKbhLG
         T5l4KSDHRIH2UVSXWwK0dtJn3WNzxMWPTuyf0O7Lq/eqsNyPtvYZV8gmfsGsHSKBLM1V
         qlnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778682847; x=1779287647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F54ZeypN8opA6ITdcjZQvs2yQZKtEmFVGhULwSYETpY=;
        b=ODHaYeWoeE3BLZ7ovgBJvBQ/r66cgSvmmuMU9kuK5XEakl++rCY5D2sht8uFFS+Tmu
         5bOQOBT/QYI3k7ZsWCwjaBip1SbRuEjIkuAfPZojzB1jaFKqTf81wfyHEr1D/IM5KhAB
         49PIWHtnz3aBbQlWPr8GQz/Fhg8jwN2IFZi7sUMPiMzc1N6zt2VpWj2gSTWOlqbWn2jz
         cP3odbGsVoXNCWQKUsMraWV9853NGBMTjoJtWcWkV9Z2oo6Uagv6qUjc1RpQIUY2O0nr
         OjOFYFOpqtxMxxho7gr+Kv+kE7I17A3JMLkJhYIeidg5vyUKVS3FiuY/+y0NkIkm8zUb
         QI+w==
X-Gm-Message-State: AOJu0Yy4wXFPEtplzbfOHDuliKNzSNcuh++LOND0aBQQAupuzQbc97E+
	3flIUfy+lgPDtDXIQoUyeiN8OxNci+VAQLgMNr9k0h1m2AP02Fgigqiu
X-Gm-Gg: Acq92OHI6NigfpVFeGxZQ0oL3ekwzXNtpjZUd1ux3OZeH1jSV3vB1V+HBU5JiT74a2e
	bjXygVsQXs98AWCZIvwVwGiL0fbNh+nTY4SPYd7aREt0kQsuFXjEGGN4RUZXXuANTekeNyymnM+
	GeMyo/cXSlq4YIiUDiE6o1lbCG43DREtpjSx8HLOB58mDYmVhU51rMlu/XLmzi55NV2rpZEjIXb
	YwoOocn8LvQgehWoLr/Kxj85m5/N0iMyF33mvluipICyP06X9SeL3a1/dNX1BKOgN3LA0PC4tnW
	D/DzfOJjoP1f5E8BoXQduF9XqBEp+b3Ijt7ms1kGsrz/lCqglrmXMhhWQVCmp9O1+Au8iE7wJYz
	vzVt2v9Qag5i2j7krfybXV7/aKY3LttyZ0upsP1xiN91HqV0aCurKK9mkzmK/EGLjt0L+wQD0kZ
	O/DfmOKLXH8ScvYB2Ku5sqH8WFSowAChWcFOib0Rw0O5XGBgA0X7Q5/VRqMpgXF4jSmSkqZkF9y
	y/Cq5AXRKYqQjk=
X-Received: by 2002:a05:6a20:9188:b0:3aa:c95f:f67 with SMTP id adf61e73a8af0-3af8278b1d1mr4222386637.35.1778682846811;
        Wed, 13 May 2026 07:34:06 -0700 (PDT)
Received: from localhost.localdomain ([240e:46c:2200:3c3:e555:e58a:71d1:ef1d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826771018bsm15006418a12.17.2026.05.13.07.34.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 07:34:06 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 2/6] livepatch: Add callbacks for introducing and removing states
Date: Wed, 13 May 2026 22:33:17 +0800
Message-ID: <20260513143321.26185-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513143321.26185-1-laoar.shao@gmail.com>
References: <20260513143321.26185-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4575535461
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2801-lists,live-patching=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[live-patching];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action

From: Petr Mladek <pmladek@suse.com>

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
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/livepatch.h     |  34 ++++++++
 kernel/livepatch/core.c       |   8 ++
 kernel/livepatch/state.c      | 144 ++++++++++++++++++++++++++++++++++
 kernel/livepatch/state.h      |   8 ++
 kernel/livepatch/transition.c |  14 ++++
 5 files changed, 208 insertions(+)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 171c08328299..f43bf2676597 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -106,15 +106,49 @@ struct klp_object {
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
index 9eeded1f9cf0..95c099a8f594 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1019,6 +1019,8 @@ static int __klp_disable_patch(struct klp_patch *patch)
 
 	klp_init_transition(patch, KLP_TRANSITION_UNPATCHED);
 
+	klp_states_pre_unpatch(patch);
+
 	klp_for_each_object(patch, obj)
 		if (obj->patched)
 			klp_pre_unpatch_callback(obj);
@@ -1054,6 +1056,12 @@ static int __klp_enable_patch(struct klp_patch *patch)
 
 	klp_init_transition(patch, KLP_TRANSITION_PATCHED);
 
+	ret = klp_states_pre_patch(patch);
+	if (ret)
+		goto err;
+
+	klp_states_pre_unpatch_replaced(patch);
+
 	/*
 	 * Enforce the order of the func->transition writes in
 	 * klp_init_transition() and the ops->func_stack writes in
diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
index a2d223f2bbc0..a90c24d79084 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -118,3 +118,147 @@ bool klp_is_patch_compatible(struct klp_patch *patch)
 
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
+		if (old_patch->replace_set == patch->replace_set &&
+		    old_patch != patch)
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
+		if (old_patch->replace_set == patch->replace_set &&
+		    old_patch != patch)
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
+		if (old_patch->replace_set == patch->replace_set &&
+		    old_patch != patch)
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
index d9f5968fecdc..1a2b11be7b5a 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -12,6 +12,7 @@
 #include <linux/static_call.h>
 #include "core.h"
 #include "patch.h"
+#include "state.h"
 #include "transition.h"
 
 #define MAX_STACK_ENTRIES  100
@@ -92,6 +93,7 @@ static void klp_complete_transition(void)
 	if (klp_target_state == KLP_TRANSITION_PATCHED) {
 		klp_unpatch_replaced_patches(klp_transition_patch);
 		klp_discard_nops(klp_transition_patch);
+		klp_states_post_unpatch_replaced(klp_transition_patch);
 	}
 
 	if (klp_target_state == KLP_TRANSITION_UNPATCHED) {
@@ -131,6 +133,18 @@ static void klp_complete_transition(void)
 		task->patch_state = KLP_TRANSITION_IDLE;
 	}
 
+	if (klp_target_state == KLP_TRANSITION_PATCHED) {
+		klp_states_post_patch(klp_transition_patch);
+	} else if (klp_target_state == KLP_TRANSITION_UNPATCHED) {
+		/*
+		 * Re-enable states which should have been replaced but
+		 * the transition was cancelled or reverted.
+		 */
+		klp_states_post_patch_replaced(klp_transition_patch);
+
+		klp_states_post_unpatch(klp_transition_patch);
+	}
+
 	klp_for_each_object(klp_transition_patch, obj) {
 		if (!klp_is_object_loaded(obj))
 			continue;
-- 
2.47.3


