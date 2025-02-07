Return-Path: <live-patching+bounces-1131-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3FEA2C9A3
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 18:01:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC942188F418
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 17:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92D419EEC2;
	Fri,  7 Feb 2025 16:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqwqZApL"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A913219E967;
	Fri,  7 Feb 2025 16:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738947556; cv=none; b=RWupNrPQsfhbkWpIk2XIJOuvsjGDIZOavkfFPNW5iw/jijHzngIJwCjCwe7Np3/ZqWbGoVyxSlSWAWCKWlAdMYNjvVEdkDRImDL+SyB9cBR4Oe+7XE5fjVphNF6ncEYJeV9PGHm6DAKuAB68dBqn8K32Lk5Zsxx7NJQn6b3dfrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738947556; c=relaxed/simple;
	bh=kWYBfEAgnVskwvsy/jXQb2I8lmj7Svpbg1pitdgPsqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=etrwieUykMrfJeI78Ei40L6SPS5RirUl0v5Wy3jJyrnngJanTjE1pluonDcmPc3+bjYnHXpsQcvHMb4EYeJdZnBS+BHOiCLZBSckhYUjg6CPt0HjfcJlI4Prf14awc3XjUCR9fC1YhxbzPjcpRedh8pN6lP02GXuIcWkHtuh1AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqwqZApL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C388FC4CEE6;
	Fri,  7 Feb 2025 16:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738947556;
	bh=kWYBfEAgnVskwvsy/jXQb2I8lmj7Svpbg1pitdgPsqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lqwqZApLxNSnXI3YhElwnWv3zw51+bz7H/EARjrfWsmMbFUuIe6My3j+oRsf2KjAq
	 jGnJw+6CmLnAesrc9uK6RSp3uRWy+8YDyDBcSglE8gjFt3PCQXlKcSKF6MvAGgoza+
	 WJ77r2u3OsESE92ZyhNe/QWGE6k3oHAbNdbSnH0aTM6XLcM2xdCHyJ7eF/aAducbUm
	 tzLgo9qujdZJoKuk9xtsTD+Z2c8+xppJRqnXKab+oRZQwTrbXXT+dgfDUIlGSxrrEX
	 tQb/iE/Pkfi+bUDWNGy2JKTvDSTL80PZYaKmwurj3D3p2nst06RfAZ+caEfAzuzOJZ
	 y7HQhy/w1OM1A==
Date: Fri, 7 Feb 2025 08:59:13 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
Message-ID: <20250207165913.f4wp72k6g64tqgin@jpoimboe>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
 <20250127063526.76687-3-laoar.shao@gmail.com>
 <20250207023116.wx4i3n7ks3q2hfpu@jpoimboe>
 <CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ+M0zgdXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ+M0zgdXg@mail.gmail.com>

On Fri, Feb 07, 2025 at 11:16:45AM +0800, Yafang Shao wrote:
> On Fri, Feb 7, 2025 at 10:31 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > Why does this happen?
> 
> It occurs during the KLP transition. It seems like the KLP transition
> is taking too long.
> 
> [20329703.332453] livepatch: enabling patch 'livepatch_61_release6'
> [20329703.340417] livepatch: 'livepatch_61_release6': starting
> patching transition
> [20329715.314215] rcu_tasks_wait_gp: rcu_tasks grace period 1109765 is
> 10166 jiffies old.
> [20329737.126207] rcu_tasks_wait_gp: rcu_tasks grace period 1109769 is
> 10219 jiffies old.
> [20329752.018236] rcu_tasks_wait_gp: rcu_tasks grace period 1109773 is
> 10199 jiffies old.
> [20329754.848036] livepatch: 'livepatch_61_release6': patching complete

How specifically does the KLP transition trigger rcu_tasks workings?

> Before the new atomic replace patch is added to the func_stack list,
> the old patch is already set to nop. If klp_ftrace_handler() is
> triggered at this point, it will effectively do nothing—in other
> words, it will execute the original function.
> I might be wrong.

That's not actually how it works.  klp_add_nops() probably needs some
better comments.

It adds nops to the *new* patch so that all the functions in the old
patch(es) get replaced, even those which don't have a corresponding
function in the new patch.

The justification for your patch seems to be "here are some bugs, this
patch helps work around them", which isn't very convincing.  Instead we
need to understand the original bugs and fix them.

-- 
Josh

