Return-Path: <live-patching+bounces-1041-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D86CA1AE16
	for <lists+live-patching@lfdr.de>; Fri, 24 Jan 2025 02:08:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BF6F3AAAAB
	for <lists+live-patching@lfdr.de>; Fri, 24 Jan 2025 01:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E9560890;
	Fri, 24 Jan 2025 01:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3QZhcnG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33C94C91
	for <live-patching@vger.kernel.org>; Fri, 24 Jan 2025 01:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737680930; cv=none; b=NAub+3qtwB0noS6+V9b2hjhcq2sNSXSdELWT8rpfOzfnErQ3BEGe1mwjQKo9mFA1Y7rbK50+3xCXYR8QNz68xEhlJSZaob6BQPjH3APg+09FSUnn76xJVqcXlQQG0OeDt+19t4YBOFAqIjDgpWM5eTdb1dxPPQuBmFQqnuAXhgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737680930; c=relaxed/simple;
	bh=f20QzV9WGkOgXOic8tdk8ef275yBlmge76fuyhs4JtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJHyDLpjp9bhmi7+UXrQ9Sq1t563KJGbq45hryZ4QBWtmwA08zkgv7+VB96V6/S6G+0kiNUC7RYCGVd1O4kwsfXk5yINO9eaXbg6tPxtcttlSlAEpwc/Fiws+rPIN/wzfPLLGzf+1fs8KO1HgCy5ms3aTmPRJkqDxQ/7awNhzZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3QZhcnG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29DAC4CED3;
	Fri, 24 Jan 2025 01:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737680930;
	bh=f20QzV9WGkOgXOic8tdk8ef275yBlmge76fuyhs4JtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K3QZhcnGP3fdnX0tckLdikg6lpJboqcyoE/RxXrwxS36EFlE1Re1+uQgRKtl+dySC
	 mrzUKD6MAzYVZv28dBtBphKSlkTpL0e3mSa+JapJJW2O6x062NVf3G+7g2tCgphcNG
	 OpBsQqNjBWpkLeR8iXMzLU/O+pB4Jcr8PzZOO9IBnRmN30DucO2J4a0S0cw1uybM9j
	 4utGU00VxZ3KlyD6IoaQGBcpTs9SB8AygCCKR5fwWxhGs47qfkuf1z0vLneSnfjzlL
	 3I6v1gcdDa3DtlQJ1MZdvazC7wmf3kjeds2jTZ4TlAMUr9IW4/iPUrbxXpX4BoAhkT
	 mR7rR4wkhQWkQ==
Date: Thu, 23 Jan 2025 17:08:48 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] Kernel Crash during replacement of livepatch patching
 do_exit()
Message-ID: <20250124010848.pdcxokfsk2ngrowl@jpoimboe>
References: <CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com>
 <CALOAHbAi61nrAqL9OLaAsRa_WoDYUrC96rYTGWZh1b6-Lotupg@mail.gmail.com>
 <Z5DaUvNAMUP0Euoy@pathway.suse.cz>
 <CALOAHbBC2TSoy4fGcCe88pR7Nc1yyN+HYbXJA3O8UwHoRsLtSg@mail.gmail.com>
 <CALOAHbAr8jPgeseW7zPB9mk7tfxN3HDUqFSA__oOvEtobX4-5A@mail.gmail.com>
 <Z5EVL19hj3bnrKjA@pathway.suse.cz>
 <Z5Jmd_Xb7Ug9GxGG@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z5Jmd_Xb7Ug9GxGG@pathway.suse.cz>

On Thu, Jan 23, 2025 at 04:55:35PM +0100, Petr Mladek wrote:
> On Wed 2025-01-22 16:56:31, Petr Mladek wrote:
> > Anyway, I am working on a POC which would allow to track
> > to-be-released processes. It would finish the transition only
> > when all the to-be-released processes already use the new code.
> > It won't allow to remove the disabled livepatch prematurely.

Can we just keep a list of exiting tasks, and use something like
for_each_executing_task() in the transition code?

Tasks-RCU is actually doing something like that already, see
exit_tasks_rcu_start() and exit_tasks_rcu_start_finish().  Maybe we
could use the same list.

-- 
Josh

