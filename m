Return-Path: <live-patching+bounces-1430-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF8BAB5E80
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 23:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F340719E311E
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 21:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B640201268;
	Tue, 13 May 2025 21:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZbgPHC7Y"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DB31FBC90;
	Tue, 13 May 2025 21:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747172455; cv=none; b=UryBc+2oWkEYFaGArA499A5xJGrV2VnEj6O5UBidnbrBT4fG+tk5pUgDtxpSi72UYZqhiZ5cYze2MmQSpx63cWclg2Gx+hyk0wCK76baAT/rpXUa3CGSFXzdeEm70ply5OZsUVAb7gyqbjcS6j8MRmgn+sG9UyiM5ys/kF8xLJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747172455; c=relaxed/simple;
	bh=yXb8txYJm6mJkCI6iPW8AnmDF85fxh1wy2Mr6nQRybo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EWGSWUAgWL91WomRx3NY9fWZw3d1pvmW/APMjAkmbEvhVXC59/Pf5jG/SPmJ83/LL1FKRr59eLdSCrETal6sizMFD6es0pqg2UUboHUUYELg8bz9UGD6UBoUP2I8f0bLWqPcnj+4d3jHj3ZI7xVC/4PhgC3/0YPXv3vZ3wnc3kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZbgPHC7Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EF6C4CEEB;
	Tue, 13 May 2025 21:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747172454;
	bh=yXb8txYJm6mJkCI6iPW8AnmDF85fxh1wy2Mr6nQRybo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZbgPHC7YRjvDkaDvE7bgKN2T5jPjFWOqcEPNbM2FLgP9hv5E3XIsYjBm9abdCgahh
	 rGWxBN2ZU+odXoUSHkZ88MiXwPYfuwdN0YO4gM6JGcakEafRHth5BZQTjAK7qHdXN9
	 knhwE20Ax958MV6FLbHT4ri++40W1LmyvO92osDj4l4zk8CqdZK5C4Ht9HdzlmFeMf
	 vBwMpIrA0byckfGHBx/l1DJ4sDh3c13J15m0r6dQnwVgFxTsOFu+9c4lu+CpdgIzow
	 lUC9vQMEsozZZEoGjrOkfcf/KTp4lmJD1Amc476Htrjr7GIg4DatxP1mdADrLw9Y01
	 FgqcPzP+2BlMg==
Date: Tue, 13 May 2025 14:40:51 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, mingo@kernel.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com, 
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] sched,livepatch: Untangle cond_resched() and
 live-patching
Message-ID: <kdg7dlwiec53dqtf37qx4whsra6ahplgxpdc7zg6mpr5eshkvp@wmct3blis2js>
References: <20250509113659.wkP_HJ5z@linutronix.de>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250509113659.wkP_HJ5z@linutronix.de>

On Fri, May 09, 2025 at 01:36:59PM +0200, Sebastian Andrzej Siewior wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> With the goal of deprecating / removing VOLUNTARY preempt, live-patch
> needs to stop relying on cond_resched() to make forward progress.
> 
> Instead, rely on schedule() with TASK_FREEZABLE set. Just like
> live-patching, the freezer needs to be able to stop tasks in a safe /
> known state.
> 
> Compile tested only.
> 
> [bigeasy: use likely() in __klp_sched_try_switch() and update comments]
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh

