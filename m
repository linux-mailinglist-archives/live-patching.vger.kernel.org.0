Return-Path: <live-patching+bounces-1439-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 736AAABC074
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 16:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2FAC7AE09E
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 14:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9029C28153C;
	Mon, 19 May 2025 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5Xj6nrf"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB627E7E3;
	Mon, 19 May 2025 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747664529; cv=none; b=KLwjPS1Ccr11NugkaLpDgJUQ99bQ3bn7Qpb2PnNzbEgnB1hEgXUMzDmrPKy8tfPWY0tkAJou7PoQtEAJIf93q2IM+/o04pBBvGdsAOrsVyw9ykJexeSaA7NJOGbxx/coL8YYPQqrZspKmejqJ0HaL22ajcJVzbvaCzEyc3jzro0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747664529; c=relaxed/simple;
	bh=rwYuCyW7EYGc7OitizTfiKDPCb/T39R026WxPZkwQM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W43F8zYwdlmWBXVd7zdRUoy+a+N1qj0cqA9F7TQlQWquw0JBFYn2IqO0WQasEXlZ+yLvtH1h2VB1pmeKuQw3rW/BSr1c+QFP7gyB+cp/tY9hYWh9loFHLbSsdjNeLjH7eobY+S68C7inIdkf+feAbUy+jLZBf4OoA2onybZe1Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5Xj6nrf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C429C4CEE4;
	Mon, 19 May 2025 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747664529;
	bh=rwYuCyW7EYGc7OitizTfiKDPCb/T39R026WxPZkwQM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i5Xj6nrfuCj5Ihu0HSp/hyuNFZjqhkmvCxUBGOJRY6X4GDuLfpfVz+Ter7WXX0rLn
	 MY7JcML+KD/q9MWRnw0vP1KOk12uX0bg9WBY6fv1DpiKbnhUQWt2EEwSuciUunCikX
	 tOT3pbTQEbtygWX9E3SGdZQFXj6duB9Y20hACsVZt6tSY+35WecfS0F6lixmtmN3rB
	 PKFda22fylwc0ZxSIV9X27bhaDY+mtv/fne3lGt3reYIUJ+ZDn7Pq559o0/m8AHjDq
	 s4K63IUc01DKyJj2JGhAzggEj6YN/PQ4WhaGDPYhpnq7ZN4c+Nw//pf57YXBI/QNPr
	 ZJ75iVorAOjNw==
Date: Mon, 19 May 2025 15:22:03 +0100
From: Will Deacon <will@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org,
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com,
	irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org,
	peterz@infradead.org, roman.gushchin@linux.dev, rostedt@goodmis.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/2] arm64: livepatch: Enable livepatch without sframe
Message-ID: <20250519142202.GD16991@willie-the-truck>
References: <20250320171559.3423224-1-song@kernel.org>
 <Z_fhAyzPLNtPf5fG@pathway.suse.cz>
 <CAPhsuW4MAcVpXmZVQauoaYe0o3tDvvZfgmCrYFFyFojYpNiWWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW4MAcVpXmZVQauoaYe0o3tDvvZfgmCrYFFyFojYpNiWWg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 16, 2025 at 09:53:36AM -0700, Song Liu wrote:
> On Thu, Apr 10, 2025 at 8:17 AM Petr Mladek <pmladek@suse.com> wrote:
> >
> [...]
> > >
> > > [1] https://lore.kernel.org/live-patching/20250127213310.2496133-1-wnliu@google.com/
> > > [2] https://lore.kernel.org/live-patching/20250129232936.1795412-1-song@kernel.org/
> > > [3] https://sourceware.org/bugzilla/show_bug.cgi?id=32589
> > > [4] https://lore.kernel.org/linux-arm-kernel/20241017092538.1859841-1-mark.rutland@arm.com/
> > >
> > > Changes v2 => v3:
> > > 1. Remove a redundant check for -ENOENT. (Josh Poimboeuf)
> > > 2. Add Tested-by and Acked-by on v1. (I forgot to add them in v2.)
> >
> > The approach and both patches look reasonable:
> >
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
> >
> > Is anyone, Arm people, Mark, against pushing this into linux-next,
> > please?
> 
> Ping.
> 
> ARM folks, please share your thoughts on this work. To fully support
> livepatching of kernel modules, we also need [1]. We hope we can
> land this in the 6.16 kernel.
> 
> Thanks,
> Song
> 
> [1] https://lore.kernel.org/linux-arm-kernel/20250412010940.1686376-1-dylanbhatch@google.com/


FWIW: I reviewed the patch above ([1]) already but didn't hear anything
back.

Will

