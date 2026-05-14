Return-Path: <live-patching+bounces-2820-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mBm7AcFHBmo3hwIAu9opvQ
	(envelope-from <live-patching+bounces-2820-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 00:08:01 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7390E547577
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 00:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BAB83007348
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 22:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B064386553;
	Thu, 14 May 2026 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCtzo0LN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF7E33B6DC
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778796478; cv=none; b=GdQtBrZKaHAF7PVE/O/hbVFLiXbt5Pk2IVFzIwjqTl/4hwllSl1RLlPN+ShcGLtaLKn5HPIZ1bgwhX+yG01MN2KiSXhVqPnUjzei9J+Lcwn05qf0Ly41xDhjHIQCrITzytFURlMhQHmvR+lFztF3EKka7mNFVV3+T03egraquwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778796478; c=relaxed/simple;
	bh=t6UvqzCPJYucVJvqZfHK5vqvEK0+J+WWYaHAO/6giF4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A2dDhSrvZpjUnA+oqtHOl5vls0L1P55pOu3kvlqvBHlydnQEyQXYBdL17EwWz1PJCS0JiNrQNUm2GKLLqZMSi6toFNBIAzcuu9wc1Ek6KZr7tknMaJ3JLiQAoiZQhrwMQdHVBDWNCNpJcNanl8FSAC4yxESzDkW0aJQ6tlPcu6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCtzo0LN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412F4C2BCB3;
	Thu, 14 May 2026 22:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778796477;
	bh=t6UvqzCPJYucVJvqZfHK5vqvEK0+J+WWYaHAO/6giF4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=cCtzo0LN25i3/NG1iSOpC9XIWeIYc7tmvrT/OXxknrvioBqbcu8c1xbrR2Bfddy+t
	 s2uWt1agkNJdIMYJDdvWaQIkcr/wfjwFCLzPemgOmpvJvmcgOhGWeUXi2LMCVKtPS4
	 0CLoKam/foasZcbMtgTNG/b/hNaYRZRs02tMakzHm1s/OO5CDcDZizlJg2covBFyyb
	 gK8nl1+2tR8tzoBRGmj+ir4pIqzM6AZNDRjxzn1M6DuQwr3ddz2BcNn60MhNlvxR5D
	 VanQ5X2hCU0SwHg30ZQWyAK3Ohvta6UlzJppnBMa/ZmHmFpQsTUoGRB6ySkUIZhNDc
	 Vj1lgAn2mbWhw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 3/6] livepatch: Allow to handle lifetime of shadow
 variables using the livepatch state
Reply-To: sashiko-reviews@lists.linux.dev
To: mbenes@suse.cz, jpoimboe@kernel.org, joe.lawrence@redhat.com, pmladek@suse.com, song@kernel.org, jikos@kernel.org
Cc: live-patching@vger.kernel.org
In-Reply-To: <20260513143321.26185-4-laoar.shao@gmail.com>
References: <20260513143321.26185-4-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 22:07:52 +0000
Message-Id: <20260514220757.412F4C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 7390E547577
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2820-lists,live-patching=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FROM_NO_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,smtp.kernel.org:mid,sashiko.dev:url,lists.linux.dev:replyto,suse.com:email]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Shadow variables and state are permanently leaked during an atomic=
 replace if multiple replaced patches share the same state.
- [High] Tying shadow variable lifetime to the patch's global state causes =
shadow variable leaks and use-after-free risks for loadable module objects.
- [High] The new `shadow_dtor` callback in `struct klp_state_callbacks` exe=
cutes in atomic context, creating a severe API trap that leads to kernel pa=
nics.
--

commit e19c79edd4d439e568084dd175307ac754ab4007
Author: Petr Mladek <pmladek@suse.com>

livepatch: Allow to handle lifetime of shadow variables using the livepatch=
 state

This commit introduces a new mechanism to associate the lifetime of
shadow variables with the livepatch state. Obsolete shadow variables
are automatically freed during state unpatching using a new shadow_dtor
callback, reducing manual cleanup overhead.

> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 248e1a388818e..fef0c2f970838 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
[ ... ]
> @@ -135,6 +141,7 @@ struct klp_state_callbacks {
>  	void (*post_patch)(struct klp_patch *patch, struct klp_state *state);
>  	void (*pre_unpatch)(struct klp_patch *patch, struct klp_state *state);
>  	void (*post_unpatch)(struct klp_patch *patch, struct klp_state *state);
> +	klp_shadow_dtor_t shadow_dtor;

Will this callback run in an atomic context, unlike the other state callbac=
ks?

All existing state callbacks execute in standard process context and are
permitted to sleep. However, looking at klp_shadow_free_all(), it invokes
the destructor while holding klp_shadow_lock:

kernel/livepatch/shadow.c:klp_shadow_free_all() {
	...
	spin_lock_irqsave(&klp_shadow_lock, flags);

	hash_for_each(klp_shadow_hash, i, shadow, node) {
		if (klp_shadow_match(shadow, shadow->obj, id))
			klp_shadow_free_struct(shadow, dtor);
	}

	spin_unlock_irqrestore(&klp_shadow_lock, flags);
}

If a user assumes this callback runs in process context like the other
state callbacks and includes sleeping operations, couldn't this trigger
a scheduling while atomic panic?

>  	bool pre_patch_succeeded;
>  };
> =20
> @@ -143,12 +150,15 @@ struct klp_state_callbacks {
>   * @id:		system state identifier (non-zero)
>   * @version:	version of the change
>   * @callbacks:	optional callbacks used when enabling or disabling the st=
ate
> + * @is_shadow:	the state handles lifetime of a shadow variable with
> + *		the same @id

Does tying shadow variable lifetime to the global patch state cause leaks w=
hen
dealing with loadable modules?

If a livepatch applies to a loadable module, it may allocate shadow variabl=
es
keyed to the module's dynamically allocated objects.

When the target module is unloaded, klp_module_going() unpatches the module=
's
objects. However, because the state is a global property of the patch, no
state callbacks are invoked and the state is not considered obsolete. This
leaves the shadow variables for the unloaded module orphaned in the global
hash table.

If the module is subsequently reloaded and allocates new objects at the same
memory addresses, wouldn't klp_shadow_alloc() fail with a duplicate warning,
or klp_shadow_get() incorrectly return stale data?

>   * @data:	custom data
>   */
[ ... ]
> diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
> index a90c24d79084b..43115e8e8453c 100644
> --- a/kernel/livepatch/state.c
> +++ b/kernel/livepatch/state.c
> @@ -202,6 +202,9 @@ void klp_states_post_unpatch(struct klp_patch *patch)
>  		if (state->callbacks.post_unpatch)
>  			state->callbacks.post_unpatch(patch, state);
> =20
> +		if (state->is_shadow)
> +			klp_shadow_free_all(state->id, state->callbacks.shadow_dtor);
> +

Can this permanently leak shadow variables and state during an atomic repla=
ce?

Livepatch supports stacking, allowing multiple active patches (e.g., Patch A
and Patch B) to define the same state. If an atomic replace patch (Patch C)
is loaded, it replaces both A and B.

During the transition completion, klp_complete_transition() calls
klp_states_post_unpatch_replaced(), which iterates over the replaced
patches and calls klp_states_post_unpatch() for each.

For Patch A, klp_states_post_unpatch() calls is_state_in_other_patches().
Since Patch B is also still in the klp_patches list at this point (they are
not removed until klp_free_replaced_patches_async() runs later), the functi=
on
returns true and skips the cleanup block.

For Patch B, the same check finds Patch A in the list, returns true, and
also skips cleanup. Both patches are subsequently removed from the list,
permanently leaking the shadow variables and state cleanup logic.

>  		state->callbacks.pre_patch_succeeded =3D 0;
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260513143321.2618=
5-1-laoar.shao@gmail.com?part=3D3

