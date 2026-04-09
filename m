Return-Path: <live-patching+bounces-2327-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OI8+E71712mXOggAu9opvQ
	(envelope-from <live-patching+bounces-2327-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 09 Apr 2026 12:13:17 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF6E3C9080
	for <lists+live-patching@lfdr.de>; Thu, 09 Apr 2026 12:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE5463005D14
	for <lists+live-patching@lfdr.de>; Thu,  9 Apr 2026 10:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DA33ACA4B;
	Thu,  9 Apr 2026 10:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LhBo2qrX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QJIDTV/X";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LhBo2qrX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QJIDTV/X"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDE03A4F24
	for <live-patching@vger.kernel.org>; Thu,  9 Apr 2026 10:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775729316; cv=none; b=TAgyyIWe5dBR/vZHAgBBoQEBvnitEJ6JfOOtqpLgjKY9uU1gUzDM5c6AlZ0Cmqu1BnZB4sX/1K5Qbx3sl/ZOWVoxRf8bPJIOUohSKb9C6cUa6vo8p2jhG+oOQqQdKI9Xpb17NOd59apBhQ1uOoo/Dhen0oWl1UAR6hEiEL8MSPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775729316; c=relaxed/simple;
	bh=QK1HlenAL6ONmxS8R6XHJojcLwfa9/hk+hay9qkClu4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=I+BoflgpkThhmEQpa9CX/banieN3NrjxEXLMh/8VVVgPTBnGs9TdJyTHe0PkVkL2/+GLBn+qp2EuHNHMjiTRoqHVVEtrDc2Qiv7b4GIzEMnyZp2UWtIa3s0e3Fm+3ziiJK1dkv7S/JDs/0xGu/VSKTXXlAaK/RIUDghSqQuAfec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LhBo2qrX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QJIDTV/X; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LhBo2qrX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QJIDTV/X; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BABFC4EE9C;
	Thu,  9 Apr 2026 10:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775729313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/4YHUZBuBWUA7o0h5dWVSLlyfPkU18QmDDLBi+t5/uU=;
	b=LhBo2qrXJqcmczNFHHWVdGcsLQsVIL1yREAVlsVVK0OjK80a1uZffAT+f5r+nLAGij6iNQ
	bZNLoskMZTXkpKlsBVWFo09oiK0oBHgGgLynsmW8/c2r8RxYV7aE+0ogdhlRmHLT6OP67x
	BKSkw9RHeeIM7qmC3attuKB0ztgRhHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775729313;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/4YHUZBuBWUA7o0h5dWVSLlyfPkU18QmDDLBi+t5/uU=;
	b=QJIDTV/XnUqaZWaQIHo/n4/fcGYqQPkaFAEdqeFfHYj85pC3LyfGdeQKmWuLPjbcNHB2uN
	x4oRvJbBw7LeIWCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775729313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/4YHUZBuBWUA7o0h5dWVSLlyfPkU18QmDDLBi+t5/uU=;
	b=LhBo2qrXJqcmczNFHHWVdGcsLQsVIL1yREAVlsVVK0OjK80a1uZffAT+f5r+nLAGij6iNQ
	bZNLoskMZTXkpKlsBVWFo09oiK0oBHgGgLynsmW8/c2r8RxYV7aE+0ogdhlRmHLT6OP67x
	BKSkw9RHeeIM7qmC3attuKB0ztgRhHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775729313;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/4YHUZBuBWUA7o0h5dWVSLlyfPkU18QmDDLBi+t5/uU=;
	b=QJIDTV/XnUqaZWaQIHo/n4/fcGYqQPkaFAEdqeFfHYj85pC3LyfGdeQKmWuLPjbcNHB2uN
	x4oRvJbBw7LeIWCA==
Date: Thu, 9 Apr 2026 12:08:33 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Yafang Shao <laoar.shao@gmail.com>
cc: Song Liu <song@kernel.org>, jpoimboe@kernel.org, jikos@kernel.org, 
    pmladek@suse.com, joe.lawrence@redhat.com, rostedt@goodmis.org, 
    mhiramat@kernel.org, mathieu.desnoyers@efficios.com, kpsingh@kernel.org, 
    mattbobrowski@google.com, jolsa@kernel.org, ast@kernel.org, 
    daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
    eddyz87@gmail.com, memxor@gmail.com, yonghong.song@linux.dev, 
    live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return overriding
 for livepatched functions
In-Reply-To: <CALOAHbAmTAfamStF9sZtO6efWYJ1sbXJp3PbsVapZf7dba91ig@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2604091205250.31526@pobox.suse.cz>
References: <20260402092607.96430-1-laoar.shao@gmail.com> <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com> <CALOAHbDG8=eUV53kF+xn=izs2rpydCk=a9RznU-EEOzmkB8mQg@mail.gmail.com> <CAPhsuW73qFybHgOnZ=oFC1PvdWkYWDk7gsAoiBXe4xWYagPrmA@mail.gmail.com>
 <CALOAHbC0hqk+yrUZay01EBRNOHgyj1MAavzNK-06XJKK9ARMqQ@mail.gmail.com> <CAPhsuW5MN6ikKmxgqby5RJ3_gvjJ4B77X74OvfbTQoFO8iUgzA@mail.gmail.com> <CALOAHbAmTAfamStF9sZtO6efWYJ1sbXJp3PbsVapZf7dba91ig@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-2327-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[23];
	DMARC_NA(0.00)[suse.cz];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	FREEMAIL_CC(0.00)[kernel.org,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:dkim,pobox.suse.cz:mid]
X-Rspamd-Queue-Id: 9BF6E3C9080
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

> Can we add something like ALLOW_LIVEPATCH_ERROR_INJECTION() to allow
> error injection on functions defined inside a livepatch?

No.

I am sorry but you always seem to find band aids to your set up and how 
you deal with live patches internally. While I can see that something like 
a hybrid mode might be useful to people if done right (and we are not 
there yet), the combination of it with bpf overrides or anything like that 
is not something I would like to see in upstream.

Miroslav

