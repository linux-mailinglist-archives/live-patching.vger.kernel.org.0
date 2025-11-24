Return-Path: <live-patching+bounces-1879-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE6DC82BE0
	for <lists+live-patching@lfdr.de>; Mon, 24 Nov 2025 23:51:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 47DD234B4A1
	for <lists+live-patching@lfdr.de>; Mon, 24 Nov 2025 22:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2D026B741;
	Mon, 24 Nov 2025 22:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JqS8vIez"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460EF23D7E3;
	Mon, 24 Nov 2025 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024665; cv=none; b=qNdsg4qFYDYq1m7YIxOD2BYNDHndWnTThIz3O75zEvmRIL4Gq0MJC3gCgN4jRPK5wWM2NB8Xhd/IggNjHfYZZabsc5IqGfFzqmNotHC4Mfhfphz9b8BB5b5VlDHc1c7kIKkrJgp1j9uEq3wP7g5tucOvuXcgnGvFl97OH3S+dd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024665; c=relaxed/simple;
	bh=dJGUteN12IWe//z3GcWaW4wh9agCowwsiOVkhxXu6Oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1qwdbh6DN0mx0fEigljTiCSAwah9p5gpmrzev8DUrY+NR+ca5PfrYHYdNr9MYnfg9qp2uPnPsCLmzkHAIhP3HoF7rI+f4nh1CFAP6RzxNVgaRkzF2aS3GUwKXnQeLopElxJ9EiKO9IHiaVM8rYETxMedxfJcIkJkXTz0wwnL38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JqS8vIez; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25348C4CEF1;
	Mon, 24 Nov 2025 22:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764024663;
	bh=dJGUteN12IWe//z3GcWaW4wh9agCowwsiOVkhxXu6Oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JqS8vIez5LKSshzxJ8oUAbDcy9CX2Ua/oDs5bQ20DOsJ3w58hPZuTVv729JA8JIB1
	 lfUGmtsxljHV2xtovgN+b/gobQ/NGtxqAolivBDGBlwQ2zRTX2phzvzBO09F5FKP7n
	 AMYihnkIJWK+gNjuz9zy0N6dTmEKflKWOu+ZLVW2hT0TXh8aT9oJLQ6MtFFOO2HMEV
	 ODLL9db9OHXfTtlbFxY8wrmhrW+++l2AiQAHgBozAlnUf3BzJ++iiSc2TohWaUTLzg
	 wNCXNZX8fU5it0L5lySAji2nZNrQ0q6RfWRoZx3Usy1SXmWnccy7qft3dGbn4ir+1h
	 RSFmQTBqzL+vA==
Date: Mon, 24 Nov 2025 14:51:01 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Miroslav Benes <mbenes@suse.cz>, bpf@vger.kernel.org, 
	live-patching@vger.kernel.org, DL Linux Open Source Team <linux-open-source@crowdstrike.com>, 
	Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, andrii@kernel.org, 
	Raja Khan <raja.khan@crowdstrike.com>
Subject: Re: [External] Re: BPF fentry/fexit trampolines stall livepatch
 stalls transition due to missing ORC unwind metadata
Message-ID: <3irfgmzksrfchngic6eowdu7ii5a5axrx5ofgneqastd4cjkpk@xrhabkis5z2k>
References: <0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com>
 <alpine.LSU.2.21.2511201311570.16226@pobox.suse.cz>
 <h4e7ar2fckfs6y2c2tm4lq4r54edzvqdq6cy5qctb7v3bi5s2u@q4hfzrlembrn>
 <d7b75cdc-a872-4425-a5f6-d41b1982cca7@crowdstrike.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d7b75cdc-a872-4425-a5f6-d41b1982cca7@crowdstrike.com>

On Mon, Nov 24, 2025 at 05:06:04PM -0500, Andrey Grodzovsky wrote:
> > Andrey, can you try this patch?
> 
> Hey Josh, thank you for looking, can you please advise the stable
> kernel version you have made this changes on top off so I can cleanly
> apply ? Alternatively just provide git commit sha in Linus
> tree I can reset my branch to.
> 
> 
> I will happily test this as soon as I can and report back.

It's based on Linus's tree.

-- 
Josh

