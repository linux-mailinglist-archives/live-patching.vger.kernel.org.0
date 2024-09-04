Return-Path: <live-patching+bounces-592-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B13C96BC95
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 14:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20F4E1F24B1F
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 12:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CA61D933D;
	Wed,  4 Sep 2024 12:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JO9QLpE/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A781CC885;
	Wed,  4 Sep 2024 12:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725453584; cv=none; b=mcGR06zJ6pgrXQe2URaK1lqQwQi4iDxRawBklX6S8eMgI3/k5yAoMN7gsx03buYh22EvAK01HfUzBWrTmPMURKr7LABbNG4+pkTb+7n4ESV7yCKUGkltHY2hxsFmnXNuRxA5hrNOcEhTRSJNT2nDKT19l5OjzX1vC4woLTPiBKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725453584; c=relaxed/simple;
	bh=RFbJL4oadJkYVJEdHAfeGnEflo3z94SijJ1tdYYW8hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0iCt3/T2wxV2FwNHWW/AeZR3z2rqq02ycghc87L7mhBcjm/loiT26bX5ah2+6WdUvUjC45cYiOYzaxojAqDZ2iZnL2hdpRjJbpKEB/UMV1Jt0/C/+v++zCrFXGs1FuHDAymOL0OX1JiNzFxmyQCM50cr+N8RcwaAznGx+mOYk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JO9QLpE/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 91DCD40E0284;
	Wed,  4 Sep 2024 12:39:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8hAEHXmLLx2k; Wed,  4 Sep 2024 12:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1725453575; bh=s4bJ4luHNa9Htzw3qmhMuZycmNmyg+Bl8kA9Y352F/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JO9QLpE/bOqzxmTJFe0czkTrd6o7vFvKpwGlncqj4tqDpilhP9kinxSh84WQbKW0X
	 MIqGjz/eTTMOWD1zV+YICBllCa2F5dd7rj5Q9tfL+xDM1rmWGEmppG+KJW+++DQ9cp
	 WyZ/gdnLp3ecvCNzb0cFvJ4C299mUnXjEI8Tjp9RsMy6NdX2oqpWjCoV6DD0VtIiM7
	 aKk55MYbfvfVWpQuhEFB1SW9ElzcEVltaI2CgAg7oYZ9S5pBShiLXIq6/ki2irCx8P
	 ce2JHHz21gl30+1eU89WHTTd6VFVPkT3jgf+9HmliFCPLRv/9FlQwbtN1QYT+A1lcf
	 gWtgOe9yLZ0niSu0+i3WHqlaWdJS2UaE8RFNF+cPHlrFLqEUrZpByr35JScqqtf3Sl
	 j7cFQ0oBH0IYv6Vw1L1UfNFqwvIU6B+d5K2zn9WEfsmpHUjR5C5ZR4GYqYM+9OWrvm
	 uaXaxwesP9GI05PiFUL7YXrkt7r430sMF4Cmc1/QDaL46gTNG8/ntpABM68BDmMZRv
	 uxdocDUnGZAKUD0N73ahrUpucl6yilUi7m5gb1kDYsFVlYvBOhL9Ux3zWlUUelIJKk
	 KV5Om5icdfjxHNjxa6DUlVfrXRxTDhdPFHNUkLDTdz5UJFIrbw7fwenJQF+IBMy00v
	 GvhkvWVFpBE+R4R/rDEKsYUs=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 38F7140E0275;
	Wed,  4 Sep 2024 12:39:24 +0000 (UTC)
Date: Wed, 4 Sep 2024 14:39:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 28/31] x86/alternative: Create symbols for special section
 entries
Message-ID: <20240904123918.GCZthU9rOJLWUKBbsv@fat_crate.local>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
 <20240903082909.GP4723@noisy.programming.kicks-ass.net>
 <20240904042829.tkcpql65cxgzvhpx@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240904042829.tkcpql65cxgzvhpx@treble>

On Tue, Sep 03, 2024 at 09:28:29PM -0700, Josh Poimboeuf wrote:
> Take a more generic approach: for the "array of structs" style sections,
> annotate each struct entry with a symbol containing the entry.  This
> makes it easy for tooling to parse the data and avoids the fragility of
> hardcoding section details.

This is more a question for my own understanding: so you want a generic
approach where objtool doesn't need to know each special section and what it
needs to copy there from but simply copy those new, special symbols over?

Which you use as markers of sorts: "this is a relevant symbol, pls copy it"...

I think you mean that but lemme confirm anyway.

Also, have you checked whether this can be done with some compiler switch
already?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

