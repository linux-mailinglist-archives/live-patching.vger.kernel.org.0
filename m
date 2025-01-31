Return-Path: <live-patching+bounces-1096-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A78A8A23E3E
	for <lists+live-patching@lfdr.de>; Fri, 31 Jan 2025 14:18:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 390E21888AD2
	for <lists+live-patching@lfdr.de>; Fri, 31 Jan 2025 13:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363CC1C2457;
	Fri, 31 Jan 2025 13:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DErOa52J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z4wPVc4I";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DErOa52J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z4wPVc4I"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A7738DC0;
	Fri, 31 Jan 2025 13:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738329508; cv=none; b=X1QC6QLyZuiex80H8m9yBF5oJYjDQgL6UvHDEOdTi7D0MVT9zn14TYRW107n91lCJq1iNwlUHPVYTeBWmV5VRm9zvTLyGJLf1U3APRoXq58HPU267ZgPX02rfUIVFMkocxi+HMi5rVylG8hLRHXl+q0ZXQ3gPlSw8TPLszGaPu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738329508; c=relaxed/simple;
	bh=SHmchvTzp5ErkaanwpgmmNEFXq4VUAYvrF9mLrCeNBQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CLAN9zRN1Pz4c/aSNmGBWNnYbr/n/OycnPwtr7kywxQHq3NBP2JvEtYUJRx3rGK2RdcGV19ZTfoBA4uai/oFgJZNpeHUqzeg+7f74RxjAiXycPoZvwt+I0z31LMvmqVVvVpnxEpNdhwfyVW/GdVRvZOEdphdvK9jcxT+21Hq3l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DErOa52J; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z4wPVc4I; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DErOa52J; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z4wPVc4I; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A3752116B;
	Fri, 31 Jan 2025 13:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1738329504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7goyXTtkfKbdujajWMQAcFSGLzmABxiGYAPZ/poldkM=;
	b=DErOa52JfiG1mii1hnBucroI7hWw54DW+p9RRLOMX0BUlUTFfvPIaD8nJmu+SsTsCHdbt6
	5KVdIzUHjGzmkqyaJu+O8+416CYI+kTug6YkpaoWgy72IGibZR6Uy5V8McrjzmS771oqDi
	WdhcT9IMUGLbNjoHY+cRlvoOtnEcOhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1738329504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7goyXTtkfKbdujajWMQAcFSGLzmABxiGYAPZ/poldkM=;
	b=Z4wPVc4IJzNgDX5d1Jktkb7pgmtJMYLgf2HlZIirtHZ4YSWtsOnk7E0ybMXbAnY3zSCBvA
	z2RniRLSfB2DEJCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1738329504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7goyXTtkfKbdujajWMQAcFSGLzmABxiGYAPZ/poldkM=;
	b=DErOa52JfiG1mii1hnBucroI7hWw54DW+p9RRLOMX0BUlUTFfvPIaD8nJmu+SsTsCHdbt6
	5KVdIzUHjGzmkqyaJu+O8+416CYI+kTug6YkpaoWgy72IGibZR6Uy5V8McrjzmS771oqDi
	WdhcT9IMUGLbNjoHY+cRlvoOtnEcOhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1738329504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7goyXTtkfKbdujajWMQAcFSGLzmABxiGYAPZ/poldkM=;
	b=Z4wPVc4IJzNgDX5d1Jktkb7pgmtJMYLgf2HlZIirtHZ4YSWtsOnk7E0ybMXbAnY3zSCBvA
	z2RniRLSfB2DEJCQ==
Date: Fri, 31 Jan 2025 14:18:24 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Yafang Shao <laoar.shao@gmail.com>
cc: Petr Mladek <pmladek@suse.com>, jpoimboe@kernel.org, jikos@kernel.org, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
In-Reply-To: <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz>
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz> <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -2.80
X-Spam-Flag: NO

> >
> >   + What exactly is meant by frequent replacements (busy loop?, once a minute?)
> 
> The script:
> 
> #!/bin/bash
> while true; do
>         yum install -y ./kernel-livepatch-6.1.12-0.x86_64.rpm
>         ./apply_livepatch_61.sh # it will sleep 5s
>         yum erase -y kernel-livepatch-6.1.12-0.x86_64
>         yum install -y ./kernel-livepatch-6.1.6-0.x86_64.rpm
>         ./apply_livepatch_61.sh  # it will sleep 5s
> done
 
A live patch application is a slowpath. It is expected not to run 
frequently (in a relative sense). If you stress it like this, it is quite 
expected that it will have an impact. Especially on a large busy system.

> >
> > > Other potential risks may also arise
> > >   due to inconsistencies or race conditions during transitions.
> >
> > What inconsistencies and race conditions you have in mind, please?
> 
> I have explained it at
> https://lore.kernel.org/live-patching/Z5DHQG4geRsuIflc@pathway.suse.cz/T/#m5058583fa64d95ef7ac9525a6a8af8ca865bf354
> 
>  klp_ftrace_handler
>       if (unlikely(func->transition)) {
>           WARN_ON_ONCE(patch_state == KLP_UNDEFINED);
>   }
> 
> Why is WARN_ON_ONCE() placed here? What issues have we encountered in the past
> that led to the decision to add this warning?

A safety measure for something which really should not happen.

> > The main advantage of the atomic replace is simplify the maintenance
> > and debugging.
> 
> Is it worth the high overhead on production servers?

Yes, because the overhead once a live patch is applied is negligible.

> Can you provide examples of companies that use atomic replacement at
> scale in their production environments?

At least SUSE uses it as a solution for its customers. No many problems 
have been reported since we started ~10 years ago.

Regards,
Miroslav

