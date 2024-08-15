Return-Path: <live-patching+bounces-496-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D17953085
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 15:43:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A5F71F24951
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 13:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F58019F471;
	Thu, 15 Aug 2024 13:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GgrQHBAG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688E31714A8
	for <live-patching@vger.kernel.org>; Thu, 15 Aug 2024 13:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729423; cv=none; b=I4d+oNdg3jd92lBOHvJ8wwn95HhHWvIrdbxHsJxq3EEqh561aKUtRUA+qIKB84oI3mzLgiou98b7sTtKV+iZzK5IfWg/Mh4XpMwoBrmNTvtmM+tCEzwqP27ee45MuT0pTQ1lqKeUOPllSe5wtUYYxtweRYuBjMMcO6aLYUUTkFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729423; c=relaxed/simple;
	bh=O4yLnFi4rtD8pwc4Wy5KyRHItfx+wXhhebwLRzGiYfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgKmw6DTAtWW7qc7v8yowY4F33o5Rxoz2a3GvndmNkA9q9QvKrbbk5SwtqM8xDZXwZoNtiFa62GCGAd9stPDFhAmqI6dNl4l8N98QhawWIznJ1/aPOLF/BUf83j7YHTbo+OlZoXzxWdIIGo+SjcsLMYbf9lL+xYqW9c7pUvwcCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GgrQHBAG; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-429da8b5feaso8619315e9.2
        for <live-patching@vger.kernel.org>; Thu, 15 Aug 2024 06:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723729420; x=1724334220; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tto6eM9hNP9kwaU98qa0E0bzpJp65GdsSW76u9NX6RA=;
        b=GgrQHBAGeIEIjbNkt1Jh5jvZ58HV3lHTeS6kFyL1HfRm7m1DyKOeYxZEW4Sig2l5Zn
         PoLoNK8E6ZjHcON96BbUowhxQ9pvbW6SsixsemarJslXG5iJrVRYylclo6vO7LkJGC4p
         Xjz+/a7FRI46hBQgAGLLOwE9B1QokU1ZQyUoOHyukJ9D4r//bgbq/HsM/6Tfq38fdQpe
         u04VLdOeC+7hxTWiNtezyTzJ6whhhJdR8fhs7E0F1jf8SdlMhactZ8nMEFAKN6z8UssS
         Hg05X5pNwZUeWzV2rioBcTj3qjw2zcMizEiJUa6/gefTbQ8CtxgLxn12lP/s0A//jrwo
         CthQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723729420; x=1724334220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tto6eM9hNP9kwaU98qa0E0bzpJp65GdsSW76u9NX6RA=;
        b=VIe8P94BIE+M4N7zfZ4HRzLwQmegrv0mgs1GmI8i1iq2CcsmDAJkSUuNDim31crbE7
         g5kofw9vKQIBYA4XH9Vn4GRQV80SmCjf48A43CQbMMvtdhNY+WXephmctr1rWrxUuBhs
         OC5kojy0gAzZG6uEMbi6k8lsXZkonPe4ijiorVm8K2F3LG9bTEgp02Cq0H25Dn5GSLR+
         c0f7/KeGi1HPDtRAFiNIfQt2sYPmSH9p1194vMKD6Du4BM3CqdF02pv1WnOu5yAbh8Rr
         Ot0S4E8YHNEInbwUsrxIdsf35BeSENgDAVod/55p0b8W5HxxtPuBzgJ0SbY2rt4YSr8P
         RD7w==
X-Forwarded-Encrypted: i=1; AJvYcCVP/Xjir+kdstnkLUeqI68hG+yYH1EjbtTXxE/Uzmv/rfkg7hSSVIo2Za8+bWj+IigEkmRRbWAPT/bGq3f8v+OutepdToIM5NtHEYse/w==
X-Gm-Message-State: AOJu0Yz6VxB4hPHDEJybTGxDd2ONvzxyAwStOLBrf35Gh0b0Hce3QLcA
	25bvhpV9CyNRBaJ8+qS/Ozs0Esw9H6Vq4FRi6sMpfAh0tndPFfquLuJ4YLd1cTA=
X-Google-Smtp-Source: AGHT+IFBN0eoxUO6gO0o4RftKhcYBMgFTRCPjkqUHwDSFbLveCxPzSAiRKMU11VMwlnvN1NNkNtixQ==
X-Received: by 2002:adf:e10a:0:b0:368:5042:25f3 with SMTP id ffacd0b85a97d-37177783510mr5153752f8f.34.1723729419493;
        Thu, 15 Aug 2024 06:43:39 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8383946538sm103525766b.151.2024.08.15.06.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 06:43:39 -0700 (PDT)
Date: Thu, 15 Aug 2024 15:43:37 +0200
From: Petr Mladek <pmladek@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [POC 2/7] livepatch: Allow to handle lifetime of shadow
 variables using the livepatch state
Message-ID: <Zr4GCYkfof1aJ-hp@pathway.suse.cz>
References: <20231110170428.6664-1-pmladek@suse.com>
 <20231110170428.6664-3-pmladek@suse.com>
 <alpine.LSU.2.21.2407251329300.21729@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2407251329300.21729@pobox.suse.cz>

On Thu 2024-07-25 13:31:40, Miroslav Benes wrote:
> > diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
> > index 6693d808106b..4ec65afe3a43 100644
> > --- a/kernel/livepatch/state.c
> > +++ b/kernel/livepatch/state.c
> > @@ -198,11 +198,17 @@ void klp_release_states(struct klp_patch *patch)
> >  		if (is_state_in_other_patches(patch, state))
> >  			continue;
> >  
> > -		if (!state->callbacks.release)
> > -			continue;
> > -
> > -		if (state->callbacks.setup_succeeded)
> > +		if (state->callbacks.release && state->callbacks.setup_succeeded)
> >  			state->callbacks.release(patch, state);
> > +
> > +		if (state->is_shadow)
> > +			klp_shadow_free_all(state->id, state->callbacks.shadow_dtor);
> 
> The following
> 
> > +		/*
> > +		 * The @release callback is supposed to restore the original
> > +		 * state before the @setup callback was called.
> > +		 */
> > +		state->callbacks.setup_succeeded = 0;
> 
> should go to the previous patch perhaps?

Great catch!

I am going to refactor the code in the next version so that it would
look like:

void klp_states_post_unpatch(struct klp_patch *patch)
{
	struct klp_state *state;

	klp_for_each_state(patch, state) {
		if (is_state_in_other_patches(patch, state))
			continue;

		if (!state->callbacks.pre_patch_succeeded)
			continue;

		if (state->callbacks.post_unpatch)
			state->callbacks.post_unpatch(patch, state);

+		if (state->is_shadow)
+			klp_shadow_free_all(state->id, state->callbacks.shadow_dtor);
+
		state->callbacks.pre_patch_succeeded = 0;
	}
}


Best Regards,
Petr


