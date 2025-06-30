Return-Path: <live-patching+bounces-1611-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA81AEE570
	for <lists+live-patching@lfdr.de>; Mon, 30 Jun 2025 19:16:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E74B817B6AF
	for <lists+live-patching@lfdr.de>; Mon, 30 Jun 2025 17:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E16D42459C4;
	Mon, 30 Jun 2025 17:16:53 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26F7241CB7;
	Mon, 30 Jun 2025 17:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751303813; cv=none; b=cJuWMffNLsL0b731ynLlc2Ti7tRLcurR+mZk4TLCuUMa4rXRCBGDd+W22pQMi52ZKXuvFIsUYPTAMdxDJY7Y+FD6QOKtYA2Hr1JcggcPbRZynEWVm9f1wzB3JyXoCOqXjuWpTownvsnon8YkcunapwH2fmQ9VozLRJG0htQMQXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751303813; c=relaxed/simple;
	bh=LwAN6m7tROMs6LOdXu2EvKHYPn+ncv17qhL0rq5kdoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGveEzAcXN0PzYqUCee1MWvh2aqrPuaHmQWIljedjr5SyZiFAk7AdlsOuZoySh70674CPBKOSGHYv+Xy0+/dJ8g9onDma7HvqeM0PtCStokkcQo6mc6tmB+O00OMkzGuW4wyrKA7/P5t8v+8TrHh+1A02APD/uD5Cftz2GOymC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B07C4CEE3;
	Mon, 30 Jun 2025 17:16:49 +0000 (UTC)
Date: Mon, 30 Jun 2025 18:16:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Song Liu <song@kernel.org>
Cc: Will Deacon <will@kernel.org>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	pmladek@suse.com, joe.lawrence@redhat.com, dylanbhatch@google.com,
	fj6611ie@aa.jp.fujitsu.com, mark.rutland@arm.com,
	kernel-team@meta.com, Suraj Jitindar Singh <surajjs@amazon.com>,
	Torsten Duwe <duwe@suse.de>, Breno Leitao <leitao@debian.org>,
	Andrea della Porta <andrea.porta@suse.com>
Subject: Re: [PATCH v4] arm64: Implement HAVE_LIVEPATCH
Message-ID: <aGLGf5feF4gT-dgR@arm.com>
References: <20250617173734.651611-1-song@kernel.org>
 <aF1JShCkslGkch26@willie-the-truck>
 <CAPhsuW7WY54jYDBtApRRw4mnjM0cZu4GBUZQ58ZHAV+zd79uXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW7WY54jYDBtApRRw4mnjM0cZu4GBUZQ58ZHAV+zd79uXw@mail.gmail.com>

On Thu, Jun 26, 2025 at 07:55:28AM -0700, Song Liu wrote:
> On Thu, Jun 26, 2025 at 6:21 AM Will Deacon <will@kernel.org> wrote:
> > On Tue, Jun 17, 2025 at 10:37:34AM -0700, Song Liu wrote:
> > > This is largely based on [1] by Suraj Jitindar Singh.
> >
> > I think it would be useful to preserve at least some parts of the
> > original commit message here so that folks don't have to pull it out
> > of the list archives if they want to see more about the rationale.
> 
> The relevant message from the original commit message is:
> 
> Allocate a task flag used to represent the patch pending state for the
> task.
> 
> Shall I respin this patch to add this? Or maybe Catalin can add
> this while applying the patch?

Please repost with a more meaningful description and a justification why
a new thread flag is needed.

Thanks.

-- 
Catalin

