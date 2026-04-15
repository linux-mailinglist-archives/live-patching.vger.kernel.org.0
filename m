Return-Path: <live-patching+bounces-2355-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iPPlIBJ+32lAUAAAu9opvQ
	(envelope-from <live-patching+bounces-2355-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 14:01:22 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B95840418C
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 14:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 53BD630173BE
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 12:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE0A347BD9;
	Wed, 15 Apr 2026 12:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="W9VjdPKV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4oO2hk5a";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="W9VjdPKV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4oO2hk5a"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D958131714F
	for <live-patching@vger.kernel.org>; Wed, 15 Apr 2026 12:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254469; cv=none; b=rFV9w7EQ/Lql4K0swe9/HSJidiKle8L50soNVrWHu5YS4kvKQQd+Uy1nGKXvjQJ27/drAJuIBSSoRhrzQPIngQQ/+yPM2nF5vpqK0cLXRuZ5sClpUQTCDqRE6qMuHM+o6FGGa4g8Qq/ve8TSPgKTb8gRLD8jVJSrnrXkbgsepDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254469; c=relaxed/simple;
	bh=xgiWfqlfVoW6Zct2Lcg7QhAziiHLNMkpAynFW7SzHNM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=oc9gRY5swwfeXw4oKqJ3NnIyFcJf3WA6KMsJ8lTd1UGldm2JLyEksA+XIMHtlZAyji2MkrVze70I7tNS5sVGbwmupjCsHdbIdd8jKVRP9hBMeyA2q222Y7Vc9MCfxrdiH5tZcYZQydOwBH4GJ01K5NIp9cfji+WGCee9U8NwyXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=W9VjdPKV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4oO2hk5a; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=W9VjdPKV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4oO2hk5a; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 23E2D6A7E2;
	Wed, 15 Apr 2026 12:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776254465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wn17j2lK5IY0VmUpHhYcvC1wsTA3Kz/lTmapaTTmHc=;
	b=W9VjdPKVUTOMLhijX6fhezlFXPKaORW+jo63CdZo5slrfR5PMDCRDYePiIF+8apUE6R71T
	rQHCMsPooxbPo0vuW+/1FWzvJrIAJpKgjiH65V+JfyMUyAzxMgUZMf6z36trUMPes8vkS2
	EG6rshk7Sf77jhdjA/BlS+Sv50aDWlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776254465;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wn17j2lK5IY0VmUpHhYcvC1wsTA3Kz/lTmapaTTmHc=;
	b=4oO2hk5aU7gbjU27xxWkj6j9aO+SqRyTxODRSJxh9g+iC6Vga+q4mgNJZixNSNJVXgk5xc
	fOORunMtdGRIxaDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776254465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wn17j2lK5IY0VmUpHhYcvC1wsTA3Kz/lTmapaTTmHc=;
	b=W9VjdPKVUTOMLhijX6fhezlFXPKaORW+jo63CdZo5slrfR5PMDCRDYePiIF+8apUE6R71T
	rQHCMsPooxbPo0vuW+/1FWzvJrIAJpKgjiH65V+JfyMUyAzxMgUZMf6z36trUMPes8vkS2
	EG6rshk7Sf77jhdjA/BlS+Sv50aDWlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776254465;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wn17j2lK5IY0VmUpHhYcvC1wsTA3Kz/lTmapaTTmHc=;
	b=4oO2hk5aU7gbjU27xxWkj6j9aO+SqRyTxODRSJxh9g+iC6Vga+q4mgNJZixNSNJVXgk5xc
	fOORunMtdGRIxaDw==
Date: Wed, 15 Apr 2026 14:01:05 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
    Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
In-Reply-To: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
Message-ID: <alpine.LSU.2.21.2604151357350.1967@pobox.suse.cz>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.24
X-Spam-Level: 
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2355-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,pobox.suse.cz:mid,suse.cz:dkim]
X-Rspamd-Queue-Id: 2B95840418C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 13 Apr 2026, Marcos Paulo de Souza wrote:

> A new version of the patchset, with fewer patches now. Please take a look!
> 
> Original cover-letter:
> These patches don't really change how the patches are run, just skip
> some tests on kernels that don't support a feature (like kprobe and
> livepatched living together) or when a livepatch sysfs attribute is
> missing.
> 
> The last patch slightly adjusts check_result function to skip dmesg
> messages on SLE kernels when a livepatch is removed.
> 
> These patches are based on printk/for-next branch.
> 
> Please review! Thanks!
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

Besides my comment for 1/6 and what Sashiko discovered, it looks good to 
me.

However, please also take a look at brand new 
test_modules/test_klp_mod_target.c. It does not build on old kernels since 
they lack proc_create_single(). I think it should be covered in this patch 
set too.

Regards
Miroslav

