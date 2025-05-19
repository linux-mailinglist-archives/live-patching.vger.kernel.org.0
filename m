Return-Path: <live-patching+bounces-1440-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5369CABC4CA
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 18:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5B463AAF60
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 16:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E4B2874EF;
	Mon, 19 May 2025 16:40:41 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC23283FDC;
	Mon, 19 May 2025 16:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747672841; cv=none; b=IEPAHkPOZulpnY59SObAPH+Br4eARB4nVyypR7wsnTaGOQMzmZP7ZCeXOG051UArA+sIdwNkUKRkdxBeCqtm/tph7HUb0JvU2XPUvrQsWSPSh2meahdB/ZZvJ74jVZL3LRxG9z4vwYtzbp4Nitl/nHYMLuIpnMYSv2kTXbXtugU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747672841; c=relaxed/simple;
	bh=ok3hf+ijd2mlfIKeyHy3icFw3GSdz7RItoOTVT8fpzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lH3z+PCDzAAOKqvqLEbNv/Ues29yyKrSo2FKt0Shh/zjB5rrCl73aocHqO2I3LduJk50KzkXUsz48wVRXQe8f3IqytumXU0/nMvY9QJ6U90sVd7qnXkt2pQS7NPVVx0Tl8oRfvRU3kLzAFUAiwxV/dVyul1cBGJpXU06RJx+TzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0299113E;
	Mon, 19 May 2025 09:40:25 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F6E93F5A1;
	Mon, 19 May 2025 09:40:36 -0700 (PDT)
Date: Mon, 19 May 2025 17:40:33 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Song Liu <song@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-toolchains@vger.kernel.org,
	live-patching@vger.kernel.org, indu.bhagat@oracle.com,
	puranjay@kernel.org, wnliu@google.com, irogers@google.com,
	joe.lawrence@redhat.com, jpoimboe@kernel.org, peterz@infradead.org,
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/2] arm64: livepatch: Enable livepatch without sframe
Message-ID: <aCtfAcg32kbczs-g@J2N7QTR9R3>
References: <20250320171559.3423224-1-song@kernel.org>
 <Z_fhAyzPLNtPf5fG@pathway.suse.cz>
 <CAPhsuW4MAcVpXmZVQauoaYe0o3tDvvZfgmCrYFFyFojYpNiWWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4MAcVpXmZVQauoaYe0o3tDvvZfgmCrYFFyFojYpNiWWg@mail.gmail.com>

On Fri, May 16, 2025 at 09:53:36AM -0700, Song Liu wrote:
> ARM folks, please share your thoughts on this work. To fully support
> livepatching of kernel modules, we also need [1]. We hope we can
> land this in the 6.16 kernel.
> 
> Thanks,
> Song
> 
> [1] https://lore.kernel.org/linux-arm-kernel/20250412010940.1686376-1-dylanbhatch@google.com/

I've had a quick look at [1], and IIUC that's a hard prerequisite for
livepatching, as without it the kernel *will* crash if it attempts a
late module relocation.

Given that, I don't think that we can take patch 2 until Will's comments
on [1] have been addressed, but I think that we could take patch 1 (with
fixups) as per my other reply.

Mark.

