Return-Path: <live-patching+bounces-334-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD8F68FFED6
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 11:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CFE71F25C0D
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 09:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91CFF15B997;
	Fri,  7 Jun 2024 09:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rmlh5H8N";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L2T6c9UV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vAKFrRbX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Qq1oGQRS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90D215B552;
	Fri,  7 Jun 2024 09:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717751262; cv=none; b=FKKHF3vLIJziSJvRlXBHvq4iEKua1vmqrSqDro3wm5LGH58VHbGFKe33G2A47aNkIVuPJKT/szZP3RtAJX9Uno8Uy4gMWigryPJB3RTJq8KooP6kNqZ5j+EbSAnKo31e65IBuV15FMI2p0fKYfIINmPUHpgkyrsNxT48dFCbZpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717751262; c=relaxed/simple;
	bh=SMV7eKgvXkNkjRAwsyeqr3VEM5xfs6J33uhaYQeIu9w=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=K5x8WFW/yJb+2rlITcj3f2iLcF13poYUveRjL1U8IhkCWx71CGHVtXlmRMpfUjAgkMJpEDjpdMIKpEAKvyfiZUpuSYhwjXJTUu8KQ+gI54mMLHil2Puoq5hTj4Dp3BPY3Oc/hBfrs9A2BHANb9o9lUFXnB/SDoegr/jD7XsryEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rmlh5H8N; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L2T6c9UV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vAKFrRbX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Qq1oGQRS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 065A221B51;
	Fri,  7 Jun 2024 09:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717751259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ibcvUFzW9VYx26hADdXRhoqMY2eY4szyvbqtLibWJpA=;
	b=rmlh5H8Nkv2uOASg4UfRTlX73cKt0yMv2h8EUi3PT6FDajyMF+KJ5+bpNwOQ472jhS/zO3
	3IIOUa+418BBgZ3onzH1nat3z85uxszklJlyU7QO35sa1rhr8uagwnlZfphh869iGnrun+
	yLTCI4ZwRaoo9iAkHoSstle2xtGSLUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717751259;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ibcvUFzW9VYx26hADdXRhoqMY2eY4szyvbqtLibWJpA=;
	b=L2T6c9UVr5skfHmXOhQeGUDW+Ia24E0EQVfY4vwfazop5QX5FLuKVHhJ6uhoZWISHj1xQW
	nTO0S/0Lc6RWKHBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717751258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ibcvUFzW9VYx26hADdXRhoqMY2eY4szyvbqtLibWJpA=;
	b=vAKFrRbXcqRJlj+wAJwJBq9vXA4/449imJLYunXgciNPbJ0vtD/E7Yu7yAjdhiAn9p+48e
	Ga6c3QnmHG9LKQxX1qOWkP1nvSLdeN3At8JsC3eZPszeXWORdOH5Uzu6B7xBqlqutc+o/v
	GDD/qcx3Z356q3vYu7hCF3pjo64C054=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717751258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ibcvUFzW9VYx26hADdXRhoqMY2eY4szyvbqtLibWJpA=;
	b=Qq1oGQRSVWXz2pYqBvgJIFU+N6B8G5CZT+xdfg0Lclwwd55Cr7ynq8I1mlGE4FrQTDQvEG
	vAzlv00RgJ0+xJCg==
Date: Fri, 7 Jun 2024 11:07:36 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: Petr Mladek <pmladek@suse.com>, zhang warden <zhangwarden@gmail.com>, 
    Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
In-Reply-To: <CAPhsuW7bjyLvfQ-ysKE+S8x26Zv5b7jbJoyW8UiBaUfaRncKfg@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2406071102420.29080@pobox.suse.cz>
References: <20240520005826.17281-1-zhangwarden@gmail.com> <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz> <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com> <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz> <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
 <CAPhsuW7bjyLvfQ-ysKE+S8x26Zv5b7jbJoyW8UiBaUfaRncKfg@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1678380546-1951679478-1717751257=:29080"
X-Spam-Level: 
X-Spamd-Result: default: False [-3.26 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	CTYPE_MIXED_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.16)[-0.821];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+,1:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,gmail.com,kernel.org,redhat.com,vger.kernel.org];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_ZERO(0.00)[0];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Score: -3.26
X-Spam-Flag: NO

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-1951679478-1717751257=:29080
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi,

On Tue, 4 Jun 2024, Song Liu wrote:

> On Tue, May 21, 2024 at 1:04 AM Petr Mladek <pmladek@suse.com> wrote:
> [...]
> > >
> > > Yes, but the information you get is limited compared to what is available
> > > now. You would obtain the information that a patched function was called
> > > but ftrace could also give you the context and more.
> >
> > Another motivation to use ftrace for testing is that it does not
> > affect the performance in production.
> >
> > We should keep klp_ftrace_handler() as fast as possible so that we
> > could livepatch also performance sensitive functions.
> 
> At LPC last year, we discussed about adding a counter to each
> klp_func, like:
> 
> struct klp_func {
>     ...
>     u64 __percpu counter;
>     ...
> };
> 
> With some static_key (+ sysctl), this should give us a way to estimate
> the overhead of livepatch. If we have the counter, this patch is not
> needed any more. Does this (adding the counter) sound like
> something we still want to pursue?

It would be better than this patch but given what was mentioned in the 
thread I wonder if it is possible to use ftrace even for this. See 
/sys/kernel/tracing/trace_stat/function*. It already gathers the number of 
hits.

Would it be sufficient for you? I guess it depends on what the intention 
is. If there is no time limit, klp_func.counter might be better to provide 
some kind of overall statistics (but I am not sure if it has any value) 
and to avoid having ftrace registered on a live patched function for 
infinite period of time. If the intention is to gather data for some 
limited period, trace_stat sounds like much better approach to me.

Regards
Miroslav
--1678380546-1951679478-1717751257=:29080--

