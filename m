Return-Path: <live-patching+bounces-2802-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yA75FgeZBGqILwIAu9opvQ
	(envelope-from <live-patching+bounces-2802-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 17:30:15 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 072A4536283
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 17:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CA3D30E59BA
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 14:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D795043CEED;
	Wed, 13 May 2026 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="el300dl7"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DE014AD20
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778682854; cv=none; b=qBhswAguuTow3vk04tuL/w+LwJRCBPOcjZRWnphzlJQIxPCpKVFafcbxg0Zf91fSi9wAhMFfvM7qdOx0S5Gxa1OwM9Scj7r7RXFXsMHqgLB3sIXk1+XnhFQsvRC3VF1GZLFFL7od6ZKkYB05Ms+PBWx1CMNNwqZQ6erZ7P25X1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778682854; c=relaxed/simple;
	bh=7k8OdUwMlOHJMH0x8cCALlFXznuVjHrFyaSOJDAxsCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iLf3irmDyofJREGTqyFSFBvaPZJtBJbQtJeIVYYU4NosA9R6VhWZXJOm3lizEswpQXmEI+bnm25oeAOFHhf/GNPJrgnmCiAhDtX+ShFFhcKux8sfMT6EiZuXh8ecUNZXydmwWbbhdbzAANqw6jwVRF9SmeNbCoBP5NBVyrMToEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=el300dl7; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c7980c060cfso3208526a12.2
        for <live-patching@vger.kernel.org>; Wed, 13 May 2026 07:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778682852; x=1779287652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYnudZeKv1OfAHm+f7CsrlHeQo0Cm2d5AvMSFJB05KQ=;
        b=el300dl7wU7AYKE16YUSx8s8XHSPy+wzzWz36gzkttaqQ731aWjb2oMCIFLO5QucF5
         XB5zu5fIROnuWV4gdt0IKAkgqeZcXzhrt1QjriwF0WaURM3yHxGNlis/aTwMII9wLjQv
         Lx3L/rDJ9oG4puMJn2bJYvQuNzJyi7mHM3Z9l5cNmy5rgZDYL4PzHRpcsYfJlcJ8YZgi
         rVY/y/81o7EzT8bGXtAcWFuLplqZC0f+JHaAihW0mUZiLbNxjHRuhGZZHlUGkdY9/tcI
         sS0S4/YH/jd93X+O6Vznt4GNzxJVhVJkZqnWVOS7XOz8K9OKdgKlAxevA0OZEcrkXVyW
         WlOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778682852; x=1779287652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vYnudZeKv1OfAHm+f7CsrlHeQo0Cm2d5AvMSFJB05KQ=;
        b=GCUowCOSOrujlnxwe2T8IYAzvsMtV3QCT2RJsRgl6vdG0j6vFcIlCr44Jl6Aj2t7Gt
         lOYKUfWMNTKRtI7eZMDZmDkiYsCajrMSsExY6ZfP7H8tcKu/PnGE631thHIjDJ9e58hl
         DbK4q8rHCXB7jNp7dD5c8AXh6VG95ZUTVyQ1gE77qEgSA7Eqd3ceXhF9w3sIRRITYFRv
         ouSL1CMxPvjbsMNEb6R3uR8K2/FR2K7NqC9+Kxz/GSROdwTu48d6LNzwQ/2c9yryG0Fi
         pBiq0enqnkOypg50xltp+wyD/GaVeMqqk1xBvtsBDbOYU1wIXwWbp1JUDNhe60bctTOP
         nJKQ==
X-Gm-Message-State: AOJu0YzXr4WscRXmYJAO3snbxREwXHao39jol2VeV3Z2mmZIPWYP1qzQ
	ENxIiqPKfxhPKoM1A6xNM3NPB34tsxb1PSB20ue/hOzmvwb03NFTnq5r
X-Gm-Gg: Acq92OH3q4luyx9x1uG3hSol/0NA3Hp8FQGz5BWyNXiqh4/3ccHSP0Me3nrHaj8M3x9
	Q/d8ZWBgBIRa4rw1oTpFlI5Emm6M3j95ShniS9YcOhuilRvnhWp/kM89V7o6GxerMCSRhxrwUjq
	TgDHzD5usiUVlVJP2vsw8c/mjpwfdJqUI/dCH2ddBo7W/lR+omqi2fVsrbG9QrJdcRS0prlTxka
	EFlR0SQxGyXYanr52pNl+zjU2gk9mLHXU5K/i1GZyzo37JAKJB6XD6ujNb+uf0lTSQqCrGyHGUa
	/XvmqzSF/4YKlslVg4gtfukoJnomNetMBnmL+DcDLFl87PCDJqDuFMZLWoDnImr0tVKQRz9+WO6
	JbGqd8BcQf/JxANGXijGpqnSEfEaAoQ7cZn2yPubA2PChBpNynDrhM3CekIf3lj3y+BfVE4SoUE
	F7k8cm9LVj7nKyX4tPT0X0ZNNZm0JrndIbcXvjmLpGlUc6HRv4Eo6pv7hrVWui8qBW754Wylhti
	Jc5UHSgUuvEng8=
X-Received: by 2002:a05:6a20:431c:b0:3a3:602d:a0d8 with SMTP id adf61e73a8af0-3af8067fbb9mr3973828637.17.1778682852323;
        Wed, 13 May 2026 07:34:12 -0700 (PDT)
Received: from localhost.localdomain ([240e:46c:2200:3c3:e555:e58a:71d1:ef1d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826771018bsm15006418a12.17.2026.05.13.07.34.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 07:34:11 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org
Subject: [RFC PATCH 3/6] livepatch: Allow to handle lifetime of shadow variables using the livepatch state
Date: Wed, 13 May 2026 22:33:18 +0800
Message-ID: <20260513143321.26185-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513143321.26185-1-laoar.shao@gmail.com>
References: <20260513143321.26185-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 072A4536283
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2802-lists,live-patching=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Action: no action

From: Petr Mladek <pmladek@suse.com>

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
index f43bf2676597..be4584044cf4 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -109,6 +109,11 @@ struct klp_object {
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
@@ -119,6 +124,7 @@ struct klp_state;
  *			 before code unpatching
  * @post_unpatch:	 executed only when the state is being disabled
  *			 after code unpatching
+ * @shadow_dtor:	 destructor for the related shadow variable
  * @pre_patch_succeeded: internal state used by a rollback on error
  *
  * All callbacks are optional.
@@ -135,6 +141,7 @@ struct klp_state_callbacks {
 	void (*post_patch)(struct klp_patch *patch, struct klp_state *state);
 	void (*pre_unpatch)(struct klp_patch *patch, struct klp_state *state);
 	void (*post_unpatch)(struct klp_patch *patch, struct klp_state *state);
+	klp_shadow_dtor_t shadow_dtor;
 	bool pre_patch_succeeded;
 };
 
@@ -143,12 +150,15 @@ struct klp_state_callbacks {
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
 
@@ -227,11 +237,6 @@ static inline bool klp_have_reliable_stack(void)
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
index a90c24d79084..43115e8e8453 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -202,6 +202,9 @@ void klp_states_post_unpatch(struct klp_patch *patch)
 		if (state->callbacks.post_unpatch)
 			state->callbacks.post_unpatch(patch, state);
 
+		if (state->is_shadow)
+			klp_shadow_free_all(state->id, state->callbacks.shadow_dtor);
+
 		state->callbacks.pre_patch_succeeded = 0;
 	}
 }
-- 
2.47.3


