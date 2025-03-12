Return-Path: <live-patching+bounces-1273-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6A22A5DE9A
	for <lists+live-patching@lfdr.de>; Wed, 12 Mar 2025 15:05:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61A333A4748
	for <lists+live-patching@lfdr.de>; Wed, 12 Mar 2025 14:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E81524BC05;
	Wed, 12 Mar 2025 14:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zBCuePux";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vLPwFMwJ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="knxQnRBs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="G+RdLoCA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2C424BC1C
	for <live-patching@vger.kernel.org>; Wed, 12 Mar 2025 14:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741788324; cv=none; b=q/xNHEsqhuH8Fbi4nVubkGbmq4NjXLjRelCKfHyrTYTT4XdtPxpOD4AlWQTAK49JQ+qo++Jfj+X8KEY5nTWjny5vvSAE93tDZUz6/jjvzYIQowIm9HKOQYf5LHSZkBg6PyRfHNiTZPca+L3GY8PQjNGaYj/ubf36gC2Zr8p4rVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741788324; c=relaxed/simple;
	bh=e3HyHXxDOgTjnjIKHqatzU2aXyCjyfmVii3KUOadhIA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=p/tNiwyunzsFsu78ynqTLZY7yMvitDnz+FHEnEQhBZTkn3UZZ5rERMdNrBHdA50PZFdfzC/xXH/eC5xQsAyFOzIFhUQZYARrod+D4IZL2OpQhvHy+mzC0eM+SCpad/TJCjCIl+ypny7LmPSqGKIqhngtfmYaiWKxGSry+tP1HMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zBCuePux; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vLPwFMwJ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=knxQnRBs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=G+RdLoCA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EAD6C2118E;
	Wed, 12 Mar 2025 14:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1741788312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ttdCheo2ggrWYc5AfXbMLW3x5iUmEU3SoinUwhJvb+4=;
	b=zBCuePuxTdL15mtda27hxhA44U5PtfaieYwLwbODqm5KLJjEwAVScmfhtq2JVBOftJnocU
	MSSM0I2AcrsGcrqUHua+ss9OdmT3+E8jW2deuazu+Bqm65uMhxXg8RgtK/JmRFSMx5hNCJ
	nGJy4aN8hPYPOpxxFED8A6JYb5LoZG4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1741788312;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ttdCheo2ggrWYc5AfXbMLW3x5iUmEU3SoinUwhJvb+4=;
	b=vLPwFMwJwDhkQsUjgJlUKcs+MY+fb2GER5VC48PCCGFbiGeZl1fzkAwQhVuvLGkggeGpQC
	ZBINYQH50ls20XBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1741788306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ttdCheo2ggrWYc5AfXbMLW3x5iUmEU3SoinUwhJvb+4=;
	b=knxQnRBsUB0eEuotZGQwivI4oVYfb1WhrWBcZ9mbITiIUpQhVA8nRAYNRVxCSqg01Wx3LB
	kwUfe6xwVcBsxntre6sMb3eCWF3doyrKDvmZWrBWaMyTFzsjTUggoBXDAYRl9goNqwd3MC
	9m0FsBvoJPGanOey4HH1raatlPnRkWA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1741788306;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ttdCheo2ggrWYc5AfXbMLW3x5iUmEU3SoinUwhJvb+4=;
	b=G+RdLoCAe+HmkHrEpPsk7rA7GoPimKWfHbiC+29hoSniJwhP34hdGI8Yb8X8GhBkenF9fH
	/a8Wofq2UY2qERBA==
Date: Wed, 12 Mar 2025 15:05:07 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
    indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com, 
    irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org, 
    mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev, 
    rostedt@goodmis.org, will@kernel.org, kernel-team@meta.com, 
    Suraj Jitindar Singh <surajjs@amazon.com>, Torsten Duwe <duwe@suse.de>
Subject: Re: [PATCH 2/2] arm64: Implement HAVE_LIVEPATCH
In-Reply-To: <20250308012742.3208215-3-song@kernel.org>
Message-ID: <alpine.LSU.2.21.2503121503340.12980@pobox.suse.cz>
References: <20250308012742.3208215-1-song@kernel.org> <20250308012742.3208215-3-song@kernel.org>
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
	NEURAL_HAM_SHORT(-0.20)[-0.991];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	SEM_URIBL_UNKNOWN_FAIL(0.00)[suse.cz:server fail,test-kprobe.sh:server fail,suse.de:query timed out];
	RCVD_COUNT_ZERO(0.00)[0];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	SEM_URIBL_FRESH15_UNKNOWN_FAIL(0.00)[test-kprobe.sh:server fail,suse.cz:query timed out];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.de:email]
X-Spam-Score: -4.30
X-Spam-Flag: NO

Hi,

On Fri, 7 Mar 2025, Song Liu wrote:

> This is largely based on [1] by Suraj Jitindar Singh.
> 
> Test coverage:
> 
> - Passed manual tests with samples/livepatch.
> - Passed all but test-kprobe.sh in selftests/livepatch.
>   test-kprobe.sh is expected to fail, because arm64 doesn't have
>   KPROBES_ON_FTRACE.

Correct. The test should take into account and bail out.

> - Passed tests with kpatch-build [2]. (This version includes commits that
>   are not merged to upstream kpatch yet).
> 
> [1] https://lore.kernel.org/all/20210604235930.603-1-surajjs@amazon.com/
> [2] https://github.com/liu-song-6/kpatch/tree/fb-6.13
> Cc: Suraj Jitindar Singh <surajjs@amazon.com>
> Cc: Torsten Duwe <duwe@suse.de>
> Signed-off-by: Song Liu <song@kernel.org>

Acked-by: Miroslav Benes <mbenes@suse.cz>

Also as mentioned in the other thread, parts of this patch will go once 
arm64 is converted to generic entry infrastructure.

Thank you,
Miroslav

