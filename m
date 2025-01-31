Return-Path: <live-patching+bounces-1095-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32872A23E1D
	for <lists+live-patching@lfdr.de>; Fri, 31 Jan 2025 14:06:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7B183A35FB
	for <lists+live-patching@lfdr.de>; Fri, 31 Jan 2025 13:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FDF91C245C;
	Fri, 31 Jan 2025 13:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WhXaTUho";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TIBw2m4G";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WhXaTUho";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TIBw2m4G"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5820B4A24
	for <live-patching@vger.kernel.org>; Fri, 31 Jan 2025 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738328803; cv=none; b=CyLovLs3fJdzSK2xNQQKNdEHkqWlPIwqqLU//1v+VelEjwlhQDtcE2YZ0qpK+dfVruiW6KKNgRot5mKAOJmDHi5TeTrmC/rKFt4XvmIzapXp0eHoXuFZ2UFMVyJTs/sBqikbAjLwhFUycXrz0q+nZqbfvq94oTavwUDeAEB3LSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738328803; c=relaxed/simple;
	bh=TZ/WX4omUqg9D5frT1MUWEWLnsdRYx0DD3H7fsoNjlI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pP2Vrcldf4WI+0Wte4PzvTWKGEWxxwHAqAba8AdXM8v7C6dp393e2jxw8WkvZ8kyF99OWlv2nSH+AYN/zVoBXUipitOk+lm9lrct5FOeIBDbJ+yreLsNZ9agjakvOJvi2ZNHXMwS/5YOqdQdF7IYulDXz8NLnRGC5ygMs3H20Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WhXaTUho; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TIBw2m4G; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WhXaTUho; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TIBw2m4G; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9757B2116A;
	Fri, 31 Jan 2025 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1738328798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2imtWDOgf4MJpp23GV2tQk70uv+/Ghez/VQziH4ELkk=;
	b=WhXaTUhoTWFGBxGJne2ZNMHVyI9tJ3+Dn2vqB6/EWX0TWefcoGvmjmxdKkNwEPf7SKRWzo
	2A5MuqX/rQFtobzTSg+C90Pd7uW0IERqHLwQLwfEUGONwpqs8spaa2cnXaxotg6mWHtq85
	i8tGaj+MoU7AKBeO6s5S9s2+OcZfhp0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1738328798;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2imtWDOgf4MJpp23GV2tQk70uv+/Ghez/VQziH4ELkk=;
	b=TIBw2m4GvUfy2hfVADBrNxhTMSH0wch4ZzrGQ/1P+TCMAFvYcfnLtmDAJebjHTe0h7D3Dm
	mcpcVnWjyHUJ3OBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1738328798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2imtWDOgf4MJpp23GV2tQk70uv+/Ghez/VQziH4ELkk=;
	b=WhXaTUhoTWFGBxGJne2ZNMHVyI9tJ3+Dn2vqB6/EWX0TWefcoGvmjmxdKkNwEPf7SKRWzo
	2A5MuqX/rQFtobzTSg+C90Pd7uW0IERqHLwQLwfEUGONwpqs8spaa2cnXaxotg6mWHtq85
	i8tGaj+MoU7AKBeO6s5S9s2+OcZfhp0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1738328798;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2imtWDOgf4MJpp23GV2tQk70uv+/Ghez/VQziH4ELkk=;
	b=TIBw2m4GvUfy2hfVADBrNxhTMSH0wch4ZzrGQ/1P+TCMAFvYcfnLtmDAJebjHTe0h7D3Dm
	mcpcVnWjyHUJ3OBg==
Date: Fri, 31 Jan 2025 14:06:38 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Yafang Shao <laoar.shao@gmail.com>
cc: Petr Mladek <pmladek@suse.com>, jpoimboe@kernel.org, jikos@kernel.org, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH] livepatch: Avoid hard lockup caused by
 klp_try_switch_task()
In-Reply-To: <CALOAHbCw5_ZxNuRkwzMqz7NFdnJWgt-n4R--oYiE+BtNGP_8aw@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2501311405280.10231@pobox.suse.cz>
References: <20250122085146.41553-1-laoar.shao@gmail.com> <Z5DpqC7sm5qCJFtj@pathway.suse.cz> <CALOAHbCw5_ZxNuRkwzMqz7NFdnJWgt-n4R--oYiE+BtNGP_8aw@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Score: -2.80
X-Spam-Flag: NO

Hi,

> $ cat log | grep do_exit | wc -l
> 1061
> 
> It seems that there are simply too many threads executing do_exit() at
> the moment.
> 
> >
> > You might try to use printk_deferred() instead. Also you might need
> > to disable interrupts around the read_lock()/read_unlock() to
> > make sure that the console handling will be deferred after
> > the tasklist_lock gets released.
> >
> > Anyway, I am against this patch.
> 
> However, there is still a risk of triggering a hard lockup if a large
> number of tasks are involved.

And as Petr said, it is very likely caused by pr_debug() in this setup. 
The proposed patch is not a fix and would make things only worse.

Regards,
Miroslav

