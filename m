Return-Path: <live-patching+bounces-734-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD5C99A298
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 13:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 232B01F23A9B
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 11:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2AD2141BD;
	Fri, 11 Oct 2024 11:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x6R4CK6t";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wU22RYej";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x6R4CK6t";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wU22RYej"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726FF3D64;
	Fri, 11 Oct 2024 11:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728645660; cv=none; b=ghwbEPlMrI80oqQ3VznOntQ64hBVEVDqCtB4m0xFP4xtfnTL+rZa9ILp7S6z9dw+HiCJaW46Q+yEc5rqlBadi0a0l3kox/K25rX1lbbgpp7Lu3snVqoDALOdvJx+lXO4ZK0sodgSX3NFeZ73TaTNaCc7uUjpspvgv6XLMSOCwa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728645660; c=relaxed/simple;
	bh=9WWfeF+yTw6OCEi9Dcr9BKotfZR4n7lYmVCdvL1M4rM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DZ9ljlKG/u+/nUrh6UF/c0yc2hClFZBzMW/Wt3evNhVP4s3j+ujQ7327kYxyyFAZ0m4cijxLYviBn3W4dIec2lMZ0y47vsnbEXKLWWUBqK37fxIfeKwSHmcU7VNY6U8/SYR+0shN4xCp56DrJH5ST5GJanws14+R3J/KxU1kfPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x6R4CK6t; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wU22RYej; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x6R4CK6t; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wU22RYej; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D78A21FFD;
	Fri, 11 Oct 2024 11:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1728645656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mD25FBx20/otfnPWwru6uhlmMEZVnMC++97mKhAzriA=;
	b=x6R4CK6tpW6nurAo0INPObhbR3JMBwEC1kUB382/AmXcO1E6x4w7mUG92bnO22AeXgRF+v
	ZGjgcI6605FkdohgC15xQYBbckV3CBrwuq7luhO9efToDmxQAz3We21LaZAmjnKyt2aZ+i
	byT6oJEiYdWGwAPbkX6VTimBYq7XLpA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1728645656;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mD25FBx20/otfnPWwru6uhlmMEZVnMC++97mKhAzriA=;
	b=wU22RYej0qxVUKf7IQaePATF/y8YxLDJyXkKVKKDxpL9+gdelt9bE1SYqJ9YqJ3p/e0RSj
	z8IvK1VkJUuaOOBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1728645656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mD25FBx20/otfnPWwru6uhlmMEZVnMC++97mKhAzriA=;
	b=x6R4CK6tpW6nurAo0INPObhbR3JMBwEC1kUB382/AmXcO1E6x4w7mUG92bnO22AeXgRF+v
	ZGjgcI6605FkdohgC15xQYBbckV3CBrwuq7luhO9efToDmxQAz3We21LaZAmjnKyt2aZ+i
	byT6oJEiYdWGwAPbkX6VTimBYq7XLpA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1728645656;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mD25FBx20/otfnPWwru6uhlmMEZVnMC++97mKhAzriA=;
	b=wU22RYej0qxVUKf7IQaePATF/y8YxLDJyXkKVKKDxpL9+gdelt9bE1SYqJ9YqJ3p/e0RSj
	z8IvK1VkJUuaOOBA==
Date: Fri, 11 Oct 2024 13:20:56 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Wardenjohn <zhangwarden@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 1/1] livepatch: Add stack_order sysfs attribute
In-Reply-To: <20241008014856.3729-2-zhangwarden@gmail.com>
Message-ID: <alpine.LSU.2.21.2410111320350.30734@pobox.suse.cz>
References: <20241008014856.3729-1-zhangwarden@gmail.com> <20241008014856.3729-2-zhangwarden@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 8 Oct 2024, Wardenjohn wrote:

> Add "stack_order" sysfs attribute which holds the order in which a live
> patch module was loaded into the system. A user can then determine an
> active live patched version of a function.
> 
> cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1
> 
> means that livepatch_1 is the first live patch applied
> 
> cat /sys/kernel/livepatch/livepatch_module/stack_order -> N
> 
> means that livepatch_module is the Nth live patch applied
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Suggested-by: Miroslav Benes <mbenes@suse.cz>
> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

M

