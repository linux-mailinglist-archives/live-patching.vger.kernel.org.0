Return-Path: <live-patching+bounces-355-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB76E910067
	for <lists+live-patching@lfdr.de>; Thu, 20 Jun 2024 11:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA3D61C21DF9
	for <lists+live-patching@lfdr.de>; Thu, 20 Jun 2024 09:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1961B1A4F1F;
	Thu, 20 Jun 2024 09:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EZGzaT/D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bWQe+dNr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EZGzaT/D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bWQe+dNr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1111A4F07;
	Thu, 20 Jun 2024 09:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718875881; cv=none; b=rPOLBwrhzZeoCdfTpyXjzVsFjX1cn0F4EJw14goDh4dOSeeDMCqC4grEKTAQ2HUuSrafz6jon2hjXi44c3yaLTM994dAHniQCQbuosDs/S7XFzy6kacKlfF10LEQc1Yac6BI1s6QxHVuFvDKXQZcsrw9fOf9T5YwMFC933sagig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718875881; c=relaxed/simple;
	bh=v0UMqDXC5+SAf4JfkVwnd+K8Z7UmpjaIhgRRAQXV928=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=GcL3RftHJTzWZJN1LyLLQ3PgC5wUiOYeICCVxaxfi3iVhIDecHx7WRTeG6tblcefHd39wtVWZ6v57WE0oDTEx8cPj0JrpOsvVyUP5832nNrvDVCM6rtar44EuXSZzagSPAjN0fVOYYUx/H9W02ihlmTok+m7bCPRlkB+EudvCLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EZGzaT/D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bWQe+dNr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EZGzaT/D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bWQe+dNr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 70B6921AAD;
	Thu, 20 Jun 2024 09:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718875877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=idixMQpR+HA90NjHITkoUM5azVKTe8F/f+cm+VdShII=;
	b=EZGzaT/Dg4CNMYRRYXRwUcyafXj+bAN9ILaCA+hJYdgzmBMFw/ddds+msrxIGOJ15K4PE6
	T4gUyMqteEuwpz0G/nexoHP0rbofssSlTvSkJzFnjXCsKokyQpuHhREr1nnBNIt+B5XmJH
	7MKKB3vbruhciuGd8/vYEEY0tJFCn2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718875877;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=idixMQpR+HA90NjHITkoUM5azVKTe8F/f+cm+VdShII=;
	b=bWQe+dNrVZHaDm2wRS24uwyyvf4In0B/wHWtJ5eKhnhcSi++q/GS+1N+93hl5rGDnm8ELf
	jTH2sMlybqhzLrCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718875877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=idixMQpR+HA90NjHITkoUM5azVKTe8F/f+cm+VdShII=;
	b=EZGzaT/Dg4CNMYRRYXRwUcyafXj+bAN9ILaCA+hJYdgzmBMFw/ddds+msrxIGOJ15K4PE6
	T4gUyMqteEuwpz0G/nexoHP0rbofssSlTvSkJzFnjXCsKokyQpuHhREr1nnBNIt+B5XmJH
	7MKKB3vbruhciuGd8/vYEEY0tJFCn2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718875877;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=idixMQpR+HA90NjHITkoUM5azVKTe8F/f+cm+VdShII=;
	b=bWQe+dNrVZHaDm2wRS24uwyyvf4In0B/wHWtJ5eKhnhcSi++q/GS+1N+93hl5rGDnm8ELf
	jTH2sMlybqhzLrCA==
Date: Thu, 20 Jun 2024 11:31:15 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: zhang warden <zhangwarden@gmail.com>
cc: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>, 
    Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
In-Reply-To: <17FDEE20-A187-4493-BFA6-F09555B1EF6F@gmail.com>
Message-ID: <alpine.LSU.2.21.2406201129130.5846@pobox.suse.cz>
References: <20240520005826.17281-1-zhangwarden@gmail.com> <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz> <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com> <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz> <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
 <CAPhsuW7bjyLvfQ-ysKE+S8x26Zv5b7jbJoyW8UiBaUfaRncKfg@mail.gmail.com> <alpine.LSU.2.21.2406071102420.29080@pobox.suse.cz> <17FDEE20-A187-4493-BFA6-F09555B1EF6F@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-0.99)[-0.992];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email]

Hi,

On Thu, 20 Jun 2024, zhang warden wrote:

> 
> 
> > On Jun 7, 2024, at 17:07, Miroslav Benes <mbenes@suse.cz> wrote:
> > 
> > It would be better than this patch but given what was mentioned in the 
> > thread I wonder if it is possible to use ftrace even for this. See 
> > /sys/kernel/tracing/trace_stat/function*. It already gathers the number of 
> > hits.
> > 
> 
> Hi, Miroslav
> 
> Can ftrace able to trace the function which I added into kernel by livepatching?

yes, it should also work as is. I just generally recommend to use a 
different name (prefixed for example) for the new replacement function to 
avoid issues if you do not already do it.

Miroslav

