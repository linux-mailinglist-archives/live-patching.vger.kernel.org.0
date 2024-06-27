Return-Path: <live-patching+bounces-372-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1815B91A7C7
	for <lists+live-patching@lfdr.de>; Thu, 27 Jun 2024 15:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C15D12885C0
	for <lists+live-patching@lfdr.de>; Thu, 27 Jun 2024 13:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A52192B96;
	Thu, 27 Jun 2024 13:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gVvGwOD1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vDo2lOCN";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oIR0BSQe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xVDTWUrE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424C617836E
	for <live-patching@vger.kernel.org>; Thu, 27 Jun 2024 13:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719494606; cv=none; b=L10V5lhJAN1LtD7Gj7DSqj+CyzgDhO4jEEoV3FqnqKLbiKMXFjTPKYi7TLJCZt3sIoxCPsRAY+Sp0RQaRYzfn/BlE6QDLZ+YQjDQQbV1UOYfEhjgWZiphzyHHCQa08p7h3gqNpRlQeIP7STIKsVKdz4gfO5oNdcEB7DkJzeB5I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719494606; c=relaxed/simple;
	bh=QGJxHxa5qAk6t8COUQb1pQk4KUImz3vmOznDwLH84rQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NjX1tYUciAwUNjhI0u+5VxCQWreN2su9ME476Jc/vQ+zZpBZlso/eUcj9k/1zkzEvenxfSzgJrKdefUk8f1sXws35QFCURBy5gAT5utObgZkXHW4UfxRbQUJqkRIAd1rWbzqUFwInu7OCMX/C2Is4llv+w3QFXRiQVZ/L5Mws9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gVvGwOD1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vDo2lOCN; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oIR0BSQe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xVDTWUrE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 228FA21B92;
	Thu, 27 Jun 2024 13:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719494602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7k2/FNVBBtVjKXs8lC0RR6yeBRaQylSx28fNPvxGd8=;
	b=gVvGwOD19+8nAeWDsriARBBdlht1rkVjQub/iMfS0M3WYRNDIdueWcphLRacE4PgpNjDq1
	a+31tu0M/Jd3sb8ZKw5L4yHsPvls+mKfMWaVC6gtu7pRRYME9i/VaypLYXk8kIPYMalr1L
	uH85RYEqyGwZtgsYUJgHxB9v3GUmVNc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719494602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7k2/FNVBBtVjKXs8lC0RR6yeBRaQylSx28fNPvxGd8=;
	b=vDo2lOCN82866bH0s97J/XZ/heSfVj4RFxFKQ2Vj7kP3pr+P4QgP4T046K3WrJUmBvQwKD
	8CRo3W7WVRl55yDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719494601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7k2/FNVBBtVjKXs8lC0RR6yeBRaQylSx28fNPvxGd8=;
	b=oIR0BSQesTTMiNtbogIAEBmBE7Kms+B4to76yDRacKawaA4wOFC/UjNHh7ALBsa+ClfE7O
	GjAUlbfLMvjcYqkJIPxokMLnqw4SQN7E3gMeOWi3x8/fNUzyF86z0EDE0BqTmlfN693VQt
	xbrLL9PQr2VBoVyh77U4E3ESU+dvTfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719494601;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7k2/FNVBBtVjKXs8lC0RR6yeBRaQylSx28fNPvxGd8=;
	b=xVDTWUrEmo2lfZMZmNz3yIX6TPqD7BfwDNv0CMUJR3TBtwUG6Bv18JIJqHbAdvvis+deV2
	w9nMEtoKARDqQVBw==
Date: Thu, 27 Jun 2024 15:23:21 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Yafang Shao <laoar.shao@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, song@kernel.org, mpdesouza@suse.com, 
    live-patching@vger.kernel.org
Subject: Re: [PATCH v3 0/3] livepatch: Add "replace" sysfs attribute 
In-Reply-To: <20240625151123.2750-1-laoar.shao@gmail.com>
Message-ID: <alpine.LSU.2.21.2406271522090.4654@pobox.suse.cz>
References: <20240625151123.2750-1-laoar.shao@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	SUBJECT_ENDS_SPACES(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pobox.suse.cz:helo,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Tue, 25 Jun 2024, Yafang Shao wrote:

> There are situations when it might make sense to combine livepatches
> with and without the atomic replace on the same system. For example,
> the livepatch without the atomic replace might provide a hotfix
> or extra tuning.
> 
> Managing livepatches on such systems might be challenging. And the
> information which of the installed livepatches do not use the atomic
> replace would be useful. Therefore, "replace" sysfs attribute is added
> to show whether a livepatch supports atomic replace or not.
> 
> A minor cleanup is also included in this patchset.
> 
> v2->v3:
> - Improve the commit log (Petr)
> 
> v1->v2: https://lore.kernel.org/live-patching/20240610013237.92646-1-laoar.shao@gmail.com/
> - Refine the subject (Miroslav)
> - Use sysfs_emit() instead and replace other snprintf() as well (Miroslav)
> - Add selftests (Marcos) 
> 
> v1: https://lore.kernel.org/live-patching/20240607070157.33828-1-laoar.shao@gmail.com/
> 
> Yafang Shao (3):
>   livepatch: Add "replace" sysfs attribute
>   selftests/livepatch: Add selftests for "replace" sysfs attribute
>   livepatch: Replace snprintf() with sysfs_emit()
> 
>  .../ABI/testing/sysfs-kernel-livepatch        |  8 ++++
>  kernel/livepatch/core.c                       | 17 +++++--
>  .../testing/selftests/livepatch/test-sysfs.sh | 48 +++++++++++++++++++
>  3 files changed, 70 insertions(+), 3 deletions(-)

Acked-by: Miroslav Benes <mbenes@suse.cz>

M

