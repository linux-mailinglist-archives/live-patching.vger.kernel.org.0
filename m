Return-Path: <live-patching+bounces-1339-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3980A717C6
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 14:51:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 181913BCF7B
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 13:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452C51E5B96;
	Wed, 26 Mar 2025 13:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ncox97gA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="K/zATkkH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ncox97gA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="K/zATkkH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525391F03E8
	for <live-patching@vger.kernel.org>; Wed, 26 Mar 2025 13:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742996902; cv=none; b=pe+UzTRweIyVlDobfyWzr+nlfz3dDsZVmPYSfPKAZaNf9dBmC6ogs7Qw32+I9PU/za/pWzU+ip093YSkwbxRKMs4VwsTNwnG0hTrs+Y0bSFTW4m1qjg+gcyfDi2vkRoHIxuhkL8FH2q8zXNRfi+9wrxcoUQkjcxTymLGyh0UDC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742996902; c=relaxed/simple;
	bh=DneVULK5GeNGdz2DKZMYPE4LSlT6BfGchhP1Ey/JcVw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=L5e3B1qT3IjSVCJHfakA7pWOah0WXUScXa64gvfuLSRqxMARgPGfdX571j0gw8E+abTgB39gRA3g5v+R3NeKAujZ/tKD7sE1uU+Vymzd7rjX2lV0crh7iaG/2KgMrzhEuxQFD9EGQqXTrc1o0u+oe82epl4tt3OfxbANKMM4gOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ncox97gA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=K/zATkkH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ncox97gA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=K/zATkkH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7921B21179;
	Wed, 26 Mar 2025 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742996897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CpgOCEZuVIUWNep2gTFj8ylP6/HyHac52qszIRih0MA=;
	b=ncox97gATOX1alCd8mq6tMQ+oN4cqL7jSUyXj457qSKzkZ0wwVDb6s22LmHLmdDrIbEv7m
	tj3S82ZSwDi6rr+7+VSppcricoX2dq5P1xkjwCeILRV/CCugFh0R8HvF244ewHqntUeqIi
	qL4FhvAbn/7+FK07EUFQosNn6jztpWs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742996897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CpgOCEZuVIUWNep2gTFj8ylP6/HyHac52qszIRih0MA=;
	b=K/zATkkHnM9kjBG8iYRQBG1YwQdnPko+sQoF0gFiV6R2inYPMAgxuA+dkiqlZ7RKLx7Nqa
	i9I2r+OSAeN/C6Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742996897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CpgOCEZuVIUWNep2gTFj8ylP6/HyHac52qszIRih0MA=;
	b=ncox97gATOX1alCd8mq6tMQ+oN4cqL7jSUyXj457qSKzkZ0wwVDb6s22LmHLmdDrIbEv7m
	tj3S82ZSwDi6rr+7+VSppcricoX2dq5P1xkjwCeILRV/CCugFh0R8HvF244ewHqntUeqIi
	qL4FhvAbn/7+FK07EUFQosNn6jztpWs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742996897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CpgOCEZuVIUWNep2gTFj8ylP6/HyHac52qszIRih0MA=;
	b=K/zATkkHnM9kjBG8iYRQBG1YwQdnPko+sQoF0gFiV6R2inYPMAgxuA+dkiqlZ7RKLx7Nqa
	i9I2r+OSAeN/C6Dg==
Date: Wed, 26 Mar 2025 14:48:17 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
    indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com, 
    irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org, 
    mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev, 
    rostedt@goodmis.org, will@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] arm64: Implement arch_stack_walk_reliable
In-Reply-To: <20250320171559.3423224-2-song@kernel.org>
Message-ID: <alpine.LSU.2.21.2503261447500.4152@pobox.suse.cz>
References: <20250320171559.3423224-1-song@kernel.org> <20250320171559.3423224-2-song@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On Thu, 20 Mar 2025, Song Liu wrote:

> With proper exception boundary detection, it is possible to implment
> arch_stack_walk_reliable without sframe.
> 
> Note that, arch_stack_walk_reliable does not guarantee getting reliable
> stack in all scenarios. Instead, it can reliably detect when the stack
> trace is not reliable, which is enough to provide reliable livepatching.
> 
> Signed-off-by: Song Liu <song@kernel.org>

Looks good to me.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

M

