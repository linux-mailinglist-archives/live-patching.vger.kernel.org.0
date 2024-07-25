Return-Path: <live-patching+bounces-409-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39C8593C3DC
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 16:16:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E30C4283BC9
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 14:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79DB319CD0B;
	Thu, 25 Jul 2024 14:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wgDOLu7I";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eFMyYpQW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wgDOLu7I";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eFMyYpQW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916991993AF;
	Thu, 25 Jul 2024 14:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721917008; cv=none; b=KlO3K2HTAEQZWuSdbvoaWpiQ/MrBG/e7azE/bJq6vcHlBnNQfBH/oJXC/yCmrnlODFD4zkFDgkW86T8F+hgFfAMx7Er5Wsdb6T10+T30Hx6jyEqhhMsjuCxBFwgGg9wmTn9R+usDCy10RonCErMfimcAuTfvXLgOFykaQeVOMVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721917008; c=relaxed/simple;
	bh=h+f8s+3CJcpGi2Z9zFljxU81ZMF5syJH7skobXNg5m0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UzC7RuBsKdTHRcS5564+mlzNRUYcQdxfZH2S/qXIzjqOX3dB8MoWIbaZ+xvVTkx34l/17vQNZYq9aYjNUKBIwo4yNgBPamDM8V1D/npin7ahaxU8rpKCVP41TivcJSdtdcvKEJwwjRzz3Tx2UxsH+uJcpBtdzmXvgQiZ3RM+E2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wgDOLu7I; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eFMyYpQW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wgDOLu7I; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eFMyYpQW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C272421B38;
	Thu, 25 Jul 2024 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721917004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJnxfI1WkR26q7nC17t10NToOopSRTyUWoyrrkPiL60=;
	b=wgDOLu7IfhFLb5UoP4RDwTgcQBTCHwqtegPmXRTUR502BH/ceYyx8DJjkovzNrzPAslvds
	fY+fHn+uixdxyI+VUUrHE1G2fjwZHvivbODmOSj50zRpbT1t6zglO1JDVG4yRrNPImRlpo
	PBPMatjGWO7KlJvuZlJprqyLA1+s3GA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721917004;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJnxfI1WkR26q7nC17t10NToOopSRTyUWoyrrkPiL60=;
	b=eFMyYpQWEiU5o4D2i8gyYCoMjhBe8V84jmwuOCFqGOeJ7OMphilc0e3MH/WuUBQ5FCrGKF
	e6zSikAlMO6a7oBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721917004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJnxfI1WkR26q7nC17t10NToOopSRTyUWoyrrkPiL60=;
	b=wgDOLu7IfhFLb5UoP4RDwTgcQBTCHwqtegPmXRTUR502BH/ceYyx8DJjkovzNrzPAslvds
	fY+fHn+uixdxyI+VUUrHE1G2fjwZHvivbODmOSj50zRpbT1t6zglO1JDVG4yRrNPImRlpo
	PBPMatjGWO7KlJvuZlJprqyLA1+s3GA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721917004;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJnxfI1WkR26q7nC17t10NToOopSRTyUWoyrrkPiL60=;
	b=eFMyYpQWEiU5o4D2i8gyYCoMjhBe8V84jmwuOCFqGOeJ7OMphilc0e3MH/WuUBQ5FCrGKF
	e6zSikAlMO6a7oBA==
Date: Thu, 25 Jul 2024 16:16:44 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Petr Mladek <pmladek@suse.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, Nicolai Stange <nstange@suse.de>, 
    live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 7/7] livepatching: Remove per-state version
In-Reply-To: <20231110170428.6664-8-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.2407251553420.21729@pobox.suse.cz>
References: <20231110170428.6664-1-pmladek@suse.com> <20231110170428.6664-8-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-1.10 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Flag: NO
X-Spam-Score: -1.10

On Fri, 10 Nov 2023, Petr Mladek wrote:

> The livepatch state API was added to help with maintaining:
> 
>    + changes done by livepatch callbasks
>    + lifetime of shadow variables
> 
> The original API was hard to use. Both objectives are better handled
> by the new per-state callbacks. They are called when the state is
> introduced or removed. There is also support for automatically freeing
> obsolete shadow variables.
> 
> The new callbacks changed the view of compatibility.  The livepatch
> can be replaced to any older one as long the current livepatch is
> able to disable the obsolete state.
> 
> As a result, the new patch does not need to support the currently
> used states. The current patch will be able to disable them.
> 
> The remaining question is what to do with the per-state version.
> It was supposed to allow doing more modifications on an existing
> state. The experience shows that it is not needed in practice.
> 
> Well, it still might make sense to prevent downgrade when the state
> could not be disabled easily or when the author does not want to
> deal with it.
> 
> Replace the per-state version with per-state block_disable flag.
> It allows to handle several scenarios:

I have no opinion to be honest. block_disable flag might be sufficient in 
the end.

[...]

> @@ -159,7 +159,9 @@ struct klp_state {
>   * @mod:	reference to the live patch module
>   * @objs:	object entries for kernel objects to be patched
>   * @states:	system states that can get modified
> + * version:	livepatch version (optional)
>   * @replace:	replace all actively used patches
> + *
>   * @list:	list node for global list of actively used patches
>   * @kobj:	kobject for sysfs resources
>   * @obj_list:	dynamic list of the object entries
> @@ -173,6 +175,7 @@ struct klp_patch {
>  	struct module *mod;
>  	struct klp_object *objs;
>  	struct klp_state *states;
> +	unsigned int version;
>  	bool replace;

Is it still needed then? What would be the use case?

[...]

>  	/*
>  	 * Allow to reverse a pending transition in both ways. It might be
>  	 * necessary to complete the transition without forcing and breaking
> @@ -1097,10 +1104,10 @@ int klp_enable_patch(struct klp_patch *patch)
>  
>  	if (!klp_is_patch_compatible(patch)) {
>  		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
> -			patch->mod->name);
> +		       patch->mod->name);
>  		mutex_unlock(&klp_mutex);
>  		return -EINVAL;
> -	}
> +       }
>  
>  	if (!try_module_get(patch->mod)) {
>  		mutex_unlock(&klp_mutex);
> @@ -1111,17 +1118,17 @@ int klp_enable_patch(struct klp_patch *patch)
>  
>  	ret = klp_init_patch(patch);
>  	if (ret)
> -		goto err;
> +		goto unlock_free;
>  
>  	ret = __klp_enable_patch(patch);
>  	if (ret)
> -		goto err;
> +		goto unlock_free;
>  
>  	mutex_unlock(&klp_mutex);
>  
>  	return 0;
>  
> -err:
> +unlock_free:
>  	klp_free_patch_start(patch);

Unrelated changes.
  
>  /*
>   * Check that the new livepatch will not break the existing system states.
> - * Cumulative patches must handle all already modified states.
> - * Non-cumulative patches can touch already modified states.
> + * The patch could replace existing patches only when the obsolete
> + * states can be disabled.
>   */
>  bool klp_is_patch_compatible(struct klp_patch *patch)
>  {
>  	struct klp_patch *old_patch;
>  	struct klp_state *old_state;
>  
> +	/* Non-cumulative patches are always compatible. */
> +	if (!patch->replace)
> +		return true;
> +

Cumulative != atomic replace. Those are two different things.

Miroslav

