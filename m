Return-Path: <live-patching+bounces-411-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9DC393C3FD
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 16:22:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8254E281CE9
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 14:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CC119D068;
	Thu, 25 Jul 2024 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v5lqmdeL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7Nj0AwXx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RVg2Mzyv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GuWnXYZY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EE73FB3B;
	Thu, 25 Jul 2024 14:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721917345; cv=none; b=fEaCifi0wIW+B7h8fNo7S/rxM8ZJ06GBitdjHEcMOdC9W+TshVKZbyr+6zJ2TiC+oYpH6jOghzSQtzb83wjN2UevwhmGhQEVdry+ntDYwDAFgBmxKjCdXL3FFmYWk2sRIsBOvK1uHbOSXAym5tscEjg4dcN2nGqCJXLDxshAt0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721917345; c=relaxed/simple;
	bh=x6yaEcNXka7zLvCUrgE1GLUa/j6Jw8KxrmSLNIkNQBA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Jf0FrXWTCnEUUYg3l82zWMErspCdmmci414hWWMPbvezfcUwlHaBJnguVb1/UV2RYp1Wjh8hCpxpHyTxPu9S2ttmMfAU6oV4uJQeI2yLkJZPgtFRuAMeT1u0wWoxt0z4bdtgwhG7Be0PzfEJLQX6cXrpBf5ju/qy1UZZpIPiKdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v5lqmdeL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7Nj0AwXx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RVg2Mzyv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GuWnXYZY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EDEE721A78;
	Thu, 25 Jul 2024 14:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721917342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C6YxQJSxttdUENcvV08MHKl8gDBGHZs+9QcV1B9xW9E=;
	b=v5lqmdeLLVgjj3BJwYdvopkyHMWMx+8+0tbYlRH5e6V3Vy7mhY2pmpWU3NJzGfUfBlzHlB
	WY0TUNbVgwiP7GI70JXKtb9QtTLwI5uoiM/uJY5hDtoA48RtGsDJajRJ+ZTsFL9O2ILpo1
	GmZug1WLu+vvEEBQsDfuRdI00ikDCo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721917342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C6YxQJSxttdUENcvV08MHKl8gDBGHZs+9QcV1B9xW9E=;
	b=7Nj0AwXxNCfuJkyGpq5fUZYDnE621CUCk0qlshrCAHMbcy14l7guGcRRPF0jbdxE25DBv6
	Aa2yxVbfdFcMY2Dw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721917341; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C6YxQJSxttdUENcvV08MHKl8gDBGHZs+9QcV1B9xW9E=;
	b=RVg2MzyvTlFkMeNuwuCAbdQJfiUZ2nXV8poeirQBCQoRfGlI/0UE7Lruf9GOOn/gyMywQr
	gmbszJ5SpZe7xXMnMoVO1y72hDr9M9kC3hoCmdG2eUf8JVq/4QF6ULUY+5E7/fE63gKqK7
	pfi+1qes1ImUApE3x8X3af+0t7aBXr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721917341;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C6YxQJSxttdUENcvV08MHKl8gDBGHZs+9QcV1B9xW9E=;
	b=GuWnXYZY8CTDxpN6FCloE5ru2adBZRQdS1wxmywT43l2G+zV/zMizb2a9UH7Oan/8gVq4o
	b8bE8xYm0DwQKxCg==
Date: Thu, 25 Jul 2024 16:22:21 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Petr Mladek <pmladek@suse.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, Nicolai Stange <nstange@suse.de>, 
    live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 0/7] livepatch: Make livepatch states, callbacks, and shadow
 variables work together
In-Reply-To: <20231110170428.6664-1-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.2407251619500.21729@pobox.suse.cz>
References: <20231110170428.6664-1-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spamd-Result: default: False [-4.10 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.10

Hi Petr,

On Fri, 10 Nov 2023, Petr Mladek wrote:

> This POC is a material for the discussion "Simplify Livepatch Callbacks,
> Shadow Variables, and States handling" at LPC 2013, see
> https://lpc.events/event/17/contributions/1541/
> 
> It obsoletes the patchset adding the garbage collection of shadow
> variables. This new solution is based on ideas from Nicolai Stange.
> And it should also be in sync with Josh's ideas mentioned into
> the thread about the garbage collection, see
> https://lore.kernel.org/r/20230204235910.4j4ame5ntqogqi7m@treble

looks good to me. It is a huge improvement I would say.

As you mention elsewhere, it would also be nice to include some 
documentation and samples in the next revision.

The selftests would need to be ported to the new infrastructure.

Do we still need klp_state->data member? Now that it can be easily coupled 
with shadow variables, is there a reason to preserve it?

Miroslav

