Return-Path: <live-patching+bounces-1194-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C716A358FE
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 09:36:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9DB21890AB8
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 08:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C001F8908;
	Fri, 14 Feb 2025 08:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MF2IKrZN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAC3158D96
	for <live-patching@vger.kernel.org>; Fri, 14 Feb 2025 08:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739522166; cv=none; b=VlpZRA/mtk32Xolz1n+sEbi86XT0B/JE6RELGocVaeOCSY/BG3uoaRITtZfU3qVAdsbB8ZDImtWTeWvPR+K0rSnYE6VGhr6A0F+3Uv92kNxepRhOdkMkMNIrg/NJCHSRIQxEuLWzN4+qkLBsNYTC8pR17p1AQfkwFr5QCNu8z6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739522166; c=relaxed/simple;
	bh=zgkS1fxOVebU/xeny96yplOyfNjv7O007HArAyqelus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YOIO/cI5nAThAzxIBKBiEd7/6k7/gs13NUG2gjlmCPEEpY3vDoK9KIl5EqqR5VgiRKfZC9w2oiRdXDx8DVh0CADWwN/P69WfNf+NADb5a+rPGx386dsLboqPSIR56lZweELZi6qVrWCF3IGqefTIhR0tY8qIUxehdw7liTESnGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MF2IKrZN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F25C4CED1;
	Fri, 14 Feb 2025 08:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739522165;
	bh=zgkS1fxOVebU/xeny96yplOyfNjv7O007HArAyqelus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MF2IKrZNhHfggDcZ7cC/16g9lVQb+Qd4eL3SweUNX7VwgReVUd/97y+X1gi15fIle
	 xV6wxQGQUTvsCVsw6rEum3/0e5TvUK3LVaOMNC7kArlyBP0FYoTxtpubpLRIjE4mJL
	 DEGMeA+2cV3KfYTFuC3WibgNJKTqRf/9MpMV3eEs8luYLFdugeD5t4BBdd4oGe8rBp
	 hzvfBIEYVFvBoXEstU/vsQ1SHb85VXV2Z33BU1j73exgxAZ9ZEs0jc4AMtQA2a2BeF
	 R6V0gmsFexZdYShDWLOoaWLhtA0wqEiztfgKbYYY/3YLd1YFDr5T/BE4eeFS9NEzhD
	 A2geQQuTmzI0w==
Date: Fri, 14 Feb 2025 00:36:03 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: Find root of the stall: was: Re: [PATCH 2/3] livepatch: Avoid
 blocking tasklist_lock too long
Message-ID: <20250214083603.53roteiobbd5s4de@jpoimboe>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
 <Z63VUsiaPsEjS9SR@pathway.suse.cz>
 <CALOAHbDEcUieW=AcBYHF1BUfQoAi540BNPEP5XR3CApu=3vMNQ@mail.gmail.com>
 <CALOAHbD+JYnC0fR=BaUvD9u0OitHM310ErzN8acPkFZZwH-dJQ@mail.gmail.com>
 <CALOAHbB46k0kqaH8BZk+iyL46bMbz03Z8sk7N+XuYM3kthTsNw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALOAHbB46k0kqaH8BZk+iyL46bMbz03Z8sk7N+XuYM3kthTsNw@mail.gmail.com>

On Fri, Feb 14, 2025 at 10:44:59AM +0800, Yafang Shao wrote:
> The longest duration of klp_try_complete_transition() ranges from 8.5
> to 17.2 seconds.
> 
> It appears that the RCU stall is not only driven by num_processes *
> average_klp_try_switch_task, but also by contention within
> klp_try_complete_transition(), particularly around the tasklist_lock.
> Interestingly, even after replacing "read_lock(&tasklist_lock)" with
> "rcu_read_lock()", the RCU stall persists. My verification shows that
> the only way to prevent the stall is by checking need_resched() during
> each iteration of the loop.

I'm confused... rcu_read_lock() shouldn't cause any contention, right?
So if klp_try_switch_task() isn't the problem, then what is?

I wonder if those function timings might be misleading.  If
klp_try_complete_transition() gets preempted immediately when it
releases the lock, it could take a while before it eventually returns.
So that funclatency might not be telling the whole story.

Though 8.5 - 17.2 seconds is a bit excessive...

-- 
Josh

