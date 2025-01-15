Return-Path: <live-patching+bounces-977-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9AAA11BCA
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F6BB188A08B
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A022451C1;
	Wed, 15 Jan 2025 08:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Tb9w0Yt9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VsC/9bDD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12804232431;
	Wed, 15 Jan 2025 08:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929507; cv=none; b=EwwHNYrYrvTDYZp3yHZWHUdlmUo7Qrc/jorQeOr1/c+mLKOgpNH1A75fB0Dn/qxGuu1LIw5VRqeY0XyALe0MnnKgzOxY7VRVU6iRXCgZQ9otdlhwxlqsCtt1fsbopfnP4lyc1hTT1wkxxg07zMkTqqHS2HKnTB6nLm2XK1af85s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929507; c=relaxed/simple;
	bh=Qvl7XRQqoVAlAMDkTvRsd/o3LaA0iur2rRZiiMCvu/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bFa3ap4SRinXxPju2ioYRAtPIN2StqM3dtpvULB5Toz+SXWN5Hn6Pt8sKOo5V8eMUe6EWDiMa8qWFu335SijnoNb3Dk88Fb7bbQQjBN9RywADhmRX6gi8Ig519PjR2DDrcimOT2V9idspbwsk885zdPsM/EKgNH3xEJ9v5c7b7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Tb9w0Yt9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VsC/9bDD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id D73B81F37C;
	Wed, 15 Jan 2025 08:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=is2C76ZXXmVwCUawQH+72lfwjD4WWgGM6GXjAiDmQiw=;
	b=Tb9w0Yt9g/MSMAM6SB6r5vbj9Czc6a1T5LcpprbgWYGHVvcw28rWXYg/wx0eU9Bt0TpiXM
	tAbZ+wAvE71XjMlTDWfETqz1JTf84wAVN5lEWN/1bU2Bg7r2UNJtsqJ35uE3decHLdisCw
	rjLWCmwthSkRyVyeB5u1j2M40Q7J5T4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=is2C76ZXXmVwCUawQH+72lfwjD4WWgGM6GXjAiDmQiw=;
	b=VsC/9bDDSo4gUuFI1uLy0GXNOD6WpOi+Y1YDXOgUC8GkvHN+BTRpx5rfu/YH3iRUtg4Ofn
	AyQH6y4A4yKDBLddt25MQjKP7g4GG5g2zd0bPcMnEX6CTb4DxXgHRTS3+v2u8yxb7KEUM1
	rnfg2TUJ0ziauWD3MhKbL0LHUbeSnhE=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 02/19] livepatch: Allow to handle lifetime of shadow variables using the livepatch state
Date: Wed, 15 Jan 2025 09:24:14 +0100
Message-ID: <20250115082431.5550-3-pmladek@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115082431.5550-1-pmladek@suse.com>
References: <20250115082431.5550-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -7.30
X-Spamd-Result: default: False [-7.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

Managing the lifetime of shadow variables becomes challenging when atomic
replace is used. The new patch cannot determine whether a shadow variable
has already been used by a previous live patch or if there is a shadow
variable that is no longer in use.

Shadow variables are typically used alongside callbacks. At a minimum,
the @post_unpatch callback is called to free shadow variables that are
no longer needed. Additionally, @post_patch and @pre_unpatch callbacks
are sometimes used to enable or disable the use of shadow variables.
This is necessary when the shadow variable can only be used when
the entire system is capable of handling it.

The complexity increases when using the atomic replace feature,
as only the callbacks from the new live patch are executed.
Newly created live patches might manage obsolete shadow variables,
ensuring the upgrade functions correctly. However, older live
patches are unaware of shadow variables introduced later, which
could lead to leaks during a downgrade. Additionally, these
leaked variables might retain outdated information, potentially
causing issues if those variables are reused in a subsequent upgrade.

These issues are better addressed with the new callbacks associated
with a live patch state. These callbacks are triggered both when
the states are first introduced and when they become obsolete.
Additionally, the callbacks are invoked from the patch that
originally supported the state, ensuring that even downgrades are
handled safely.

Let’s formalize the process: Associate a shadow variable with a live
patch state by setting the "state.is_shadow" flag and using the same
"id" in both struct klp_shadow and struct klp_state.

The shadow variable will then share the same lifetime as the livepatch
state, allowing obsolete shadow variables to be automatically freed
without requiring an additional callback.

A generic callback will free the shadow variables using
the state->callbacks.shadow_dtor callback, if provided.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h | 15 ++++++++++-----
 kernel/livepatch/state.c  |  3 +++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 79dddf3dbd52..c624f1105663 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -132,6 +132,11 @@ struct klp_object {
 struct klp_patch;
 struct klp_state;
 
+typedef int (*klp_shadow_ctor_t)(void *obj,
+				 void *shadow_data,
+				 void *ctor_data);
+typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
+
 /**
  * struct klp_state_callbacks - callbacks manipulating the state
  * @pre_patch:		 executed only when the state is being enabled
@@ -142,6 +147,7 @@ struct klp_state;
  *			 before code unpatching
  * @post_unpatch:	 executed only when the state is being disabled
  *			 after code unpatching
+ * @shadow_dtor:	 destructor for the related shadow variable
  * @pre_patch_succeeded: internal state used by a rollback on error
  *
  * All callbacks are optional.
@@ -158,6 +164,7 @@ struct klp_state_callbacks {
 	void (*post_patch)(struct klp_patch *patch, struct klp_state *state);
 	void (*pre_unpatch)(struct klp_patch *patch, struct klp_state *state);
 	void (*post_unpatch)(struct klp_patch *patch, struct klp_state *state);
+	klp_shadow_dtor_t shadow_dtor;
 	bool pre_patch_succeeded;
 };
 
@@ -166,12 +173,15 @@ struct klp_state_callbacks {
  * @id:		system state identifier (non-zero)
  * @version:	version of the change
  * @callbacks:	optional callbacks used when enabling or disabling the state
+ * @is_shadow:	the state handles lifetime of a shadow variable with
+ *		the same @id
  * @data:	custom data
  */
 struct klp_state {
 	unsigned long id;
 	unsigned int version;
 	struct klp_state_callbacks callbacks;
+	bool is_shadow;
 	void *data;
 };
 
@@ -246,11 +256,6 @@ static inline bool klp_have_reliable_stack(void)
 	       IS_ENABLED(CONFIG_HAVE_RELIABLE_STACKTRACE);
 }
 
-typedef int (*klp_shadow_ctor_t)(void *obj,
-				 void *shadow_data,
-				 void *ctor_data);
-typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
-
 void *klp_shadow_get(void *obj, unsigned long id);
 void *klp_shadow_alloc(void *obj, unsigned long id,
 		       size_t size, gfp_t gfp_flags,
diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
index bf7ed988d2bb..16ad695b1e88 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -201,6 +201,9 @@ void klp_states_post_unpatch(struct klp_patch *patch)
 		if (state->callbacks.post_unpatch)
 			state->callbacks.post_unpatch(patch, state);
 
+		if (state->is_shadow)
+			klp_shadow_free_all(state->id, state->callbacks.shadow_dtor);
+
 		state->callbacks.pre_patch_succeeded = 0;
 	}
 }
-- 
2.47.1


