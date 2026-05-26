Return-Path: <live-patching+bounces-2887-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oJJuLL2YFWqNWgcAu9opvQ
	(envelope-from <live-patching+bounces-2887-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 14:57:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 306885D5E4A
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 14:57:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8A60C3011A5B
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 12:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903EF222597;
	Tue, 26 May 2026 12:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yor5r4+B"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBB8214204
	for <live-patching@vger.kernel.org>; Tue, 26 May 2026 12:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779799938; cv=none; b=ktPg3E8YW10F9X5dQs2NIU12QbVUfjUSMwumrsTWhK85fZSsEJjhNMUX3XZBGRCrPJtO3qT1wIOGKklyImICyZ0fbqdgoJ9vXwTmvn7iv15gfM094ahdwFTM14LqUmoldISZ1/o30UtML9c0D93VxBdCos3Vb3eauZ88mVaxlMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779799938; c=relaxed/simple;
	bh=NZuxgRKfOOHidXqsnbrpn1UNds+EviOMbGHBh7Ta/b8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9oA3mW4/AfjM4bRzBtmcIrcDJQ+lvQQW8ykGHtP2fniUvmdvUk+zA8iae8uSa2kA3p3sQ8nCLMSL2e7GWZUZ3T4H4Nn7T7GlEf0cgOgJ9osShnI3hHShoUTqzPJqNu2RK7GOGCTCAW9jrb39Urz5ZfiolJeey3QH5JOZkp5UsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Yor5r4+B; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45e6a4d0be0so4651190f8f.1
        for <live-patching@vger.kernel.org>; Tue, 26 May 2026 05:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779799935; x=1780404735; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7UPqvFiIegbAOlgVBc1oMEdv07jGLXAlkR41Wmy8+cE=;
        b=Yor5r4+BxDdHEOmgA01HQMwSYxc3Y3tQduKlnaoqW0NPczsZaxLpfa8VJXcTj4Iwdz
         rq4tbwK62I1t0o0A94kKQWwZbKQk8wcLDR7mx9bLOy3fZdH2aPlUdd6YNdK2ntkR6V6Z
         DRUIVzets6cVSMz81+sL4li4fKchHmCmafFvSAdsT297qRIW3elin+3Dt9jNvL2Dn1hz
         694jPEo9Tx5gSIVderQRQ0jfAbR8kuDSCKVKfH9aj7rgkjYkMp6FF4eIzdsP+IOhZ8gK
         K4zP/f16XxdWncYN/v+/Mlp6iASrJqFt4k2fDIFp7BDNKYjSJnctAi0pE2iXmbS9k5Dt
         Yejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779799935; x=1780404735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7UPqvFiIegbAOlgVBc1oMEdv07jGLXAlkR41Wmy8+cE=;
        b=k4vD8SZFBEnQqi+hNvzNJFMS5B7Ud3Z9hi2nE3lBRTJ2E7oe9BvphcQzXVsWN/evnv
         8C0TMmJVL/5EjgS7NMkhgDhw5Vq5JL0FAJZ0h8czaLXXOhaOpIXRLiPL82q/xRBeJ2hE
         0kecwyrcw3kKfvPcFz/wg6etx16nzhUjYIFJDPQA+UQ2BjqcdT0H00mF4rJ+4x03xxfT
         QcAfl5BcLv13nMdBpSqgn9cVjMBTM+1fEuHWlKZhVSvnzSLzXdKhhY0AgYQBaNj1MnjZ
         X/tRsVBwmRTi6hxiSSIH1o/cWxqQzHeq4YMkWPfDHPYrtmkSrMT3ZHkJ3+M+0hY/Wmak
         ttXA==
X-Forwarded-Encrypted: i=1; AFNElJ9+3edMura74Vq4B9YxNdphjwz8drfpiePsj1syBFBPRs13Ss6DgY7OigktpIBmX0oURM5aAI0zgeR1l2lg@vger.kernel.org
X-Gm-Message-State: AOJu0YyPhz5rZ8YKsb4KBCWCGE08YtJS+0mv2mF46dj2bUDn4eyg+1pf
	B5S2rGPNYqSflQyZy4aZ2mOfd7pXUHnoDHDavECvZuIzByt/8Qd8qrxvBLckIYB0hYggXJkaxK4
	+4qU7
X-Gm-Gg: Acq92OE11xU7tothrs6qeC+954NCjlT9ruyA5LKO0+tWnZ2dIum1mo5LthoQS8Nlxtx
	VXW19FSnuJltmXw6hbS6GhCZJBB2hWe655SfKxPIRQctLDOSqvnfHyN7dt+zg/RYrXf+75j9CIL
	N0ZPkpMVQzJ93XWqPy60jlC+M21b8DpNlC8xVeZDUiaVWj5KAFnrvbkZb/Zv+/6mQDQJtXts6fI
	rVughkjZ7tx8dCLNZcBPr52UTL7GlAw9AT5r2jRUpZIqWTP607Gq+6h/AKEbEHKaYD6HDDRJGnm
	qSOFv8nhW0gZfXJehqVtegBRbwsbM/4vprsy2ozsjuENvqJJrJNWl5n+hfkD/dmbDwPTYWsnc0s
	S9tfVpvojOXH6GC5LBrYKqPYZxygOQGnd7xeNedSRPzz/aMsFyQeB5CER7boZuBMMBichLuHW7Z
	R40vm+6kpnEhD5UQcLFyXwMhZBi58W8ziJDdqD
X-Received: by 2002:a05:6000:1848:b0:45e:9396:e5e5 with SMTP id ffacd0b85a97d-45eb36886f0mr31175758f8f.2.1779799935040;
        Tue, 26 May 2026 05:52:15 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6cd151asm34571790f8f.13.2026.05.26.05.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 05:52:14 -0700 (PDT)
Date: Tue, 26 May 2026 14:52:12 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, song@kernel.org,
	live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] livepatch: Support scoped atomic replace using
 replace set
Message-ID: <ahWXfHRFpvQBWgsa@pathway.suse.cz>
References: <20260513143321.26185-1-laoar.shao@gmail.com>
 <20260513143321.26185-2-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513143321.26185-2-laoar.shao@gmail.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2887-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,suse.com:dkim]
X-Rspamd-Queue-Id: 306885D5E4A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed 2026-05-13 22:33:16, Yafang Shao wrote:
> Convert the replace attribute from a boolean to a u32 to function as a
> "replace set." A newly loaded livepatch will now atomically replace
> existing patches that belong to the same set.
> 
> This change currently supports function replacement only; support for
> state and shadow variables will be introduced in subsequent patches.
> 
> --- a/Documentation/livepatch/cumulative-patches.rst
> +++ b/Documentation/livepatch/cumulative-patches.rst
> @@ -17,18 +17,20 @@ from all older livepatches and completely replace them in one transition.
>  Usage
>  -----
>  
> -The atomic replace can be enabled by setting "replace" flag in struct klp_patch,
> -for example::
> +The "replace_set" attribute in ``struct klp_patch`` acts as a **replace set**,
> +defining the scope of the replacement. By default, the replace set is 1.

Why "1" by default, please?

I guess that you wanted to make it "compatible" with the original
"replace" flag. It makes some sense. But it is weird in the long term.

This patchset is changing the whole semantic. Every livepatch is able
to replace an older one. It is not longer "no replace" vs "replace
all". Instead, a livepatch with a particular "replace_set" number
replaces an older livepatch with the same "replace_set" number.

It brings the question whether "replace_set" is a good name. There
is always only one enabled livepatch with a particular "replace_set"
number. It would make sense to call it "replace_tag" or "replace_id".

That said, the "set" might mean a set of livepatched functions.
And we should make sure that each set is separate. We should refuse
loading a livepatch which would patch a function already patched
by another livepatch with another another "replace_set".

Summary:

I would keep "replace_set" name. But I would use "0" by default.

> +For example::
>  
>  	static struct klp_patch patch = {
>  		.mod = THIS_MODULE,
>  		.objs = objs,
> -		.replace = true,
> +		.replace_set = 1,
>  	};
>  
>  All processes are then migrated to use the code only from the new patch.
> -Once the transition is finished, all older patches are automatically
> -disabled.
> +Once the transition is finished, all older patches with the same replace
> +set are automatically disabled. Patches with different tags remain active.
>  
>  Ftrace handlers are transparently removed from functions that are no
>  longer modified by the new cumulative patch.
> @@ -62,9 +64,10 @@ Limitations:
>  ------------
>  
>    - Once the operation finishes, there is no straightforward way
> -    to reverse it and restore the replaced patches atomically.
> +    to reverse it and restore the replaced patches (with the same set)
> +    atomically.
>  
> -    A good practice is to set .replace flag in any released livepatch.
> +    A good practice is to set a consistent .replace set in related livepatches.

I would say something like:

     "A good practice is to use only one (default) "replace_set". It
     makes sure that there always will be only one enabled livepatch
     on the system. The consistency model will ensure a safe update
     between two versions. It prevents potential problems with installing
     two livepatches doing incompatible functional changes."

>      Then re-adding an older livepatch is equivalent to downgrading
>      to that patch. This is safe as long as the livepatches do _not_ do
>      extra modifications in (un)patching callbacks or in the module_init()
> diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
> index acb90164929e..07c8d5a13003 100644
> --- a/Documentation/livepatch/livepatch.rst
> +++ b/Documentation/livepatch/livepatch.rst
> @@ -347,15 +347,20 @@ to '0'.
>  5.3. Replacing
>  --------------
>  
> -All enabled patches might get replaced by a cumulative patch that
> -has the .replace flag set.
> -
> -Once the new patch is enabled and the 'transition' finishes then
> -all the functions (struct klp_func) associated with the replaced
> -patches are removed from the corresponding struct klp_ops. Also
> -the ftrace handler is unregistered and the struct klp_ops is
> -freed when the related function is not modified by the new patch
> -and func_stack list becomes empty.
> +All currently enabled patches may be superseded by a cumulative patch that

In fact, there always can be only one livepatch with a given
"replace_set" number. They always replace each other.

> +has the same ``.replace_set`` attribute. Once the new patch is enabled and
> +the transition finishes, the livepatching core identifies all existing
> +patches that share the same replace set.
> +
> +Once the transition is complete, all functions (``struct klp_func``)
> +associated with the matching replaced patches are removed from the
> +corresponding ``struct klp_ops``. If a function is no longer modified by
> +the new patch and its ``func_stack`` list becomes empty, the ftrace
> +handler is unregistered and the ``struct klp_ops`` is freed.
> +
> +Patches with a different replace set are not affected by this process
> +and remain active. This allows for the independent management and
> +stacking of multiple, non-conflicting livepatch sets.
>  
>  See Documentation/livepatch/cumulative-patches.rst for more details.
>  
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -454,7 +454,7 @@ static ssize_t replace_show(struct kobject *kobj,

The function should get renamed to replace_set_show()...

>  	struct klp_patch *patch;
>  
>  	patch = container_of(kobj, struct klp_patch, kobj);
> -	return sysfs_emit(buf, "%d\n", patch->replace);
> +	return sysfs_emit(buf, "%d\n", patch->replace_set);
>  }
>  
>  static ssize_t stack_order_show(struct kobject *kobj,
> --- a/kernel/livepatch/state.c
> +++ b/kernel/livepatch/state.c
> @@ -85,24 +85,25 @@ EXPORT_SYMBOL_GPL(klp_get_prev_state);
>  
>  /* Check if the patch is able to deal with the existing system state. */
>  static bool klp_is_state_compatible(struct klp_patch *patch,
> +				    struct klp_patch *old_patch,
>  				    struct klp_state *old_state)
>  {
>  	struct klp_state *state;
>  
>  	state = klp_get_state(patch, old_state->id);
>  
> -	/* A cumulative livepatch must handle all already modified states. */
> +	/*
> +	 * If the new livepatch shares a state set with an existing one, it
> +	 * must maintain compatibility with all states modified by the old
> +	 * patch.
> +	 */
>  	if (!state)
> -		return !patch->replace;
> +		return patch->replace_set != old_patch->replace_set;


>  	return state->version >= old_state->version;

Also I would enforce that two livepatches with a different "replace_set"
must _not_ use the same "state->id".

>  }
>  
> -/*
> - * Check that the new livepatch will not break the existing system states.
> - * Cumulative patches must handle all already modified states.
> - * Non-cumulative patches can touch already modified states.
> - */
> +/* Check that the new livepatch will not break the existing system states. */
>  bool klp_is_patch_compatible(struct klp_patch *patch)
>  {
>  	struct klp_patch *old_patch;
> @@ -110,7 +111,7 @@ bool klp_is_patch_compatible(struct klp_patch *patch)
>  
>  	klp_for_each_patch(old_patch) {
>  		klp_for_each_state(old_patch, old_state) {
> -			if (!klp_is_state_compatible(patch, old_state))
> +			if (!klp_is_state_compatible(patch, old_patch, old_state))
>  				return false;
>  		}
>  	}

In addition, I strictly recommend to compare the set of livepatched
functions. We should refuse loading a livepatch which would want to modify
a function which is already livepatched with the livepatch with
another "replace_set".

Aka, the "set" means a set of livepatched functions. And the sets
should be independent.

> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -720,11 +720,11 @@ void klp_force_transition(void)
>  		klp_update_patch_state(idle_task(cpu));
>  
>  	/* Set forced flag for patches being removed. */
> -	if (klp_target_state == KLP_TRANSITION_UNPATCHED)
> +	if (klp_target_state == KLP_TRANSITION_UNPATCHED) {
>  		klp_transition_patch->forced = true;
> -	else if (klp_transition_patch->replace) {
> +	} else {
>  		klp_for_each_patch(patch) {
> -			if (patch != klp_transition_patch)
> +			if (patch->replace_set == klp_transition_patch->replace_set)

We still need to skip klp_transition patch as suggested by Sashiko AI.

>  				patch->forced = true;
>  		}
>  	}
> --- a/scripts/livepatch/init.c
> +++ b/scripts/livepatch/init.c
> @@ -72,12 +72,7 @@ static int __init livepatch_mod_init(void)
>  
>  	/* TODO patch->states */
>  
> -#ifdef KLP_NO_REPLACE
> -	patch->replace = false;
> -#else
> -	patch->replace = true;
> -#endif
> -
> +	patch->replace_set = KLP_REPLACE_TAG;

It should be KLP_REPLACE_SET to keep the naming consistent.

Is KLP_REPLACE_SET always defined, please?

>  	return klp_enable_patch(patch);
>  
>  err_free_objs:
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 7b82c7503c2b..66d4a0631f1b 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -172,9 +172,9 @@ process_args() {
>  				NAME="$(module_name_string "$NAME")"
>  				shift 2
>  				;;
> -			--no-replace)
> -				REPLACE=0
> -				shift
> +			-s | --replace-set)
> +				REPLACE="$2"

I would rename it to REPLACE_SET.

> +				shift 2
>  				;;
>  			-v | --verbose)
>  				VERBOSE="V=1"
> @@ -759,7 +759,7 @@ build_patch_module() {
>  
>  	cflags=("-ffunction-sections")
>  	cflags+=("-fdata-sections")
> -	[[ $REPLACE -eq 0 ]] && cflags+=("-DKLP_NO_REPLACE")
> +	cflags+=("-DKLP_REPLACE_TAG=$REPLACE")

with a consisten naming scheme:

	cflags+=("-DKLP_REPLACE_SET=$REPLACE_SET")

Is there a default value?


>  	cmd=("make")
>  	cmd+=("$VERBOSE")


In general, I am fine with this change. Well, it would require also
adding/fixing selftests.

That said, I would prefer to rework the klp callbacks, shadow, and
state API first. But it is not a strict requirement.

Best Regards,
Petr

