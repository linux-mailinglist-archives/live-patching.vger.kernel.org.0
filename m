Return-Path: <live-patching+bounces-406-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA0993C0D8
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 13:31:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33AE6282DA9
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 11:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C1B198E7E;
	Thu, 25 Jul 2024 11:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NW9/cJSf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QotTbueg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NW9/cJSf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QotTbueg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6FC16F84F;
	Thu, 25 Jul 2024 11:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721907115; cv=none; b=RmZ+sfFFyASbOPg41TZtkByW3onV7Lm/egHR8w4chN8bWgGQ8McHoVm1ei30EnvswtycIMlsbHGscxlG22WaQcgJ1sshmp7sTPJmRTupnhXN575lM8qWNR7eH6CXZ86SrfRz052KQJqagFmpIluBECjdKrbXfGeOuRMeS07lKLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721907115; c=relaxed/simple;
	bh=rR1RFY39+eRFR7OmHYrm0/qoxwcoE+S+x41VcI9lVys=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lEfsC63C3xKampuBqlmLuudY/Y2OX5pYYYpUYKGPbUI9Ys+522JAfiRmg4Ckiswp3wOKdZo0RsRP4uwf8vqdEYxreYQ/aaVPDu0WeE+ccr5jFk/TahXlMFD8B90HcYFlrq4NMIpIC0hDcRFQenZcedNv3yBzcjbLdER6H3TAazo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NW9/cJSf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QotTbueg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NW9/cJSf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QotTbueg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C3C47219A4;
	Thu, 25 Jul 2024 11:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721907100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A7ozrHK2GDxxKmDNZYI4+zW9TOYZW7KdkmtXD8HtnHc=;
	b=NW9/cJSfT+4oq8mjZG0mU8xNq3Wn4qL2+ycYDDFVRXCnXPdCCBEg0NftGwP6vsLvAedM1L
	hzvApVC32di11HTiFrdrkwmc8DXnusS8KfusL9bfv/tVlHlSn+J5WOhPfQkqUs30ReNYhE
	ggGC+ZlSHW94gJyKaLLqNHUHYm7wKu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721907100;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A7ozrHK2GDxxKmDNZYI4+zW9TOYZW7KdkmtXD8HtnHc=;
	b=QotTbuegHMZCkRF35uR3pkcedqCggOxcGF2GdODHmdv8KPbUeUEczr4Ez9N+n+p5WKnSgn
	zZPWsgn2bRwfxgBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721907100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A7ozrHK2GDxxKmDNZYI4+zW9TOYZW7KdkmtXD8HtnHc=;
	b=NW9/cJSfT+4oq8mjZG0mU8xNq3Wn4qL2+ycYDDFVRXCnXPdCCBEg0NftGwP6vsLvAedM1L
	hzvApVC32di11HTiFrdrkwmc8DXnusS8KfusL9bfv/tVlHlSn+J5WOhPfQkqUs30ReNYhE
	ggGC+ZlSHW94gJyKaLLqNHUHYm7wKu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721907100;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A7ozrHK2GDxxKmDNZYI4+zW9TOYZW7KdkmtXD8HtnHc=;
	b=QotTbuegHMZCkRF35uR3pkcedqCggOxcGF2GdODHmdv8KPbUeUEczr4Ez9N+n+p5WKnSgn
	zZPWsgn2bRwfxgBw==
Date: Thu, 25 Jul 2024 13:31:40 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Petr Mladek <pmladek@suse.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, Nicolai Stange <nstange@suse.de>, 
    live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 2/7] livepatch: Allow to handle lifetime of shadow variables
 using the livepatch state
In-Reply-To: <20231110170428.6664-3-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.2407251329300.21729@pobox.suse.cz>
References: <20231110170428.6664-1-pmladek@suse.com> <20231110170428.6664-3-pmladek@suse.com>
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

> diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
> index 6693d808106b..4ec65afe3a43 100644
> --- a/kernel/livepatch/state.c
> +++ b/kernel/livepatch/state.c
> @@ -198,11 +198,17 @@ void klp_release_states(struct klp_patch *patch)
>  		if (is_state_in_other_patches(patch, state))
>  			continue;
>  
> -		if (!state->callbacks.release)
> -			continue;
> -
> -		if (state->callbacks.setup_succeeded)
> +		if (state->callbacks.release && state->callbacks.setup_succeeded)
>  			state->callbacks.release(patch, state);
> +
> +		if (state->is_shadow)
> +			klp_shadow_free_all(state->id, state->callbacks.shadow_dtor);

The following

> +		/*
> +		 * The @release callback is supposed to restore the original
> +		 * state before the @setup callback was called.
> +		 */
> +		state->callbacks.setup_succeeded = 0;

should go to the previous patch perhaps?

Miroslav

