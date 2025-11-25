Return-Path: <live-patching+bounces-1881-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DF6E8C82E7A
	for <lists+live-patching@lfdr.de>; Tue, 25 Nov 2025 01:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AAEC44E0F8A
	for <lists+live-patching@lfdr.de>; Tue, 25 Nov 2025 00:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C07C18AFD;
	Tue, 25 Nov 2025 00:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bw/NWLWH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5AEB67E;
	Tue, 25 Nov 2025 00:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764029211; cv=none; b=mYlAHgTKZhlCWJAbVMe8WhVIuZy0m+BcXxga/NqidVVWxYeoZG/WgbExj3dWlgqw8vQRwxC2rnEQDHZC9mH4OfwqoeexXTozK/PxerQ/LrRC+NoDIp/rWb1s5l7xEpH8I12qhgb7hmfXKcvpmEdi1SXGIUd8sz2nd4T7vBRdcW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764029211; c=relaxed/simple;
	bh=rlKn04p/uurcfsAWxZO+S/UN4u6jWw76fKp0/1WA5N0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbmWOckanJ92/+0JmAN3qMogJ/8z3xHRtq0oRT7ZbCnBGO6+ZiXIC032sWsx9/ocypLyOmy7St33JMkUfyFYeXtsYlv4qPwTdEnNQMHk7saWiYIBzhfX3GF89B9p8fvPl/je43wXpfpuxnRuNbkmy29oZBn7Xbv6dChwjL7mk6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bw/NWLWH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EC2C4CEF1;
	Tue, 25 Nov 2025 00:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764029210;
	bh=rlKn04p/uurcfsAWxZO+S/UN4u6jWw76fKp0/1WA5N0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bw/NWLWHPGd2qUA4B8McPowJQ0RA/+6myMiHyozkW41rBn4fDpMBpyWpeg01u5m0c
	 StsUdtYJU/2ogdIDaLpHiiEcHc2HtrMHL6KDHDX0kzNamrgI8BmSB9Okj0Ao5/jmfw
	 qXuyO3vNMZz+hMEOKfbT7nmUSXv3IVMtyfi3SJy6r7vqMiAQUYnl/V+J1pRG6N67c9
	 haVB1mOFFtbHl9tRPMJMzh50mywciqsDQhg91WuoZS/OBkg3hJgcaBtD4UGPGgGzH0
	 nM/ki64N3dPqPnOu5cG5//UCUqKVpKJ+MkOEdJA5o3DfQ31HNqE8FMAIGI/c3zdnTg
	 un9Gdd9C7fs1w==
Date: Mon, 24 Nov 2025 16:06:48 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Miroslav Benes <mbenes@suse.cz>, bpf@vger.kernel.org, 
	live-patching@vger.kernel.org, DL Linux Open Source Team <linux-open-source@crowdstrike.com>, 
	Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, andrii@kernel.org, 
	Raja Khan <raja.khan@crowdstrike.com>
Subject: Re: [External] Re: BPF fentry/fexit trampolines stall livepatch
 stalls transition due to missing ORC unwind metadata
Message-ID: <755zk5mhyujqwnrbiwanbz6emfv4d3ohuocx5modw5i23tnerf@ydbdhw2bnxkf>
References: <0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com>
 <alpine.LSU.2.21.2511201311570.16226@pobox.suse.cz>
 <h4e7ar2fckfs6y2c2tm4lq4r54edzvqdq6cy5qctb7v3bi5s2u@q4hfzrlembrn>
 <d7b75cdc-a872-4425-a5f6-d41b1982cca7@crowdstrike.com>
 <3irfgmzksrfchngic6eowdu7ii5a5axrx5ofgneqastd4cjkpk@xrhabkis5z2k>
 <30ddcf30-f176-48f5-b00f-967f5409243f@crowdstrike.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <30ddcf30-f176-48f5-b00f-967f5409243f@crowdstrike.com>

On Mon, Nov 24, 2025 at 05:54:15PM -0500, Andrey Grodzovsky wrote:
> On 11/24/25 17:51, Josh Poimboeuf wrote:
> > On Mon, Nov 24, 2025 at 05:06:04PM -0500, Andrey Grodzovsky wrote:
> > > > Andrey, can you try this patch?
> > > 
> > > Hey Josh, thank you for looking, can you please advise the stable
> > > kernel version you have made this changes on top off so I can cleanly
> > > apply ? Alternatively just provide git commit sha in Linus
> > > tree I can reset my branch to.
> > > 
> > > 
> > > I will happily test this as soon as I can and report back.
> > 
> > It's based on Linus's tree.
> > 
> 
> Latest more or less ?

Yes, it still applies to his latest master (v6.18-rc7).

-- 
Josh

