Return-Path: <live-patching+bounces-2237-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLjfBhv1u2nkqQIAu9opvQ
	(envelope-from <live-patching+bounces-2237-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 14:07:39 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 798B12CBA59
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 14:07:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D000E30B981A
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 13:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7F73D34B9;
	Thu, 19 Mar 2026 13:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WL+hH/rZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s2L8KHXx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WL+hH/rZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s2L8KHXx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122463D16EC
	for <live-patching@vger.kernel.org>; Thu, 19 Mar 2026 13:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773925396; cv=none; b=KIlWQq/8XnWKnCSn+N71BMr11aIwcvSgkoFfNwLJ0Sgg+/MTmgQo3P8qEAqewsVksUMczdm09UcIxoekzLHq4vJL9SR+7ub4sHoloLjMtjmNev6CYRjeZaTgqQMp6rIqYrBJWGvxw6X01Sp9kv05gzGuWe2y8FJYWeW7+2pfBV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773925396; c=relaxed/simple;
	bh=3xfISvJ8MVvi2lq0PhZa8+/9Kgxf6iDoC42KeTxqwXE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TcC/IipciNHW987oqoXE2MamLikW1QVgEE6JWWKWxbB0O/nw/V4V5IIJfJtuCtVHz1mgFxDL/Dnl/UymrciNd7ciwOvzV6sFnl4JnfDDETST8QxlSUZINN5fmM7YeR0RRWt4aYuJ7eacGLmk019g6IY7R2ip4PmMwIYBqV7KE68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WL+hH/rZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s2L8KHXx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WL+hH/rZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s2L8KHXx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5A8674D216;
	Thu, 19 Mar 2026 13:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773925393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s/v+pcLzmmV6dS3SqyoB0tsh7/02JKrEzHVmFoWZGxA=;
	b=WL+hH/rZUoXjw/RmNJq+X+/+RpbGtbcWIGWyG/UKojw7RHCxqT949ILT3/+7BpqL52jgF/
	9bVDJuPlmmvtevM3TRbWgXRWIQUUPKaKX6jJybMWbC/27qDSM/MRnT8DFSlfU6kgv1N7oe
	7LR+mHso5Ek5gXgqxC90p0VNSxcn6is=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773925393;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s/v+pcLzmmV6dS3SqyoB0tsh7/02JKrEzHVmFoWZGxA=;
	b=s2L8KHXxq+aL/qP9YzhltRlA5IiyPXokbZ5pD2Hx9jjvAvj4XMvGUJ2kd2wh5XPCT1UxaV
	9bsWk9RQEHd+usBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773925393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s/v+pcLzmmV6dS3SqyoB0tsh7/02JKrEzHVmFoWZGxA=;
	b=WL+hH/rZUoXjw/RmNJq+X+/+RpbGtbcWIGWyG/UKojw7RHCxqT949ILT3/+7BpqL52jgF/
	9bVDJuPlmmvtevM3TRbWgXRWIQUUPKaKX6jJybMWbC/27qDSM/MRnT8DFSlfU6kgv1N7oe
	7LR+mHso5Ek5gXgqxC90p0VNSxcn6is=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773925393;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s/v+pcLzmmV6dS3SqyoB0tsh7/02JKrEzHVmFoWZGxA=;
	b=s2L8KHXxq+aL/qP9YzhltRlA5IiyPXokbZ5pD2Hx9jjvAvj4XMvGUJ2kd2wh5XPCT1UxaV
	9bsWk9RQEHd+usBw==
Date: Thu, 19 Mar 2026 14:03:13 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
    Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] selftests: livepatch: test-kprobe: Replace true/false
 mod param by 1/0
In-Reply-To: <20260313-lp-tests-old-fixes-v1-2-71ac6dfb3253@suse.com>
Message-ID: <alpine.LSU.2.21.2603191401380.22987@pobox.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com> <20260313-lp-tests-old-fixes-v1-2-71ac6dfb3253@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -4.28
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2237-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.998];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,pobox.suse.cz:mid]
X-Rspamd-Queue-Id: 798B12CBA59
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

A nit but I think that "test-kprobe: " is unnecessary noise in the subject 
and can be dropped. It applies to all patches in the series.

On Fri, 13 Mar 2026, Marcos Paulo de Souza wrote:

> Older kernels don't support true/false for boolean module parameters
> because they lack commit 0d6ea3ac94ca
> ("lib/kstrtox.c: add "false"/"true" support to kstrtobool()"). Replace
> true/false by 1/0 so the test module can be loaded on older kernels.
> 
> No functional changes.

We also define a bool module parameter in 
test_modules/test_klp_callbacks_busy.c. Does it have a similar problem?

Miroslav

